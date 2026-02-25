package zw.gsu.smartassist.dto.chat;

public record ChatResponse(
        String reply,
        String sessionId,
        boolean fromAI,
        String matchedIntent
) {}
