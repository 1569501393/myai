-- 学生管理系统 MVP 数据库表结构

CREATE DATABASE IF NOT EXISTS laravel_ini;
USE laravel_ini;

DROP TABLE IF EXISTS students;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_no VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    name VARCHAR(100) NOT NULL COMMENT '姓名',
    gender ENUM('男', '女') DEFAULT '男' COMMENT '性别',
    birth_date DATE NULL COMMENT '出生日期',
    phone VARCHAR(20) DEFAULT '' COMMENT '联系电话',
    email VARCHAR(100) DEFAULT '' COMMENT '邮箱',
    address VARCHAR(255) DEFAULT '' COMMENT '地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学生表';

-- 插入测试数据
INSERT INTO students (student_no, name, gender, birth_date, phone, email, address) VALUES
('2024001', '张三', '男', '2010-05-15', '13800138001', 'zhangsan@example.com', '北京市朝阳区'),
('2024002', '李四', '女', '2011-03-20', '13800138002', 'lisi@example.com', '上海市浦东新区'),
('2024003', '王五', '男', '2010-11-08', '13800138003', 'wangwu@example.com', '广州市天河区'),
('2024004', '赵六', '女', '2012-01-25', '13800138004', 'zhaoliu@example.com', '深圳市南山区'),
('2024005', '钱七', '男', '2011-07-12', '13800138005', 'qianqi@example.com', '杭州市西湖区');