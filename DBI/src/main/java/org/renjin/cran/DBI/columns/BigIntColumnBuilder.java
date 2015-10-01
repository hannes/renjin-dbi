package org.renjin.cran.DBI.columns;

import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.DoubleArrayVector;

import java.sql.ResultSet;
import java.sql.SQLException;

public class BigIntColumnBuilder implements ColumnBuilder {

    public static boolean acceptsType(String columnType) {
        return columnType.equals("bigint");
    }
    
    public DoubleArrayVector.Builder vector = new DoubleArrayVector.Builder();

    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        long value = rs.getLong(columnIndex);
        if(rs.wasNull()) {
            vector.addNA();
        } else {
            vector.add((double)value);
        }
    }

    @Override
    public AtomicVector build() {
        return vector.build();
    }
}
