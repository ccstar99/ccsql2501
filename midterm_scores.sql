drop table if exists midterm_scores;
-- 创建期中成绩表（包含两次成绩）
CREATE TABLE if not exists midterm_scores (
                                              student_id VARCHAR(20) PRIMARY KEY,
                                              name VARCHAR(50),
                                              score1 INT,
                                              score2 INT
);

-- 插入数据（原score值作为score1，有第二次考试成绩的直接插入score2）
INSERT INTO midterm_scores (student_id, name, score1, score2) VALUES
                                                                  ('20241704698', '赵栩柔', NULL, NULL),
                                                                  ('20251504306', '陈国铭', 46, NULL),
                                                                  ('20251504307', '马英杰', NULL, NULL),
                                                                  ('20251504308', '陈怡霏', 66, NULL),
                                                                  ('20251504310', '李婧', 82, NULL),
                                                                  ('20251504312', '庄钰', NULL, NULL),
                                                                  ('20251504313', '杨洋', 86, NULL),
                                                                  ('20251504314', '徐铭秀', 74, NULL),
                                                                  ('20251504320', '吴林泽', NULL, NULL),
                                                                  ('20251504321', '蓝思颖', 75, NULL),
                                                                  ('20251504323', '李畅', 42, NULL),
                                                                  ('20251504329', '范蕊菲', 58, NULL),
                                                                  ('20251504331', '程菲', 57, NULL),
                                                                  ('20251504333', '李怡萱', 95, NULL),
                                                                  ('20251504336', '罗舒笑', 72, NULL),
                                                                  ('20251504341', '罗雅晴', 85, NULL),
                                                                  ('20251504345', '林钰然', 88, NULL),
                                                                  ('20251504346', '梁铠岚', 80, NULL),
                                                                  ('20251504353', '金彦晞', 76, NULL),
                                                                  ('20251504354', '余泓毅', NULL, NULL),
                                                                  ('20251504356', '陈钰泉', NULL, NULL),
                                                                  ('20251504357', '黄乐怡', NULL, NULL),
                                                                  ('20251504361', '易可芸', 91, NULL),
                                                                  ('20251504365', '李春梅', 88, NULL),
                                                                  ('20251504366', '蔡晓钰', 76, NULL),
                                                                  ('20251504369', '唐思琪', NULL, NULL),
                                                                  ('20251504376', '巫嘉怡', NULL, NULL),
                                                                  ('20251504383', '王思颖', NULL, NULL),
                                                                  ('20251504386', '罗嘉泓', 74, NULL),
                                                                  ('20251504387', '杨泽浩', 81, NULL),
                                                                  ('20251504392', '林伊婷', NULL, NULL),
                                                                  ('20251504398', '黄若熙', NULL, NULL),
                                                                  ('20251504401', '陈心悦', 64, NULL),
                                                                  ('20251504405', '黄琪', NULL, NULL),
                                                                  ('20251504408', '吴雯晶', NULL, NULL),
                                                                  ('20251504410', '柳妍惠', NULL, NULL),
                                                                  ('20251504413', '阮雪莹', 68, NULL),
                                                                  ('20251504418', '江莹', 87, NULL),
                                                                  ('20251504421', '黄熙童', 97, NULL),
                                                                  ('20251504424', '陈凯琳', NULL, NULL),
                                                                  ('20251504427', '韦炜', 82, NULL),
                                                                  ('20251504428', '高一茗', 77, NULL),
                                                                  ('20251504431', '曾颖', NULL, NULL),
                                                                  ('20251504434', '包睿', 82, NULL),
                                                                  ('20251504438', '冯梓瑄', NULL, NULL),
                                                                  ('20251504443', '张澜舰', 79, NULL),
                                                                  ('20251504444', '杨凯茹', 95, NULL),
                                                                  ('20251504449', '聂诗轩', NULL, NULL);

-- 更新第二次考试成绩到score2字段
UPDATE midterm_scores SET score2 = 78 WHERE student_id LIKE '%438';
UPDATE midterm_scores SET score2 = 59 WHERE student_id LIKE '%431';
UPDATE midterm_scores SET score2 = 88 WHERE student_id LIKE '%392';
UPDATE midterm_scores SET score2 = 89 WHERE student_id LIKE '%369';
UPDATE midterm_scores SET score2 = 95 WHERE student_id LIKE '%424';
UPDATE midterm_scores SET score2 = 46 WHERE student_id LIKE '%354';
UPDATE midterm_scores SET score2 = 5 WHERE student_id LIKE '%357';
UPDATE midterm_scores SET score2 = 85 WHERE student_id LIKE '%376';
UPDATE midterm_scores SET score2 = 70 WHERE student_id LIKE '%405';
UPDATE midterm_scores SET score2 = 68 WHERE student_id LIKE '%449';
UPDATE midterm_scores SET score2 = 90 WHERE student_id LIKE '%408';
UPDATE midterm_scores SET score2 = 95 WHERE student_id LIKE '%383';
UPDATE midterm_scores SET score2 = 71 WHERE student_id LIKE '%320';
UPDATE midterm_scores SET score2 = 50 WHERE student_id LIKE '%307';
UPDATE midterm_scores SET score2 = 52 WHERE student_id LIKE '%356';
UPDATE midterm_scores SET score2 = 34 WHERE student_id LIKE '%410';
UPDATE midterm_scores SET score2 = 58 WHERE student_id LIKE '%312';
UPDATE midterm_scores SET score2 = 66 WHERE student_id LIKE '%398';

-- 合并score1和score2，按成绩由高到低排序（NULL值排在最后）
SELECT
    student_id,
    name,
    COALESCE(score1, score2) as score, -- 合并两次考试成绩
    CASE
        WHEN score1 IS NOT NULL THEN '第一次考试'
        WHEN score2 IS NOT NULL THEN '补考'
        ELSE '未考试'
        END as exam_type
FROM midterm_scores
ORDER BY IF(COALESCE(score1, score2) IS NULL, 1, 0),
    COALESCE(score1, score2) DESC;