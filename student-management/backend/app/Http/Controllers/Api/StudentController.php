<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StudentController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->input('per_page', 10);
        $students = Student::orderBy('id', 'desc')->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $students,
            'message' => '获取成功',
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'student_no' => 'required|string|max:20|unique:students|regex:/^[0-9A-Za-z]+$/',
            'name' => 'required|string|max:50',
            'gender' => 'required|in:male,female,other',
            'birth_date' => 'required|date|before:today',
            'class_name' => 'required|string|max:50',
            'phone' => 'nullable|string|max:20|regex:/^[0-9-]+$/',
            'email' => 'nullable|email|max:100',
            'address' => 'nullable|string|max:255',
        ]);

        $student = Student::create($validated);

        return response()->json([
            'success' => true,
            'data' => $student,
            'message' => '创建成功',
        ], 201);
    }

    public function show(int $id): JsonResponse
    {
        $student = Student::findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $student,
            'message' => '获取成功',
        ]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $student = Student::findOrFail($id);

        $validated = $request->validate([
            'student_no' => 'required|string|max:20|unique:students,student_no,'.$id.'|regex:/^[0-9A-Za-z]+$/',
            'name' => 'required|string|max:50',
            'gender' => 'required|in:male,female,other',
            'birth_date' => 'required|date|before:today',
            'class_name' => 'required|string|max:50',
            'phone' => 'nullable|string|max:20|regex:/^[0-9-]+$/',
            'email' => 'nullable|email|max:100',
            'address' => 'nullable|string|max:255',
        ]);

        $student->update($validated);

        return response()->json([
            'success' => true,
            'data' => $student,
            'message' => '更新成功',
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $student = Student::findOrFail($id);
        $student->delete();

        return response()->json([
            'success' => true,
            'data' => null,
            'message' => '删除成功',
        ]);
    }

    public function search(Request $request): JsonResponse
    {
        $query = $request->input('q', '');

        if (empty($query)) {
            return $this->index($request);
        }

        $students = Student::where('name', 'like', "%{$query}%")
            ->orWhere('student_no', 'like', "%{$query}%")
            ->orderBy('id', 'desc')
            ->paginate(10);

        return response()->json([
            'success' => true,
            'data' => $students,
            'message' => '搜索成功',
        ]);
    }
}
