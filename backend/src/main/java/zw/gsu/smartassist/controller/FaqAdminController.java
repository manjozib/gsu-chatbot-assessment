package zw.gsu.smartassist.controller;

import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import zw.gsu.smartassist.dto.faq.FaqCreateRequest;
import zw.gsu.smartassist.dto.faq.FaqResponse;
import zw.gsu.smartassist.service.KnowledgeBaseService;


@RestController
@SecurityRequirement(name = "bearerAuth")
@RequestMapping("/api/admin/faqs")
public class FaqAdminController {
    private final KnowledgeBaseService kbService;
    public FaqAdminController(KnowledgeBaseService kbService) { this.kbService = kbService; }

//    @GetMapping
//    public Page<FaqResponse> list(@RequestParam(defaultValue = "0") int page,
//                                  @RequestParam(defaultValue = "20") int size) {
//        return kbService.list(page, size);
//    }

    @GetMapping
    public Page<FaqResponse> list(
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "20") int size) {
        return kbService.list(page, size);
    }

    @PostMapping
    public ResponseEntity<FaqResponse> create(@RequestBody @Valid FaqCreateRequest req){
        return ResponseEntity.ok(kbService.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<FaqResponse> update(@PathVariable Long id, @RequestBody @Valid FaqCreateRequest req){
        return ResponseEntity.ok(kbService.update(id, req));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id){
        kbService.delete(id); return ResponseEntity.noContent().build();
    }
}
