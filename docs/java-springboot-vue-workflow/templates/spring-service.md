# Spring Service 模板

## 标准 Service 接口与实现

```java
package com.example.demo.service;

import com.example.demo.dto.*;

public interface FeatureService {
    
    PageResponse<FeatureResponseDTO> list(int page, int size, String status);
    
    FeatureResponseDTO getById(Long id);
    
    FeatureResponseDTO create(FeatureCreateDTO dto);
    
    FeatureResponseDTO update(Long id, FeatureUpdateDTO dto);
    
    void delete(Long id);
}
```

```java
package com.example.demo.service.impl;

import com.example.demo.dto.*;
import com.example.demo.entity.Feature;
import com.example.demo.exception.ResourceNotFoundException;
import com.example.demo.mapper.FeatureMapper;
import com.example.demo.repository.FeatureRepository;
import com.example.demo.service.FeatureService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class FeatureServiceImpl implements FeatureService {

    private final FeatureRepository featureRepository;
    private final FeatureMapper featureMapper;

    @Override
    @Transactional(readOnly = true)
    public PageResponse<FeatureResponseDTO> list(int page, int size, String status) {
        PageRequest pageRequest = PageRequest.of(page - 1, size, Sort.by("createdAt").descending());

        Page<Feature> featurePage;
        if (status != null && !status.isBlank()) {
            Feature.FeatureStatus featureStatus = Feature.FeatureStatus.valueOf(status.toUpperCase());
            featurePage = featureRepository.findByStatus(featureStatus, pageRequest);
        } else {
            featurePage = featureRepository.findAll(pageRequest);
        }

        return PageResponse.<FeatureResponseDTO>builder()
                .data(featurePage.getContent().stream()
                        .map(featureMapper::toResponse)
                        .toList())
                .total(featurePage.getTotalElements())
                .page(page)
                .size(size)
                .totalPages(featurePage.getTotalPages())
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public FeatureResponseDTO getById(Long id) {
        Feature feature = featureRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Feature not found with id: " + id));
        return featureMapper.toResponse(feature);
    }

    @Override
    public FeatureResponseDTO create(FeatureCreateDTO dto) {
        if (featureRepository.existsByName(dto.getName())) {
            throw new IllegalArgumentException("Feature with name already exists: " + dto.getName());
        }

        Feature feature = featureMapper.toEntity(dto);
        Feature saved = featureRepository.save(feature);
        log.info("Created feature: {}", saved.getId());

        return featureMapper.toResponse(saved);
    }

    @Override
    public FeatureResponseDTO update(Long id, FeatureUpdateDTO dto) {
        Feature feature = featureRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Feature not found with id: " + id));

        featureMapper.updateFromDto(dto, feature);
        Feature updated = featureRepository.save(feature);
        log.info("Updated feature: {}", updated.getId());

        return featureMapper.toResponse(updated);
    }

    @Override
    public void delete(Long id) {
        if (!featureRepository.existsById(id)) {
            throw new ResourceNotFoundException("Feature not found with id: " + id);
        }
        featureRepository.deleteById(id);
        log.info("Deleted feature: {}", id);
    }
}
```

## MapStruct Mapper

```java
package com.example.demo.mapper;

import com.example.demo.dto.*;
import com.example.demo.entity.Feature;
import org.mapstruct.*;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface FeatureMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", expression = "java(com.example.demo.entity.Feature.FeatureStatus.valueOf(dto.getStatus()))")
    Feature toEntity(FeatureCreateDTO dto);

    FeatureResponseDTO toResponse(Feature entity);

    @Mapping(target = "status", expression = "java(entity.getStatus().name())")
    FeatureResponseDTO toResponseDTO(Feature entity);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateFromDto(FeatureUpdateDTO dto, @MappingTarget Feature entity);
}
```

## 异常类

```java
package com.example.demo.exception;

public class ResourceNotFoundException extends RuntimeException {
    
    public ResourceNotFoundException(String message) {
        super(message);
    }

    public ResourceNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

## 注意事项

- 使用 `@Transactional` 管理事务
- 使用 `@Transactional(readOnly = true)` 优化只读查询
- 使用 MapStruct 进行对象映射
- 抛出统一异常便于全局处理
- 使用 `@Slf4j` 日志记录
- 验证数据唯一性