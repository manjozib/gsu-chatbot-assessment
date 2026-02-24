package zw.gsu.smartassist.entity;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "knowledge_base")
public class KnowledgeBase {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String category;
    @Column(columnDefinition = "TEXT")
    private String question;
    @Column(columnDefinition = "TEXT")
    private String answer;
    @Column(columnDefinition = "TEXT")
    private String keywords;
    private Instant createdAt;
    private Instant updatedAt;

    @PrePersist void onCreate(){ createdAt = Instant.now(); updatedAt = createdAt; }
    @PreUpdate void onUpdate(){ updatedAt = Instant.now(); }

    public KnowledgeBase() {}

    public KnowledgeBase(Long id, String category, String question, String answer, String keywords) {
        this.id = id; this.category = category; this.question = question; this.answer = answer; this.keywords = keywords;
    }

    public Long getId() { return id; }
    public String getCategory() { return category; }
    public String getQuestion() { return question; }
    public String getAnswer() { return answer; }
    public String getKeywords() { return keywords; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }

    public void setId(Long id) { this.id = id; }
    public void setCategory(String category) { this.category = category; }
    public void setQuestion(String question) { this.question = question; }
    public void setAnswer(String answer) { this.answer = answer; }
    public void setKeywords(String keywords) { this.keywords = keywords; }
}
