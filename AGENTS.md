# AGENTS.md - Developer Guidelines

This is a Laravel 12.x PHP project with Vue 3 frontend. The workspace contains multiple projects.

## Workspace Structure

```
/home/jieqiang/tmp/www/
├── laravel-ini/              # Laravel 12 skeleton app
├── student-management/       # Full-stack student management system
│   ├── backend/              # Laravel 12.x API
│   ├── frontend/             # Vue 3 + Vite + Element Plus
│   └── docker/               # MySQL Docker setup
└── public/                   # Web entry points
```

---

## 1. Build, Lint, and Test Commands

### Prerequisites
- PHP 8.3+ (Laravel 12 requires PHP 8.2+)
- Composer 2.x
- Node.js 18+
- Docker (for MySQL in student-management)

### Install Dependencies
```bash
# Laravel backend
cd laravel-ini && composer install

# Student management backend
cd student-management/backend && composer install

# Student management frontend
cd student-management/frontend && npm install
```

### Running the Application
```bash
# Laravel development server
php artisan serve

# With Docker MySQL (student-management)
cd student-management/docker && docker-compose up -d
```

### Running Tests
```bash
# Laravel's artisan test runner (recommended)
php artisan test

# PHPUnit directly
./vendor/bin/phpunit

# Run a single test file
./vendor/bin/phpunit tests/Unit/ExampleTest.php

# Run a single test method
./vendor/bin/phpunit --filter testExample tests/Unit/ExampleTest.php

# Run tests by group
./vendor/bin/phpunit --group=unit

# Run Feature tests only
./vendor/bin/phpunit --testsuite=Feature

# With coverage report
./vendor/bin/phpunit --coverage-html coverage/
```

### Code Quality
```bash
# Laravel Pint (code formatter) - auto-fixes style
./vendor/bin/pint

# Check without fixing
./vendor/bin/pint --test

# PHP_CodeSniffer (PSR-12)
./vendor/bin/phpcs --standard=PSR12 app/

# Auto-fix with phpcbf
./vendor/bin/phpcbf app/
```

---

## 2. Code Style Guidelines

### General Principles
- Follow **PSR-12** (PHP Standard Recommendation) coding standards
- Use **Laravel Pint** for automatic code formatting
- Keep functions small and focused (single responsibility)
- Write self-documenting code with clear variable/function names

### Naming Conventions
| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `UserService`, `StudentController` |
| Methods | camelCase | `getUserById`, `storeStudent` |
| Variables | camelCase | `$userName`, `$studentData` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Database tables | snake_case (plural) | `students`, `user_profiles` |
| Relationships | snake_case | `belongsTo`, `hasMany` |

### File Organization
```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class StudentController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        // Implementation
    }
}
```

### Imports
- Use explicit `use` statements
- Sort alphabetically within groups
- Group: internal packages first, then Laravel, then PHP

```php
use App\Models\Student;           // Internal
use Illuminate\Http\JsonResponse; // Laravel
use Illuminate\Http\Request;      // Laravel
```

### Types
- Always use `declare(strict_types=1);`
- Use return type declarations and parameter type hints
- Use nullable types with `?` prefix
- Prefer specific types over `mixed`

### Error Handling
- Use Laravel's exception handling
- Use `abort()` for HTTP errors
- Use `try-catch` for operations that may fail
- Return JSON responses for API routes

```php
public function show(int $id): JsonResponse
{
    $student = Student::findOrFail($id);

    return response()->json([
        'success' => true,
        'data' => $student,
        'message' => 'Student retrieved successfully',
    ]);
}
```

### Code Formatting Rules
- 4 spaces for indentation
- Maximum line length: 120 characters
- Blank lines between logical blocks
- One space after comma, none before
- Use strict comparison (`===` over `==`)

### Comments and Documentation
- Use PHPDoc for classes and public methods
- Document complex business logic
- Keep comments up-to-date with code

```php
/**
 * Retrieve a paginated list of students.
 *
 * @param Request $request
 * @return JsonResponse
 */
public function index(Request $request): JsonResponse
{
    // ...
}
```

---

## 3. Laravel Conventions

### Controllers
- Use **API Controllers** in `app/Http/Controllers/Api/`
- Return `JsonResponse` for API endpoints
- Use dependency injection via constructor

### Routes
- API routes in `routes/api.php`
- Use resource routes where appropriate

### Models
- Use Eloquent ORM
- Define relationships explicitly
- Use `$fillable` or `$guarded` for mass assignment

### Migrations
- Create migrations for all database changes
- Use descriptive names: `create_students_table`

### Form Requests
- Use Form Request classes for validation
- Place in `app/Http/Requests/`

---

## 4. Testing Guidelines

- Use `php artisan test` (Laravel's wrapper)
- Follow AAA pattern: Arrange, Act, Assert
- Mock external dependencies with Mockery
- Test JSON API responses

```php
public function test_can_create_student(): void
{
    $response = $this->postJson('/api/students', [
        'name' => 'Test Student',
        'student_no' => '2024001',
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure([
            'success',
            'data' => ['id', 'name', 'student_no'],
        ]);
}
```

---

## 5. Git Conventions

- Write clear, descriptive commit messages
- Keep commits atomic and focused
- Use present tense: "Add feature" not "Added feature"
- Run `composer install` and `npm install` after pulling
