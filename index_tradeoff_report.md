# SmartFactory Index Trade-off Report

## Diagnosis

The legacy `idx_fat_covering` index contains five columns:

`(sensor_id, recorded_at, temperature, humidity, status)`.

This makes the index covering for the Dashboard query because MySQL can retrieve the requested temperature, humidity and status directly from the index without performing a table lookup. This can improve SELECT performance.

However, SmartFactory is an IoT system with a very high INSERT rate. Every new record must maintain the secondary index. Because the index contains additional frequently changing columns, each index entry requires more storage and increases write I/O, memory pressure, logging and B-tree maintenance.

## Optimization

The replacement index is:

`idx_lean_search(sensor_id, recorded_at)`.

These are the columns required by the Dashboard WHERE condition. The query can still use the index to efficiently locate records, but MySQL must access the clustered table data to retrieve temperature, humidity and status. Therefore, the query may lose the `Using index` optimization.

This is an intentional trade-off. We accept a small increase in SELECT work in exchange for a smaller secondary index, lower storage consumption and lower write-maintenance cost.

The exact storage saving must be measured using `SHOW TABLE STATUS` or `information_schema.TABLES`; values should not be fabricated. The final decision should also be validated with EXPLAIN and real workload measurements.