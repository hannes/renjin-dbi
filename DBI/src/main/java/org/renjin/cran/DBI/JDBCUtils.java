package org.renjin.cran.DBI;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.joda.time.format.ISODateTimeFormat;
import org.renjin.cran.DBI.columns.*;
import org.renjin.eval.EvalException;
import org.renjin.primitives.vector.RowNamesVector;
import org.renjin.sexp.ListVector;
import org.renjin.sexp.StringVector;

/**
 * 
 * Utilities to query a database using JDBC API
 * 
 * @author Hannes Mühleisen
 * @author Erwan Bocher
 */
public class JDBCUtils {
    

    /**
     * Check is the ResultSet is closed or if the cursor is after the last row.
     *
     * @param rs
     * @return boolean
     */
    public static boolean hasCompleted(ResultSet rs) {
        try {
            return (rs.isClosed() || rs.isAfterLast());
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * List the tables stored in the database
     *
     * @param con the connection to the database
     * @param types Array of strings to set the table types
     * @return StringVector
     */
    public static StringVector getTables(Connection con, String[] types) {
        try {
            StringVector.Builder sb = new StringVector.Builder();
            DatabaseMetaData dbm = con.getMetaData();
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

    /**
     * List the name of the columns for a table
     *
     * @param con the connection to the database
     * @param table the table name
     * @return StringVector
     */
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

    /**
     * Returns the name and the SQL data type for each column of a table
     *
     * @param rs
     * @return ListVector
     */
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

    /**
     * This is required because Renjn's property accessor fails on the Oracle
     * JDBC driver
     * @param s
     * @return 
     */
    public static ResultSet gimmeResults(Statement s) {
        try {
            return s.getResultSet();
        } catch (SQLException e) {
        }
        return null;
    }
  
    /**
     * Same as above
     * @param c
     * @param newState
     */
    public static void toggleAutocommit(Connection c, boolean newState) {
        try {
            c.setAutoCommit(newState);
        } catch (SQLException e) {
            throw new EvalException(e);
        }
    }

    /**
     * Fetch the columns and row values into Renjin datatypes
     * @param rs
     * @param n
     * @return
     */
    public static ListVector fetch(ResultSet rs, long n) {
        try {
            if (n < 0) {
                n = Long.MAX_VALUE;
            }
            ListVector columnVector = columnInfo(rs);

            int numColumns = columnVector.length();

            /* column builders */
            List<ColumnBuilder> builders = new ArrayList<ColumnBuilder>();
            for (int i = 0; i < numColumns; i++) {
                ListVector columnInfo = (ListVector) columnVector.get(i);
                String columnType = columnInfo.get("type").asString().toLowerCase();

                if (BigIntColumnBuilder.acceptsType(columnType)) {
                    builders.add(new BigIntColumnBuilder());

                } else if (IntColumnBuilder.acceptsType(columnType)) {
                    builders.add(new IntColumnBuilder());

                } else if (DoubleColumnBuilder.acceptsType(columnType)) {
                    builders.add(new DoubleColumnBuilder());

                } else if (LogicalColumnBuilder.acceptsType(columnType)) {
                    builders.add(new LogicalColumnBuilder());

                } else if (StringColumnBuilder.acceptsType(columnType)) {
                    builders.add(new StringColumnBuilder());

                } else if (DateStringColumnBuilder.acceptsType(columnType)) {
                    builders.add(new DateStringColumnBuilder(ISODateTimeFormat.dateTime()));

                } else {
                    throw new EvalException("Unknown column type " + columnInfo);
                }
            }

            long rows = 0;
            /* collect values */
            while (n > 0 && rs.next()) {
                for (int i = 0; i < numColumns; i++) {
                    builders.get(i).addValue(rs, i + 1);
                }
                rows++;
                n--;
            }
            /* call build() on each column and add them as named cols to df */
            ListVector.NamedBuilder dataFrame = new ListVector.NamedBuilder();
            for (int i = 0; i < numColumns; i++) {
                ListVector ci = (ListVector) columnVector.get(i);
                dataFrame.add(ci.get("name").asString(), builders.get(i).build());
            }
            dataFrame.setAttribute("row.names", new RowNamesVector((int) rows));
            dataFrame.setAttribute("class", StringVector.valueOf("data.frame"));
            return dataFrame.build();

        } catch (SQLException e) {
            throw new EvalException(e);
        }
    }

}
