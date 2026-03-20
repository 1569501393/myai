# Laravel Model 模板

## 标准 Model

```php
<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Feature extends Model
{
    use HasFactory;

    protected $table = 'features';

    protected $fillable = [
        'name',
        'description',
        'status',
        'user_id',
    ];

    protected $casts = [
        'status' => 'string',
        'user_id' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $attributes = [
        'status' => 'draft',
    ];

    // -------------------- Scopes --------------------

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    public function scopeByUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }

    // -------------------- Relations --------------------

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(FeatureItem::class);
    }

    // -------------------- Accessors & Mutators --------------------

    public function getStatusLabelAttribute(): string
    {
        return match ($this->status) {
            'active' => '启用',
            'inactive' => '禁用',
            'draft' => '草稿',
            default => '未知',
        };
    }

    // -------------------- Methods --------------------

    public function activate(): bool
    {
        $this->status = 'active';
        return $this->save();
    }

    public function deactivate(): bool
    {
        $this->status = 'inactive';
        return $this->save();
    }
}
```

## Model Factory 模板

```php
<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Feature;
use Illuminate\Database\Eloquent\Factories\Factory;

class FeatureFactory extends Factory
{
    protected $model = Feature::class;

    public function definition(): array
    {
        return [
            'name' => $this->faker->unique()->words(3, true),
            'description' => $this->faker->sentence(),
            'status' => $this->faker->randomElement(['active', 'inactive', 'draft']),
            'user_id' => null,
        ];
    }

    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'active',
        ]);
    }

    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'inactive',
        ]);
    }
}
```

## 数据库迁移模板

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('features', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255)->comment('名称');
            $table->text('description')->nullable()->comment('描述');
            $table->enum('status', ['active', 'inactive', 'draft'])
                ->default('draft')
                ->comment('状态');
            $table->foreignId('user_id')
                ->nullable()
                ->constrained()
                ->onDelete('set null')
                ->comment('创建人');
            $table->timestamps();

            $table->index(['status']);
            $table->unique(['name']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('features');
    }
};
```

## Seeder 模板

```php
<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Feature;
use Illuminate\Database\Seeder;

class FeatureSeeder extends Seeder
{
    public function run(): void
    {
        Feature::factory()->count(10)->create();
    }
}
```

## 注意事项

- 使用 `$fillable` 或 `$guarded`
- 定义关系方法
- 使用 Scope 封装查询逻辑
- 使用 `$casts` 类型转换
- 创建对应的 Factory 便于测试