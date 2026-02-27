package zw.gsu.smartassist.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import zw.gsu.smartassist.entity.ChatSession;
import zw.gsu.smartassist.repository.ChatSessionRepository;

@SecurityRequirement(name = "bearerAuth")
@RestController
@RequestMapping("/api/admin/chat-logs")
public class AdminChatLogController {

    private final ChatSessionRepository repo;

    public AdminChatLogController(ChatSessionRepository repo) {
        this.repo = repo;
    }

    @Operation(
            summary = "Retrieve chat logs",
            description = "Fetch paginated chat session logs. Default page is 0 and size is 20."
    )
    @GetMapping
    public Page<ChatSession> logs(
            @Parameter(description = "Page number to retrieve, starting from 0", example = "0")
            @RequestParam(name = "page", defaultValue = "0") int page,

            @Parameter(description = "Number of records per page", example = "20")
            @RequestParam(name = "size", defaultValue = "20") int size) {

        return repo.findAll(PageRequest.of(page, size, Sort.by("timestamp").descending()));
    }
}