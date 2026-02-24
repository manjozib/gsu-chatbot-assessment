package zw.gsu.smartassist.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import zw.gsu.smartassist.entity.KnowledgeBase;

import java.util.List;

public interface KnowledgeBaseRepository extends JpaRepository<KnowledgeBase, Long> {

    @Query("""
    SELECT k FROM KnowledgeBase k
    WHERE lower(k.category) LIKE lower(concat('%', :q, '%'))
       OR lower(k.question) LIKE lower(concat('%', :q, '%'))
       OR lower(k.answer) LIKE lower(concat('%', :q, '%'))
       OR lower(k.keywords) LIKE lower(concat('%', :q, '%'))
    """)
    List<KnowledgeBase> search(@Param("q") String q);
}
