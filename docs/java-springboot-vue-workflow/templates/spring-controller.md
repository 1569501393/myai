# Spring Boot Controller 模板

## 标准 REST Controller

```java
package com.example.demo.controller.api;

import com.example.demo.dto.FeatureCreateDTO;
import com.example.demo.dto.FeatureUpdateDTO;
import com.example.demo.dto.FeatureResponseDTO;
import com.example.demo.dto.PageResponse;
import com.example.demo.service.FeatureService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/features")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FeatureController {

    private final FeatureService featureService;

    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<FeatureResponseDTO>>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "15") int size,
            @RequestParam(required = false) String status
    ) {
        PageResponse<FeatureResponseDTO> response = featureService.list(page, size, status);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<FeatureResponseDTO>> getById(@PathVariable Long id) {
        FeatureResponseDTO feature = featureService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(feature));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<FeatureResponseDTO>> create(
            @Valid @RequestBody FeatureCreateDTO dto
    ) {
        FeatureResponseDTO feature = featureService.create(dto);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(feature, "Created successfully"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<FeatureResponseDTO>> update(
            @PathVariable Long id,
            @Valid @RequestBody FeatureUpdateDTO dto
    ) {
        FeatureResponseDTO feature = featureService.update(id, dto);
        return ResponseEntity.ok(ApiResponse.success(feature, "Updated successfully"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        featureService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Deleted successfully"));
    }
}
```

## 统一响应包装

```java
package com.example.demo.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    
    private boolean success;
    private String message;
    private T data;

    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(true, "Success", data);
    }

    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(true, message, data);
    }

    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null);
    }
}
```

## 分页响应

```java
package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageResponse<T> {
    private List<T> data;
    private long total;
    private int page;
    private int size;
    private int totalPages;
}
```

## 全局异常处理

```java
package com.example.demo.config;

import com.example.demo.dto.ApiResponse;
import com.example.demo.exception.ResourceNotFoundException;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(ex.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidation(
            MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String field = ((FieldError) error).getField();
            String message = error.getDefaultMessage();
            errors.put(field, message);
        });
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("Validation failed"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGeneral(Exception ex) {
        log.error("Unexpected error", ex);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("Internal server error"));
    }
}
```

## 注意事项

- 使用 `@Valid` 触发验证
- 返回 `ResponseEntity<ApiResponse<T>>`
- 使用 Lombok 减少样板代码
- 分离 DTO 和 Entity
- 添加全局异常处理