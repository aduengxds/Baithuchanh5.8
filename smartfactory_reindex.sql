-- SMARTFACTORY - INDEX OPTIMIZATION
-- Remove Fat Covering Index and create Lean Index

CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

-- ========================================================
-- 1. Tao bang SensorLogs neu chua ton tai
-- ========================================================

CREATE TABLE IF NOT EXISTS SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20)
);

-- ========================================================
-- 2. Tao Fat Covering Index neu can kiem tra
-- ========================================================

CREATE INDEX idx_fat_covering
ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- ========================================================
-- 3. Kiem tra dung luong truoc toi uu
-- ========================================================

SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS Data_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS Index_MB,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS Total_MB
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'smartfactory_db'
  AND TABLE_NAME = 'SensorLogs';

-- ========================================================
-- 4. EXPLAIN truoc toi uu
-- ========================================================

EXPLAIN
SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105
  AND recorded_at >= '2026-06-20';

-- ========================================================
-- 5. Xoa Fat Covering Index
-- ========================================================

ALTER TABLE SensorLogs
DROP INDEX idx_fat_covering;

-- ========================================================
-- 6. Tao Lean Index
-- Chi giu lai cac cot dung de loc du lieu
-- ========================================================

CREATE INDEX idx_lean_search
ON SensorLogs(sensor_id, recorded_at);

-- ========================================================
-- 7. Kiem tra index sau toi uu
-- ========================================================

SHOW INDEX FROM SensorLogs;

-- ========================================================
-- 8. Kiem tra dung luong sau toi uu
-- ========================================================

SHOW TABLE STATUS LIKE 'SensorLogs';

SELECT
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS Data_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS Index_MB,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS Total_MB
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'smartfactory_db'
  AND TABLE_NAME = 'SensorLogs';

-- ========================================================
-- 9. EXPLAIN sau toi uu
-- ========================================================

EXPLAIN
SELECT temperature, humidity, status
FROM SensorLogs
WHERE sensor_id = 105
  AND recorded_at >= '2026-06-20';