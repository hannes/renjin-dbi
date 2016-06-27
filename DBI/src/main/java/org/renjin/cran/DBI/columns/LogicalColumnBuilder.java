package org.renjin.cran.DBI.columns;

import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.LogicalArrayVector;

import java.sql.ResultSet;
import java.sql.SQLException;

public class LogicalColumnBuilder implements ColumnBuilder {
    private LogicalArrayVector.Builder vector = new LogicalArrayVector.Builder();

    public static boolean acceptsType(String columnType) {
      return columnType.equals("boolean") ||
             columnType.equals("bit");
    }


    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        boolean value = rs.getBoolean(columnIndex);
        if(rs.wasNull()) {
            vector.addNA();
        } else {
            vector.add(value);
        }
    }

    @Override
    public AtomicVector build() {
        return vector.build();
    }
}
