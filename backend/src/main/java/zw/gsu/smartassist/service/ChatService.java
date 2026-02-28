package zw.gsu.smartassist.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import zw.gsu.smartassist.dto.chat.ChatRequest;
import zw.gsu.smartassist.dto.chat.ChatResponse;
import zw.gsu.smartassist.entity.ChatSession;
import zw.gsu.smartassist.repository.ChatSessionRepository;
import zw.gsu.smartassist.repository.projection.KbSearchHit;

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
        final String message = req.message() == null ? "" : req.message().trim();
        if (message.isEmpty()) {
            return new ChatResponse(
                    "Please enter a question (e.g., “How do I apply?”, “What are the fees?”).",
                    req.sessionId(), false, null
            );
        }

        final String userEmail = Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .map(a -> a.getName()).orElse(null);

        chatRepo.findTop10BySessionIdOrderByTimestampDesc(req.sessionId());

        final float ANSWER_THRESHOLD = 0.15f;

        String matchedIntent = null;
        String reply = null;
        boolean fromAI = false;

        List<KbSearchHit> hits = kbService.searchTopWithRank(message, 3);

        if (!hits.isEmpty()) {
            KbSearchHit top = hits.get(0);
            matchedIntent = top.getCategory();

            if (top.getRank() != null && top.getRank() >= ANSWER_THRESHOLD) {
                // Confident enough: return the ANSWER
                reply = top.getAnswer();
            } else {
                // Not confident: return PREDICTED QUESTION suggestion
                reply = "Did you mean: \"" + top.getQuestion() + "\"?";
            }
        }

        // Optional AI fallback
        if (reply == null && aiEnabled) {
            reply = "AI-generated response placeholder (integrate OpenAI call here).";
            fromAI = true;
        }

        if (reply == null) {
            // No hits at all / still null: standard fallback
            reply = "I couldn't find an exact answer. Please check the FAQ page or rephrase your question (e.g., 'admissions', 'fees', 'programmes').";
        }

        chatRepo.save(ChatSession.of(req.sessionId(), userEmail, message, reply));
        return new ChatResponse(reply, req.sessionId(), fromAI, matchedIntent);
    }

}
