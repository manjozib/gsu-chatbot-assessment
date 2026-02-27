package zw.gsu.smartassist.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.data.domain.Page;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import zw.gsu.smartassist.dto.faq.FaqResponse;
import zw.gsu.smartassist.service.KnowledgeBaseService;

@RestController
@RequestMapping("/api")
@SecurityRequirement(name = "bearerAuth")
public class FaqController {

    private final KnowledgeBaseService kbService;

    public FaqController(KnowledgeBaseService kbService) {
        this.kbService = kbService;
    }

//    @Operation(
//            summary = "Get public FAQs",
//            description = "Retrieves a list of public Frequently Asked Questions (FAQs)."
//    )
//    @GetMapping("/faqs")
//    public List<FaqResponse> publicFaqs() {
//        return kbService.publicList();
//    }


    @Operation(
            summary = "List FAQs",
            description = "Retrieves a paginated list of FAQs. Default page is 0 and size is 20."
    )
    @GetMapping("/faqs")
    public Page<FaqResponse> list(
            @Parameter(description = "Page number to retrieve", example = "0")
            @RequestParam(name = "page", defaultValue = "0") int page,

            @Parameter(description = "Number of FAQs per page", example = "20")
            @RequestParam(name = "size", defaultValue = "20") int size) {

        return kbService.list(page, size);
    }
}