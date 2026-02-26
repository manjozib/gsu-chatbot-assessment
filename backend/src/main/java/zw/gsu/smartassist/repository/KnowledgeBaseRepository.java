package zw.gsu.smartassist.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import zw.gsu.smartassist.entity.KnowledgeBase;

import java.util.List;
import java.util.Optional;

public interface KnowledgeBaseRepository extends JpaRepository<KnowledgeBase, Long> {

//    @Query("""
//    SELECT k FROM KnowledgeBase k
//    WHERE lower(k.category) LIKE lower(concat('%', :q, '%'))
//       OR lower(k.question) LIKE lower(concat('%', :q, '%'))
//       OR lower(k.answer) LIKE lower(concat('%', :q, '%'))
//       OR lower(k.keywords) LIKE lower(concat('%', :q, '%'))
//    """)
//    List<KnowledgeBase> search(@Param("q") String q);

//    @Query(value = """
//    SELECT *
//    FROM knowledge_base k
//    WHERE to_tsvector('english',
//          coalesce(k.category,'') || ' ' ||
//          coalesce(k.question,'') || ' ' ||
//          coalesce(k.answer,'') || ' ' ||
//          coalesce(k.keywords,'')
//    )
//    @@ plainto_tsquery('english', :searchText)
//    """,
//            nativeQuery = true)
//    List<KnowledgeBase> search(@Param("searchText") String searchText);

    @Query(value = """
    SELECT *,
           ts_rank(
               to_tsvector('english',
                   coalesce(category,'') || ' ' ||
                   coalesce(question,'') || ' ' ||
                   coalesce(answer,'') || ' ' ||
                   coalesce(keywords,'')
               ),
               websearch_to_tsquery('english', :searchText)
           ) AS rank
    FROM knowledge_base
    WHERE to_tsvector('english',
            coalesce(category,'') || ' ' ||
            coalesce(question,'') || ' ' ||
            coalesce(answer,'') || ' ' ||
            coalesce(keywords,'')
          )
          @@ websearch_to_tsquery('english', :searchText)
    ORDER BY rank DESC
    LIMIT 1
    """,
            nativeQuery = true)
    List<KnowledgeBase> search(@Param("searchText") String searchText);
}
