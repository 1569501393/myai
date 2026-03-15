<?php

namespace Database\Seeders;

use App\Models\Student;
use Illuminate\Database\Seeder;

class StudentSeeder extends Seeder
{
    public function run(): void
    {
        $students = [
            [
                'student_no' => '2024001',
                'name' => '张三',
                'gender' => 'male',
                'birth_date' => '2005-03-15',
                'class_name' => '高三(1)班',
                'phone' => '13800138001',
                'email' => 'zhangsan@example.com',
                'address' => '北京市朝阳区',
            ],
            [
                'student_no' => '2024002',
                'name' => '李四',
                'gender' => 'female',
                'birth_date' => '2005-06-20',
                'class_name' => '高三(1)班',
                'phone' => '13800138002',
                'email' => 'lisi@example.com',
                'address' => '上海市浦东新区',
            ],
            [
                'student_no' => '2024003',
                'name' => '王五',
                'gender' => 'male',
                'birth_date' => '2005-09-10',
                'class_name' => '高三(2)班',
                'phone' => '13800138003',
                'email' => 'wangwu@example.com',
                'address' => '广州市天河区',
            ],
            [
                'student_no' => '2024004',
                'name' => '赵六',
                'gender' => 'female',
                'birth_date' => '2005-12-05',
                'class_name' => '高三(2)班',
                'phone' => '13800138004',
                'email' => 'zhaoliu@example.com',
                'address' => '深圳市南山区',
            ],
            [
                'student_no' => '2024005',
                'name' => '钱七',
                'gender' => 'other',
                'birth_date' => '2004-02-28',
                'class_name' => '高三(3)班',
                'phone' => '13800138005',
                'email' => 'qianqi@example.com',
                'address' => '杭州市西湖区',
            ],
        ];

        foreach ($students as $student) {
            Student::create($student);
        }
    }
}
