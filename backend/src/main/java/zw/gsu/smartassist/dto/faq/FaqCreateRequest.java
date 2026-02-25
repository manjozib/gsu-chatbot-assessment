package zw.gsu.smartassist.dto.faq;

import jakarta.validation.constraints.NotBlank;

public record FaqCreateRequest(
        @NotBlank String category,
        @NotBlank String question,
        @NotBlank String answer,
        String keywords
) {}
