package zw.gsu.smartassist.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import zw.gsu.smartassist.dto.faq.FaqCreateRequest;
import zw.gsu.smartassist.dto.faq.FaqResponse;
import zw.gsu.smartassist.entity.KnowledgeBase;
import zw.gsu.smartassist.repository.KnowledgeBaseRepository;
import zw.gsu.smartassist.repository.projection.KbSearchHit;

import java.util.List;

@Service
public class KnowledgeBaseService {
    private final KnowledgeBaseRepository repo;
    public KnowledgeBaseService(KnowledgeBaseRepository repo) { this.repo = repo; }

    public Page<FaqResponse> list(int page, int size) {
        return repo.findAll(PageRequest.of(page, size, Sort.by("id").descending()))
                .map(k -> new FaqResponse(k.getId(), k.getCategory(), k.getQuestion(), k.getAnswer(), k.getKeywords()));
    }

    public List<FaqResponse> publicList(){
        return repo.findAll().stream()
                .map(k -> new FaqResponse(k.getId(), k.getCategory(), k.getQuestion(), k.getAnswer(), k.getKeywords()))
                .toList();
    }

    public FaqResponse create(FaqCreateRequest req){
        var k = repo.save(new KnowledgeBase(null, req.category(), req.question(), req.answer(), req.keywords()));
        return new FaqResponse(k.getId(), k.getCategory(), k.getQuestion(), k.getAnswer(), k.getKeywords());
    }

    public FaqResponse update(Long id, FaqCreateRequest req){
        var k = repo.findById(id).orElseThrow();
        k.setCategory(req.category());
        k.setQuestion(req.question());
        k.setAnswer(req.answer());
        k.setKeywords(req.keywords());
        repo.save(k);
        return new FaqResponse(k.getId(), k.getCategory(), k.getQuestion(), k.getAnswer(), k.getKeywords());
    }

    public void delete(Long id){ repo.deleteById(id); }

    public List<KnowledgeBase> searchRaw(String q){ return repo.search(q); }
    public List<KbSearchHit> searchTopWithRank(String q, int a){ return repo.searchTopWithRank(q, a); }
}
