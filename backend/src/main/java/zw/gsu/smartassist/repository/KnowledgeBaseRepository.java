package zw.gsu.smartassist.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import zw.gsu.smartassist.entity.KnowledgeBase;
import zw.gsu.smartassist.repository.projection.KbSearchHit;

import java.util.List;
import java.util.Optional;

public interface KnowledgeBaseRepository extends JpaRepository<KnowledgeBase, Long> {

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

    @Query(value = """
    WITH q AS (SELECT websearch_to_tsquery('english', :searchText) AS tsq)
    SELECT k.id, k.category, k.question, k.answer,
           ts_rank(k.fts, q.tsq) AS rank
    FROM knowledge_base k, q
    WHERE k.fts @@ q.tsq
    ORDER BY rank DESC
    LIMIT :limit
    """, nativeQuery = true)
    List<KbSearchHit> searchTopWithRank(@Param("searchText") String searchText, @Param("limit") int limit);
}
