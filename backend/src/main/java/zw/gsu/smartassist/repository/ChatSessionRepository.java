package zw.gsu.smartassist.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import zw.gsu.smartassist.entity.ChatSession;

import java.util.List;

public interface ChatSessionRepository extends JpaRepository<ChatSession, Long> {
    List<ChatSession> findTop10BySessionIdOrderByTimestampDesc(String sessionId);
}
