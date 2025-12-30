-- 创建数据库架构
CREATE DATABASE IF NOT EXISTS cctask2501
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 使用该数据库
USE cctask2501;

-- 创建临时表，使用DECIMAL类型
DROP TEMPORARY TABLE IF EXISTS temp_scores;
CREATE TEMPORARY TABLE temp_scores (
                                       student_id VARCHAR(50),
                                       student_name VARCHAR(100),
                                       total_score DECIMAL(10,2),
                                       homework_index INT
);

-- 创建临时表存储有效的作业编号
DROP TEMPORARY TABLE IF EXISTS valid_homeworks;
CREATE TEMPORARY TABLE valid_homeworks (
                                           homework_index INT PRIMARY KEY
);

-- 存储过程 - 只处理有数据的表
DELIMITER $$
DROP PROCEDURE IF EXISTS InsertAllScores$$
CREATE PROCEDURE InsertAllScores()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE table_name VARCHAR(50);

    WHILE i <= 20 DO
            SET table_name = CONCAT('homework_score', i);

            -- 检查表是否存在且有数据
            SET @sql_check = CONCAT('SELECT COUNT(*) INTO @cnt FROM ', table_name);
            SET @table_exists = 0;

            -- 检查表是否存在
            SELECT COUNT(*) INTO @table_exists
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = table_name;

            IF @table_exists > 0 THEN
                -- 检查表中是否有数据
                PREPARE stmt_check FROM @sql_check;
                EXECUTE stmt_check;
                DEALLOCATE PREPARE stmt_check;

                -- 如果有数据，则插入
                IF @cnt > 0 THEN
                    -- 记录有效作业编号
                    INSERT INTO valid_homeworks VALUES (i);

                    -- 插入成绩数据
                    SET @sql = CONCAT('INSERT INTO temp_scores SELECT student_id, student_name, CAST(total_score AS DECIMAL(10,2)), ', i, ' FROM ', table_name);
                    PREPARE stmt FROM @sql;
                    EXECUTE stmt;
                    DEALLOCATE PREPARE stmt;
                END IF;
            END IF;
            SET i = i + 1;
        END WHILE;
END$$
DELIMITER ;

CALL InsertAllScores();

-- 创建第二个临时表来存储学生基本信息
DROP TEMPORARY TABLE IF EXISTS student_summary;
CREATE TEMPORARY TABLE student_summary AS
SELECT
    student_id,
    student_name,
    ROUND(AVG(total_score), 4) as avg_score,
    ROUND(SUM(total_score), 2) AS total_score_sum
FROM temp_scores
GROUP BY student_id, student_name;

-- 最终查询，只考虑有效的作业编号
SELECT
    ss.student_id,
    ss.student_name,
    ss.avg_score,
    ss.total_score_sum,
    -- 新增字段1：平均分的10倍
    ROUND(ss.avg_score * 10) as avg_score_x10,
    -- 新增字段2：未交作业的作业编号列表（只考虑有效作业）
    (
        SELECT GROUP_CONCAT(missing_index ORDER BY missing_index SEPARATOR ', ')
        FROM (
                 SELECT vh.homework_index as missing_index
                 FROM valid_homeworks vh
                 WHERE vh.homework_index NOT IN (
                     SELECT DISTINCT homework_index
                     FROM temp_scores ts
                     WHERE ts.student_id = ss.student_id
                       AND ts.total_score > 0
                 )
             ) missing
    ) as missing_homeworks
FROM student_summary ss
-- 按照Excel表格中的规律排序：先按入学年份，然后按学号数值大小
ORDER BY
    -- 先按学号前4位（入学年份）排序
    CASE
        WHEN ss.student_id LIKE '2024%' THEN 1
        WHEN ss.student_id LIKE '2025%' THEN 2
        ELSE 3
        END,
    -- 然后按学号字符串的数值大小排序
    CAST(ss.student_id AS UNSIGNED);

-- 清理临时表
DROP TEMPORARY TABLE IF EXISTS temp_scores;
DROP TEMPORARY TABLE IF EXISTS student_summary;
DROP TEMPORARY TABLE IF EXISTS valid_homeworks;