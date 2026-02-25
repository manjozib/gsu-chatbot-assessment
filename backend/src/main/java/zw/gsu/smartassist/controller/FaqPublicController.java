package zw.gsu.smartassist.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import zw.gsu.smartassist.dto.faq.FaqResponse;
import zw.gsu.smartassist.service.KnowledgeBaseService;

import java.util.List;

@RestController
@RequestMapping("/api")
public class FaqPublicController {
    private final KnowledgeBaseService kbService;
    public FaqPublicController(KnowledgeBaseService kbService) { this.kbService = kbService; }

    @GetMapping("/faqs")
    public List<FaqResponse> publicFaqs(){ return kbService.publicList(); }
}
