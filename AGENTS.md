# AGENTS.md - Developer Guidelines for this Repository

This is a PHP-based project. The codebase follows PHP best practices and PSR standards.

## 1. Build, Lint, and Test Commands

### Prerequisites
- PHP 8.1+ 
- Composer (for dependency management)

### Install Dependencies
```bash
composer install
```

### Running the Application
```bash
# Start PHP built-in server
php -S localhost:8000 -t public/

# Or run a specific PHP file
php public/index.php
```

### Running Tests
```bash
# Run PHPUnit tests
./vendor/bin/phpunit

# Run a single test file
./vendor/bin/phpunit tests/YourTest.php

# Run a single test method
./vendor/bin/phpunit --filter testMethodName tests/YourTest.php

# Run tests with coverage
./vendor/bin/phpunit --coverage-html coverage/
```

### Linting and Code Quality
```bash
# Run PHP_CodeSniffer (PSR-12 standard)
./vendor/bin/phpcs --standard=PSR12 src/

# Auto-fix coding standards (if available)
./vendor/bin/phpcbf src/

# Run PHPStan static analysis
./vendor/bin/phpstan analyse src/

# Run PHP CS Fixer
./vendor/bin/php-cs-fixer fix --diff --dry-run src/

# Run all linters together
composer lint
```

### Code Formatting
```bash
# Format code with PHP CS Fixer
./vendor/bin/php-cs-fixer fix src/
```

## 2. Code Style Guidelines

### General Principles
- Follow PSR-12 (PHP Standard Recommendation) for code style
- Keep functions small and focused (single responsibility)
- Write self-documenting code with clear variable/function names

### Naming Conventions
- **Classes**: `PascalCase` (e.g., `UserService`, `PaymentProcessor`)
- **Functions/Methods**: `camelCase` (e.g., `getUserById`, `processPayment`)
- **Variables**: `camelCase` (e.g., `$userName`, `$totalAmount`)
- **Constants**: `SCREAMING_SNAKE_CASE` (e.g., `MAX_RETRY_COUNT`)
- **Interfaces**: Prefix with `I` or suffix with `Interface` (e.g., `IUserRepository` or `UserRepositoryInterface`)
- **Traits**: Suffix with `Trait` (e.g., `LoggableTrait`)
- **Enums**: `PascalCase` (e.g., `OrderStatus`)

### File Organization
```php
<?php

declare(strict_types=1); // Always use strict types

namespace App\Services;

use App\Models\User;
use App\Interfaces\UserRepositoryInterface;

class UserService
{
    public function __construct(
        private readonly UserRepositoryInterface $userRepository,
    ) {}

    public function getUserById(int $id): ?User
    {
        return $this->userRepository->findById($id);
    }
}
```

### Imports
- Use fully qualified class names or explicit `use` statements
- Group imports: internal packages first, then external, then PHP
- Sort alphabetically within groups
```php
use App\Models\User;
use App\Repositories\UserRepository;
use Illuminate\Support\Facades\Log;
use InvalidArgumentException;
```

### Types
- Declare strict types at the top of every file: `declare(strict_types=1);`
- Use return type declarations and parameter type hints
- Use union types where appropriate (PHP 8+)
- Prefer specific types over mixed

### Error Handling
- Use exceptions for error handling, not return codes
- Catch specific exceptions, not generic ones
- Always type-check inputs at function boundaries
- Use `try-catch` blocks for operations that may fail
- Log exceptions before rethrowing

```php
public function processPayment(int $amount): PaymentResult
{
    if ($amount <= 0) {
        throw new InvalidArgumentException('Amount must be positive');
    }

    try {
        return $this->paymentGateway->charge($amount);
    } catch (PaymentGatewayException $e) {
        $this->logger->error('Payment failed', ['error' => $e->getMessage()]);
        throw $e;
    }
}
```

### Code Formatting Rules
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 120 characters
- Add blank lines to separate logical code blocks
- One space after comma, but none before
- Use strict comparison (`===` over `==`)
- Use strict type checking

### Comments and Documentation
- Use PHPDoc for classes, methods, and functions
- Keep comments up-to-date with code changes
- Write meaningful descriptions, not obvious explanations
- Document complex business logic
- Use `@param`, `@return`, `@throws` tags in PHPDoc

```php
/**
 * Retrieves a user by their unique identifier.
 *
 * @param int $id The unique user ID
 * @return User|null The user object or null if not found
 * @throws UserNotFoundException If user ID is invalid
 */
public function getUserById(int $id): ?User
{
    // Implementation
}
```

### Control Structures
- Use `match` expression (PHP 8+) over `switch` where appropriate
- Avoid nested conditionals; use early returns
- Keep conditionals simple and readable

### Database/ORM
- Use query builder or ORM methods, avoid raw SQL unless necessary
- Use parameter binding to prevent SQL injection
- Add indexes for frequently queried columns

### Security
- Never expose sensitive data in logs
- Use prepared statements for all database queries
- Validate and sanitize all user inputs
- Use environment variables for secrets (never commit `.env` files)

### Testing Guidelines
- Test behavior, not implementation details
- Use descriptive test method names: `testItCreatesUserSuccessfully`
- Follow AAA pattern: Arrange, Act, Assert
- Mock external dependencies
- Write unit tests for all new features
- Aim for high code coverage on business logic

```php
public function testItCreatesUserWithValidData(): void
{
    // Arrange
    $userData = ['name' => 'John', 'email' => 'john@example.com'];
    
    // Act
    $user = $this->userService->createUser($userData);
    
    // Assert
    $this->assertInstanceOf(User::class, $user);
    $this->assertEquals('John', $user->getName());
}
```

### Git Conventions
- Write clear, descriptive commit messages
- Keep commits atomic and focused
- Use present tense: "Add feature" not "Added feature"

## 3. Project Structure

```
/home/jieqiang/tmp/www/
├── public/              # Web entry points
│   ├── index.php
│   └── test.php
├── src/                 # Application code (create this)
├── tests/               # Test files (create this)
├── config/              # Configuration files (create this)
├── composer.json        # Dependencies
└── README.md
```

## 4. Common Tasks

### Creating a New Class
1. Place in appropriate `src/` directory
2. Add namespace declaration
3. Add PHPDoc documentation
4. Follow naming and typing conventions above

### Adding a New Test
1. Create test file in `tests/` matching the source structure
2. Use `TestCase` base class
3. Follow test naming: `ClassNameTest`
4. Add clear arrange/act/assert sections
