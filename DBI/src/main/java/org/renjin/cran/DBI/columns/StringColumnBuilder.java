package org.renjin.cran.DBI.columns;

import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.StringArrayVector;
import org.renjin.sexp.StringVector;

import java.sql.ResultSet;
import java.sql.SQLException;


public class StringColumnBuilder implements ColumnBuilder {
   
    private StringArrayVector.Builder vector = new StringVector.Builder();

    public static boolean acceptsType(String columnType) {
      return columnType.equals("string") || columnType.equals("text") || columnType.equals("clob")
          || columnType.startsWith("varchar") || columnType.endsWith("char")
          || columnType.equals("date") || columnType.equals("time") || columnType.equals("null")
          || columnType.equals("unknown");
    }

    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        vector.add(rs.getString(columnIndex));
    }

    @Override
    public AtomicVector build() {
        return vector.build();
    }
}
