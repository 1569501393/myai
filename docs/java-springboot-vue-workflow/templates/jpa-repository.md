# JPA Repository 模板

## 标准 Repository

```java
package com.example.demo.repository;

import com.example.demo.entity.Feature;
import com.example.demo.entity.Feature.FeatureStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FeatureRepository extends 
        JpaRepository<Feature, Long>,
        JpaSpecificationExecutor<Feature> {

    Optional<Feature> findByName(String name);

    boolean existsByName(String name);

    Page<Feature> findByStatus(FeatureStatus status, Pageable pageable);

    List<Feature> findByUserId(Long userId);

    @Query("SELECT f FROM Feature f WHERE f.status = :status AND f.name LIKE %:keyword%")
    List<Feature> searchByStatusAndKeyword(
            @Param("status") FeatureStatus status,
            @Param("keyword") String keyword
    );

    @Query(value = "SELECT * FROM features WHERE status = :status LIMIT :limit",
           nativeQuery = true)
    List<Feature> findTopByStatus(@Param("status") String status, @Param("limit") int limit);
}
```

## 带 Specifications 的复杂查询

```java
package com.example.demo.repository;

import com.example.demo.entity.Feature;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Repository;
import jakarta.persistence.criteria.Predicate;

import java.util.ArrayList;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class FeatureRepositoryCustom {

    private final FeatureRepository featureRepository;

    public Page<Feature> search(String keyword, String status, Long userId, Pageable pageable) {
        Specification<Feature> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (keyword != null && !keyword.isBlank()) {
                predicates.add(cb.like(root.get("name"), "%" + keyword + "%"));
            }

            if (status != null && !status.isBlank()) {
                predicates.add(cb.equal(root.get("status"), status));
            }

            if (userId != null) {
                predicates.add(cb.equal(root.get("user").get("id"), userId));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return featureRepository.findAll(spec, pageable);
    }
}
```

## 使用 Example 查询

```java
package com.example.demo.repository;

import com.example.demo.entity.Feature;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class FeatureExampleRepository {

    private final FeatureRepository featureRepository;

    public FeatureExampleRepository(FeatureRepository featureRepository) {
        this.featureRepository = featureRepository;
    }

    public Page<Feature> findByExample(Feature probe, Pageable pageable) {
        ExampleMatcher matcher = ExampleMatcher.matching()
                .withStringMatcher(ExampleMatcher.StringMatcher.CONTAINING)
                .withIgnoreCase()
                .withIgnoreNullValues();

        Example<Feature> example = Example.of(probe, matcher);
        return featureRepository.findAll(example, pageable);
    }

    public Optional<Feature> findExactMatch(Feature probe) {
        Example<Feature> example = Example.of(probe);
        return featureRepository.findOne(example);
    }
}
```

## 注意事项

- 继承 `JpaRepository<Entity, ID>` 获取基本 CRUD
- 使用 `JpaSpecificationExecutor` 复杂查询
- 使用 `@Query` 自定义查询
- 使用 `@Param` 命名参数
- 使用 Example 进行模糊匹配