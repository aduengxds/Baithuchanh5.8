# AI Prompt Log — SmartFactory Index Optimization

## Prompt 1 — Covering Index

Question:
What is a covering index and why can it make SELECT queries faster?

Takeaway:
A covering index contains all columns required by a query, allowing MySQL to obtain the required data directly from the index without looking up the clustered table record.

---

## Prompt 2 — Clustered and Secondary Index

Question:
How does MySQL InnoDB store data in clustered and secondary indexes?

Takeaway:
In InnoDB, the primary key is the clustered index and stores the table rows. Secondary indexes contain indexed column values plus the primary key used to locate the corresponding clustered record.

---

## Prompt 3 — Write Penalty

Question:
Why does adding columns to a secondary index increase INSERT cost?

Takeaway:
Every INSERT must maintain the affected secondary index. A larger index entry consumes more storage and can increase page writes, B-tree maintenance, logging and memory usage.

---

## Prompt 4 — Fat vs Lean Index

Question:
Why is (sensor_id, recorded_at) more suitable than
(sensor_id, recorded_at, temperature, humidity, status)
for a high-write IoT table?

Takeaway:
The Lean Index contains the columns needed for filtering. Removing unnecessary payload columns reduces index size and write-maintenance overhead, while the query can still efficiently locate matching rows.

---

## Prompt 5 — Storage Measurement

Question:
How can MySQL index storage be measured?

Takeaway:
Use SHOW TABLE STATUS or information_schema.TABLES. INDEX_LENGTH can be converted to MB using:

INDEX_LENGTH / 1024 / 1024

Actual measurements should be taken from the database rather than invented.

---

## Prompt 6 — Covering Index Trade-off

Question:
Is a covering index always bad?

Takeaway:
No. A covering index can be highly beneficial for read-heavy or relatively static tables. In a high-write IoT workload, however, excessive covering columns can create unnecessary storage and write overhead.