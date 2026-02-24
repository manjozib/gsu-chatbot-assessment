package zw.gsu.smartassist.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import zw.gsu.smartassist.dto.chat.ChatRequest;
import zw.gsu.smartassist.dto.chat.ChatResponse;
import zw.gsu.smartassist.entity.ChatSession;
import zw.gsu.smartassist.entity.KnowledgeBase;
import zw.gsu.smartassist.repository.ChatSessionRepository;

import java.util.List;
import java.util.Optional;

@Service
public class ChatService {

    private final KnowledgeBaseService kbService;
    private final ChatSessionRepository chatRepo;

    @Value("${app.ai.enabled:false}")
    boolean aiEnabled;

    public ChatService(KnowledgeBaseService kbService, ChatSessionRepository chatRepo) {
        this.kbService = kbService; this.chatRepo = chatRepo;
    }

    public ChatResponse chat(ChatRequest req){
        String userEmail = Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .map(a -> a.getName()).orElse(null);

        // Context (not heavily used in MVP)
        chatRepo.findTop10BySessionIdOrderByTimestampDesc(req.sessionId());

        String matchedIntent = null;
        String reply = null;
        List<KnowledgeBase> hits = kbService.searchRaw(req.message());
        if (!hits.isEmpty()) {
            KnowledgeBase best = hits.get(0);
            matchedIntent = best.getCategory();
            reply = best.getAnswer();
        }

        boolean fromAI = false;
        if (reply == null && aiEnabled) {
            reply = "AI-generated response placeholder (integrate OpenAI call here).";
            fromAI = true;
        }

        if (reply == null) {
            reply = "I couldn't find an exact answer. Please check the FAQ page or rephrase your question (e.g., 'admissions', 'fees', 'programmes').";
        }

        chatRepo.save(ChatSession.of(req.sessionId(), userEmail, req.message(), reply));

        return new ChatResponse(reply, req.sessionId(), fromAI, matchedIntent);
    }
}
