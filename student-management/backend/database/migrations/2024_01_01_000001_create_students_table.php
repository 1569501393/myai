<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('students', function (Blueprint $table) {
            $table->id();
            $table->string('student_no', 20)->unique();
            $table->string('name', 50);
            $table->enum('gender', ['male', 'female', 'other']);
            $table->date('birth_date');
            $table->string('class_name', 50);
            $table->string('phone', 20)->nullable();
            $table->string('email', 100)->nullable();
            $table->string('address', 255)->nullable();
            $table->timestamps();

            $table->index('name');
            $table->index('class_name');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('students');
    }
};
