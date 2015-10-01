package org.renjin.cran.DBI.columns;

import org.joda.time.format.DateTimeFormatter;
import org.renjin.sexp.AtomicVector;
import org.renjin.sexp.StringArrayVector;
import org.renjin.sexp.StringVector;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Constructs a character vector column from a date-time field in a ResultSet.
 */
public class DateStringColumnBuilder implements ColumnBuilder {
    
    private final StringArrayVector.Builder vector = new StringVector.Builder();
    
    public DateTimeFormatter format;

    public static boolean acceptsType(String columnType) {
        return columnType.equals("datetime");
    }

    public DateStringColumnBuilder(DateTimeFormatter format) {
        this.format = format;
    }

    @Override
    public void addValue(ResultSet rs, int columnIndex) throws SQLException {
        Date date = rs.getDate(columnIndex);
        if(date == null) {
            vector.addNA();
        } else {
            vector.add(format.print(date.getTime()));
        }
    }

    @Override
    public AtomicVector build() {
        return vector.build();
    }
}
