package org.renjin.cran.DBI;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.renjin.eval.EvalException;
import org.renjin.sexp.DoubleArrayVector;
import org.renjin.sexp.IntArrayVector;
import org.renjin.sexp.ListVector;
import org.renjin.sexp.LogicalArrayVector;
import org.renjin.sexp.StringArrayVector;
import org.renjin.sexp.StringVector;
import org.renjin.sexp.Vector;
import org.renjin.sexp.Vector.Builder;

public class JDBCUtils {

  public static boolean hasCompleted(ResultSet rs) {
    try {
      return (rs.isClosed() || rs.isAfterLast());
    } catch (SQLException e) {
      return false;
    }
  }

  public static StringVector getTables(Connection con) {
    try {
      StringVector.Builder sb = new StringVector.Builder();
      DatabaseMetaData dbm = con.getMetaData();
      String[] types = { "TABLE" };
      ResultSet rsm = dbm.getTables(con.getCatalog(), null, null, types);

      while (rsm.next()) {
        sb.add(rsm.getString("TABLE_NAME"));
      }
      rsm.close();
      return sb.build();
    } catch (SQLException e) {
      throw new EvalException(e);
    }
  }

  public static StringVector getColumns(Connection con, String table) {
    try {
      StringVector.Builder sb = new StringVector.Builder();
      DatabaseMetaData dbm = con.getMetaData();
      ResultSet rsm = dbm.getColumns(con.getCatalog(), null, table, null);
      while (rsm.next()) {
        sb.add(rsm.getString("COLUMN_NAME"));
      }
      rsm.close();
      // try again with an uppercased table name. Hello, Oracle!
      if (sb.length() < 1) {
        rsm = dbm.getColumns(con.getCatalog(), null, table.toUpperCase(), null);
        while (rsm.next()) {
          sb.add(rsm.getString("COLUMN_NAME"));
        }
        rsm.close();
      }
      return sb.build();
    } catch (SQLException e) {
      throw new EvalException(e);
    }
  }

  public static ListVector columnInfo(ResultSet rs) {
    try {
      ListVector.Builder tv = new ListVector.Builder();
      ResultSetMetaData rsm = rs.getMetaData();
      for (int i = 1; i < rsm.getColumnCount() + 1; i++) {
        ListVector.NamedBuilder cv = new ListVector.NamedBuilder();
        cv.add("name", rsm.getColumnName(i));
        cv.add("type", rsm.getColumnTypeName(i));
        tv.add(cv.build());
      }
      return tv.build();
    } catch (SQLException e) {
      throw new EvalException(e);
    }
  }

  /*
   * this is required because Renjn's property accessor fails on the Oracle JDBC
   * driver
   */
  public static ResultSet gimmeResults(Statement s) {
    try {
      return s.getResultSet();
    } catch (SQLException e) {
    }
    return null;
  }
  
  /* same as above */
  public static void toggleAutocommit(Connection c, boolean newState) {
    try {
      c.setAutoCommit(newState);
    } catch (SQLException e) {
    }
  }

  public static enum RTYPE {
    INTEGER, NUMERIC, CHARACTER, LOGICAL
  };

  public static ListVector fetch(ResultSet rs, long n) {
    try {
      if (n < 0) {
        n = Long.MAX_VALUE;
      }
      ListVector ti = columnInfo(rs);
      /* cache types, we need to look this up for *every* value */
      RTYPE[] rtypes = new RTYPE[ti.length()];
      /* column builders */
      Map<Integer, Builder<Vector>> builders = new HashMap<Integer, Builder<Vector>>();
      for (int i = 0; i < ti.length(); i++) {
        ListVector ci = (ListVector) ti.get(i);
        String tpe = ci.get("type").asString().toLowerCase();
        rtypes[i] = null;
        if (tpe.endsWith("int") || tpe.equals("wrd") || tpe.startsWith("int")) {
          // TODO: long values?
          builders.put(i, new IntArrayVector.Builder());
          rtypes[i] = RTYPE.INTEGER;
        }
        if (tpe.equals("decimal") || tpe.equals("real") || tpe.equals("number")
            || tpe.startsWith("double") || tpe.startsWith("float")) {
          builders.put(i, new DoubleArrayVector.Builder());
          rtypes[i] = RTYPE.NUMERIC;
        }
        if (tpe.equals("boolean")) {
          builders.put(i, new LogicalArrayVector.Builder());
          rtypes[i] = RTYPE.LOGICAL;
        }
        if (tpe.equals("string") || tpe.equals("text") || tpe.equals("clob")
            || tpe.startsWith("varchar") || tpe.endsWith("char")
            || tpe.equals("date") || tpe.equals("time") || tpe.equals("null")
            || tpe.equals("unknown")) {
          builders.put(i, new StringArrayVector.Builder());
          rtypes[i] = RTYPE.CHARACTER;
        }
        if (rtypes[i] == null) {
          throw new EvalException("Unknown column type " + ci);
        }
      }

      int ival;
      double nval;
      boolean lval;
      String cval;
      long rows = 0;
      /* collect values */
      while (n > 0 && rs.next()) {
        rows++;
        for (int i = 0; i < rtypes.length; i++) {
          Builder<Vector> bld = builders.get(i);
          switch (rtypes[i]) {
          case INTEGER:
            /* Behold the beauty of JDBC */
            ival = rs.getInt(i + 1);
            if (rs.wasNull()) {
              bld.addNA();
            } else {
              ((IntArrayVector.Builder) bld).add(ival);
            }
            break;
          case NUMERIC:
            nval = rs.getDouble(i + 1);
            if (rs.wasNull()) {
              bld.addNA();
            } else {
              ((DoubleArrayVector.Builder) bld).add(nval);
            }
            break;
          case LOGICAL:
            lval = rs.getBoolean(i + 1);
            if (rs.wasNull()) {
              bld.addNA();
            } else {
              ((LogicalArrayVector.Builder) bld).add(lval);
            }
            break;
          case CHARACTER:
            cval = rs.getString(i + 1);
            if (rs.wasNull()) {
              bld.addNA();
            } else {
              ((StringArrayVector.Builder) bld).add(cval);
            }
            break;
          }
        }
        n--;
      }
      /* call build() on each column and add them as named cols to df */
      ListVector.NamedBuilder dfb = new ListVector.NamedBuilder();
      for (int i = 0; i < ti.length(); i++) {
        ListVector ci = (ListVector) ti.get(i);
        dfb.add(ci.get("name").asString(), builders.get(i).build());
      }
      /* I'm a data.frame object */
      IntArrayVector.Builder rnb = new IntArrayVector.Builder();
      for (long i = 1; i <= rows; i++) {
        rnb.add(i);
      }
      dfb.setAttribute("row.names", rnb.build());
      dfb.setAttribute("class", StringVector.valueOf("data.frame"));
      ListVector lv = dfb.build();
      return lv;
    } catch (SQLException e) {
      throw new EvalException(e);
    }
  }
}
