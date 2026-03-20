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

### Testing (Single Test Priority)
```bash
cd laravel-ini

# Run all tests
php artisan test

# Run single test FILE
./vendor/bin/phpunit tests/Unit/ExampleTest.php

# Run single test METHOD (most specific)
./vendor/bin/phpunit --filter testMethodName

# Run by group
./vendor/bin/phpunit --group=unit

# With coverage
./vendor/bin/phpunit --coverage-html coverage/
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
- Use **Laravel Pint** for auto-formatting (run before commit)
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
| HTTP responses | prefixed `json` | `jsonSuccess()` |

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
- Import order (alphabetical within groups):
  1. PHP built-in
  2. Composer packages
  3. Laravel facades
  4. App classes
- Prefer specific types over `mixed`
- Use nullable types: `?string` not `string|null`

### Formatting
- 4 spaces indentation
- Max 120 chars/line
- Blank lines between blocks (namespace, imports, class)
- Strict comparison (`===` not `==`)
- Use `->` for single chain, newline for multiple chains

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

// For potential failures, use try-catch
try {
    // operation
} catch (\Exception $e) {
    report($e);
    return response()->json(['success' => false], 500);
}
```

## Laravel Conventions

- **Controllers**: API controllers in `app/Http/Controllers/Api/`, return `JsonResponse`
- **Routes**: `routes/api.php` for API, `routes/web.php` for web
- **Models**: Eloquent ORM, define `$fillable`/`$guarded`, use `$casts`
- **Migrations**: Descriptive names, use `up()`/`down()` methods
- **Form Requests**: Validation in `app/Http/Requests/`
- **Services**: Business logic in `app/Services/`
- **Repositories**: Data access in `app/Repositories/`

## Database Query Conventions

```php
// Always specify columns (no SELECT *)
Student::select(['id', 'name', 'email'])->get();

// Use eager loading to avoid N+1
Student::with('courses')->get();

// Use chunking for large datasets
Model::chunk(100, function ($records) { });
```

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
- Mock external dependencies with Mockery
- Test JSON API responses structure
- Use `refresh()` to reload model after modifications

## Git Conventions

- Clear, descriptive commit messages
- Atomic, focused changes
- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Present tense: "Add" not "Added"
- Run `composer install` after pulling

## Skills

Available skills for common tasks:
- `pdf` - PDF operations
- `pptx` - PowerPoint operations
- `github` - GitHub interactions
- `summarize` - URL/content summarization
- `weather` - Weather information
- `daily-report` - Generate daily work reports