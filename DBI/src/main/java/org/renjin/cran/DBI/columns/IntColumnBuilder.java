package org.renjin.cran.DBI.columns;

import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.IntArrayVector;

import java.sql.ResultSet;
import java.sql.SQLException;


public class IntColumnBuilder implements ColumnBuilder {
    
    private IntArrayVector.Builder vector = new IntArrayVector.Builder();

    public static boolean acceptsType(String columnType) {
      return columnType.endsWith("int") || columnType.equals("wrd") || columnType.startsWith("int");
    }

    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        int value = rs.getInt(columnIndex);
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
