package zw.gsu.smartassist.controller;

import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import zw.gsu.smartassist.dto.chat.ChatRequest;
import zw.gsu.smartassist.dto.chat.ChatResponse;
import zw.gsu.smartassist.service.ChatService;

@RestController
@RequestMapping("/api")
public class ChatController {
    private final ChatService chatService;
    public ChatController(ChatService chatService) { this.chatService = chatService; }

    @PostMapping("/chat")
    public ResponseEntity<ChatResponse> chat(@RequestBody @Valid ChatRequest req){
        return ResponseEntity.ok(chatService.chat(req));
    }
}
