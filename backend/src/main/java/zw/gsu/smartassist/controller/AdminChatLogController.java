package zw.gsu.smartassist.controller;

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
    public AdminChatLogController(ChatSessionRepository repo) { this.repo = repo; }

    @GetMapping
    public Page<ChatSession> logs(@RequestParam(defaultValue = "0") int page,
                                  @RequestParam(defaultValue = "20") int size) {
        return repo.findAll(PageRequest.of(page, size, Sort.by("timestamp").descending()));
    }
}
