# AGENTS.md - Developer Guidelines

Laravel 12.x PHP project with Laravel skeleton app.

## Workspace Structure

```
/home/jieqiang/tmp/www/
├── laravel-ini/       # Laravel 12.x skeleton app
├── laravel-ini.bak/   # Backup
├── docs/              # Documentation
└── public/            # Web entry points
```

## Build & Test Commands

### Prerequisites
- PHP 8.3+, Composer 2.x, Node.js 18+

### Install & Run
```bash
cd laravel-ini && composer install && npm install
cd laravel-ini && php artisan serve
cd laravel-ini && composer run setup  # install + key:generate + migrate + build
```

### Testing
```bash
cd laravel-ini

php artisan test                              # Laravel test runner (recommended)
./vendor/bin/phpunit                          # PHPUnit
./vendor/bin/phpunit tests/Unit/ExampleTest.php  # Single file
./vendor/bin/phpunit --filter testMethod       # Single method
./vendor/bin/phpunit --group=unit             # By group
./vendor/bin/phpunit --testsuite=Feature       # Feature tests only
./vendor/bin/phpunit --coverage-html coverage/ # With coverage
```

### Code Quality
```bash
./vendor/bin/pint           # Auto-fix style (Laravel Pint)
./vendor/bin/pint --test    # Check without fixing
./vendor/bin/phpcs --standard=PSR12 app/  # PSR-12 check
./vendor/bin/phpcbf app/    # Auto-fix
```

## Code Style Guidelines

### General
- Follow **PSR-12** standard
- Use **Laravel Pint** for auto-formatting
- Keep functions small (single responsibility)
- Clear, descriptive names

### Naming Conventions
| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `UserService` |
| Methods | camelCase | `getUserById` |
| Variables | camelCase | `$userName` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY` |
| DB tables | snake_case (plural) | `students` |

### File Template
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

### Types & Imports
- Always `declare(strict_types=1);`
- Return types & parameter hints required
- Explicit `use` statements, sorted alphabetically
- Prefer specific types over `mixed`

### Error Handling
```php
public function show(int $id): JsonResponse
{
    $student = Student::findOrFail($id);
    return response()->json([
        'success' => true,
        'data' => $student,
        'message' => 'Retrieved successfully',
    ]);
}
```

### Formatting
- 4 spaces indentation
- Max 120 chars/line
- Blank lines between blocks
- Strict comparison (`===`)

## Laravel Conventions

- **Controllers**: API controllers in `app/Http/Controllers/Api/`, return `JsonResponse`
- **Routes**: `routes/api.php` for API, `routes/web.php` for web
- **Models**: Eloquent ORM, define `$fillable`/`$guarded`
- **Migrations**: Descriptive names (`create_students_table`)
- **Form Requests**: Validation in `app/Http/Requests/`

## Testing

```php
public function test_can_create_student(): void
{
    $response = $this->postJson('/api/students', [
        'name' => 'Test',
        'student_no' => '2024001',
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure(['success', 'data' => ['id', 'name']]);
}
```

- Follow AAA pattern (Arrange, Act, Assert)
- Mock external deps with Mockery
- Test JSON API responses

## Git Conventions

- Clear, descriptive commits
- Atomic, focused changes
- Present tense: "Add" not "Added"
- Run `composer install` after pulling
