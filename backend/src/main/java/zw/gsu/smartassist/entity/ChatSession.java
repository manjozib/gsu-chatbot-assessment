package zw.gsu.smartassist.entity;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "chat_sessions")
public class ChatSession {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String sessionId;
    private String userEmail;
    @Column(columnDefinition = "TEXT")
    private String message;
    @Column(columnDefinition = "TEXT")
    private String response;
    private Instant timestamp;

    @PrePersist void onCreate(){ timestamp = Instant.now(); }

    public ChatSession() {}

    public ChatSession(Long id, String sessionId, String userEmail, String message, String response) {
        this.id = id; this.sessionId = sessionId; this.userEmail = userEmail; this.message = message; this.response = response;
    }

    public static ChatSession of(String sessionId, String userEmail, String message, String response){
        return new ChatSession(null, sessionId, userEmail, message, response);
    }

    public Long getId() { return id; }
    public String getSessionId() { return sessionId; }
    public String getUserEmail() { return userEmail; }
    public String getMessage() { return message; }
    public String getResponse() { return response; }
    public Instant getTimestamp() { return timestamp; }

    public void setId(Long id) { this.id = id; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    public void setMessage(String message) { this.message = message; }
    public void setResponse(String response) { this.response = response; }
}
