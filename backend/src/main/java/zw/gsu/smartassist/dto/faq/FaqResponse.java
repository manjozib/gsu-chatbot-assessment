package zw.gsu.smartassist.dto.faq;

public record FaqResponse(
        Long id, String category, String question, String answer, String keywords
) {}
