# Laravel API Controller 模板

## 标准 API 控制器

```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Feature;
use App\Http\Requests\StoreFeatureRequest;
use App\Http\Requests\UpdateFeatureRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FeatureController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->input('per_page', 15);
        $features = Feature::select(['id', 'name', 'status', 'created_at'])
            ->orderBy('created_at', 'desc')
            ->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $features,
            'message' => 'Retrieved successfully',
        ]);
    }

    public function store(StoreFeatureRequest $request): JsonResponse
    {
        $feature = Feature::create($request->validated());

        return response()->json([
            'success' => true,
            'data' => $feature,
            'message' => 'Created successfully',
        ], 201);
    }

    public function show(int $id): JsonResponse
    {
        $feature = Feature::findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $feature,
            'message' => 'Retrieved successfully',
        ]);
    }

    public function update(UpdateFeatureRequest $request, int $id): JsonResponse
    {
        $feature = Feature::findOrFail($id);
        $feature->update($request->validated());

        return response()->json([
            'success' => true,
            'data' => $feature->fresh(),
            'message' => 'Updated successfully',
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $feature = Feature::findOrFail($id);
        $feature->delete();

        return response()->json([
            'success' => true,
            'data' => null,
            'message' => 'Deleted successfully',
        ]);
    }
}
```

## Form Request 验证

```php
<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Http\Exceptions\HttpResponseException;

class StoreFeatureRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255', 'unique:features,name'],
            'description' => ['nullable', 'string', 'max:1000'],
            'status' => ['required', 'in:active,inactive,draft'],
        ];
    }

    public function messages(): array
    {
        return [
            'name.required' => '名称不能为空',
            'name.unique' => '名称已存在',
            'status.in' => '状态值无效',
        ];
    }

    protected function failedValidation(Validator $validator): void
    {
        throw new HttpResponseException(
            response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422)
        );
    }
}
```

## Service 层模板

```php
<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Feature;
use Illuminate\Support\Collection;

class FeatureService
{
    public function getAllActive(): Collection
    {
        return Feature::where('status', 'active')
            ->orderBy('name')
            ->get();
    }

    public function create(array $data): Feature
    {
        return Feature::create($data);
    }

    public function update(Feature $feature, array $data): Feature
    {
        $feature->update($data);
        return $feature->fresh();
    }

    public function delete(Feature $feature): bool
    {
        return $feature->delete();
    }
}
```

## 注意事项

- 始终使用 `declare(strict_types=1);`
- 返回 `JsonResponse`
- 使用 `findOrFail` 处理未找到
- 表单验证使用 Form Request
- 业务逻辑放入 Service 层