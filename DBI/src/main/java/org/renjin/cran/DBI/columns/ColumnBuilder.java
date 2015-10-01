package org.renjin.cran.DBI.columns;

import org.renjin.sexp.AtomicVector;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Builds a data.frame column from a JDBC ResultSet
 */
public interface ColumnBuilder {

    void addValue(ResultSet rs, int columnIndex) throws SQLException;

    AtomicVector build();
}
