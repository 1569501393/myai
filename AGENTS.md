# AGENTS.md - Developer Guidelines

Multi-framework workspace with Laravel, Python FastAPI, Java SpringBoot, Go Gin, and ABAP ECC workflows.

## Workspace Structure

```
/home/jieqiang/tmp/www/
├── docs/                    # Workflow documentation & templates
├── public/                  # Web entry points
├── php/                     # PHP utilities
├── student-mvp/            # Student MVP project
├── ai4sap/                 # AI for SAP project
├── daily-motivation/       # Daily motivation skill
├── hello-world-skill/      # Example skill
└── .husky/                 # Git hooks (husky + commitizen)
```

## Build & Test Commands

### Prerequisites
- PHP 8.3+, Composer 2.x, Node.js 18+
- Python 3.10+, pip
- Java 17+, Maven/Gradle
- Go 1.21+

### Laravel (php-laravel-vue-workflow)
```bash
cd laravel-ini && composer install && npm install
cd laravel-ini && php artisan serve
cd laravel-ini && composer run setup  # install + key:generate + migrate + build
```

### Testing (Laravel)
```bash
cd laravel-ini
php artisan test                              # Run all tests
./vendor/bin/phpunit tests/Unit/ExampleTest.php  # Single file
./vendor/bin/phpunit --filter testMethodName    # Single method
./vendor/bin/phpunit --group=unit              # By group
./vendor/bin/phpunit --coverage-html coverage/  # With coverage
```

### Code Quality (Laravel)
```bash
cd laravel-ini
./vendor/bin/pint           # Auto-fix style (Laravel Pint)
./vendor/bin/pint --test    # Check without fixing
./vendor/bin/phpcs --standard=PSR12 app/  # PSR-12 check
./vendor/bin/phpcbf app/    # Auto-fix
```

## Code Style Guidelines

### General
- Follow **PSR-12** standard for PHP
- Use **Laravel Pint** for PHP auto-formatting
- Keep functions small (< 50 lines, single responsibility)
- Clear, descriptive names

### Naming Conventions
| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `UserService` |
| Methods | camelCase | `getUserById` |
| Variables | camelCase | `$userName` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY` |
| DB tables | snake_case (plural) | `students` |

### File Template (PHP)
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
- Import order (alphabetical): PHP built-in → Composer → Laravel facades → App classes
- Prefer specific types over `mixed`
- Use nullable types: `?string` not `string|null`

### Formatting
- 4 spaces indentation, max 120 chars/line
- Blank lines between blocks
- Strict comparison (`===` not `==`)

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

## Framework-Specific Conventions

### Laravel (app/ structure)
- **Controllers**: API in `app/Http/Controllers/Api/`, return `JsonResponse`
- **Routes**: `routes/api.php` for API, `routes/web.php` for web
- **Models**: Eloquent ORM, define `$fillable`/`$guarded`, use `$casts`
- **Services**: Business logic in `app/Services/`
- **Repositories**: Data access in `app/Repositories/`

### Database Query Conventions
```php
// Always specify columns (no SELECT *)
Student::select(['id', 'name', 'email'])->get();

// Use eager loading to avoid N+1
Student::with('courses')->get();

// Use chunking for large datasets
Model::chunk(100, function ($records) { });
```

### Python FastAPI
- Use Pydantic for request/response models
- Follow `app/routers/`, `app/services/`, `app/models/` structure

### Java SpringBoot
- Use JPA/Hibernate for persistence
- Follow `controller/`, `service/`, `repository/` structure

### Go Gin
- Use GORM for database
- Follow `handlers/`, `services/`, `models/` structure

### ABAP ECC
- Use ABAP OO patterns
- Follow SAP naming conventions (Z* for custom objects)

## Testing

### PHP (Laravel)
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
- Mock external dependencies with Mockery
- Test JSON API responses structure

## Git Conventions

- Clear, descriptive commit messages
- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Present tense: "Add" not "Added"
- Run `composer install` / `npm install` after pulling
- Use husky + commitizen for commit message validation

## Available Skills

**User Skills**: `pdf`, `pptx`, `github`, `summarize`, `weather`, `daily-report`, `abap-ecc-workflow`, `php-laravel-vue-workflow`, `python-fastapi-vue-workflow`, `java-springboot-vue-workflow`, `go-gin-vue-workflow`

**Workflow Docs**: See `/docs/` for detailed workflow templates:
- `docs/php-laravel-vue-workflow/`
- `docs/python-fastapi-vue-workflow/`
- `docs/java-springboot-vue-workflow/`
- `docs/go-gin-vue-workflow/`
- `docs/abap-ecc-workflow/`
