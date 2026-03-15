<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;

    protected $fillable = [
        'student_no',
        'name',
        'gender',
        'birth_date',
        'class_name',
        'phone',
        'email',
        'address',
    ];

    protected $casts = [
        'birth_date' => 'date',
    ];

    public const GENDER_MALE = 'male';
    public const GENDER_FEMALE = 'female';
    public const GENDER_OTHER = 'other';

    public const GENDER_LABELS = [
        self::GENDER_MALE => '男',
        self::GENDER_FEMALE => '女',
        self::GENDER_OTHER => '其他',
    ];

    public function getGenderLabelAttribute(): string
    {
        return self::GENDER_LABELS[$this->gender] ?? $this->gender;
    }
}
