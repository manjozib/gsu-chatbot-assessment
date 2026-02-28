package zw.gsu.smartassist.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
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

    public FaqAdminController(KnowledgeBaseService kbService) {
        this.kbService = kbService;
    }

    @Operation(
            summary = "Create a new FAQ",
            description = "Creates a new FAQ entry."
    )
    @PostMapping
    public ResponseEntity<FaqResponse> create(
            @Parameter(description = "FAQ creation request", required = true)
            @RequestBody @Valid FaqCreateRequest req) {

        return ResponseEntity.ok(kbService.create(req));
    }

    @Operation(
            summary = "Update an existing FAQ",
            description = "Updates an existing FAQ based on the ID provided."
    )
    @PutMapping("/{id}")
    public ResponseEntity<FaqResponse> update(
            @Parameter(description = "ID of the FAQ to update", required = true)
            @PathVariable(name = "id") Long id,

            @Parameter(description = "FAQ update request", required = true)
            @RequestBody @Valid FaqCreateRequest req) {

        return ResponseEntity.ok(kbService.update(id, req));
    }

    @Operation(
            summary = "Delete an FAQ",
            description = "Deletes an FAQ based on the ID provided."
    )
    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(
            @Parameter(description = "ID of the FAQ to delete", required = true)
            @PathVariable(name = "id") Long id) {

        kbService.delete(id);
        return ResponseEntity.noContent().build();
    }
}