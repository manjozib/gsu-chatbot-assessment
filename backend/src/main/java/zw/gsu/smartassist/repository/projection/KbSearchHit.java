package zw.gsu.smartassist.repository.projection;

public interface KbSearchHit {
    Long getId();
    String getCategory();
    String getQuestion();
    String getAnswer();
    Float getRank(); // ts_rank returns float4
}