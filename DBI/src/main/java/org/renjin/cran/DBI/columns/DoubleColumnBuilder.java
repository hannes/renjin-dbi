package org.renjin.cran.DBI.columns;


import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.DoubleArrayVector;

import java.sql.ResultSet;
import java.sql.SQLException;

public class DoubleColumnBuilder implements ColumnBuilder {
    
    private DoubleArrayVector.Builder vector = new DoubleArrayVector.Builder();

    public static boolean acceptsType(String columnType) {
      return columnType.equals("decimal") || columnType.equals("real") || columnType.equals("number")
          || columnType.startsWith("double") || columnType.startsWith("float");
    }

    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        double value = rs.getDouble(columnIndex);
        if(rs.wasNull()) {
            vector.addNA();
        } else {
            vector.add(value);
        }
    }

    public AtomicVector build() {
        return vector.build();
    }
}
