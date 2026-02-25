package zw.gsu.smartassist.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimitFilter extends OncePerRequestFilter {

    private final int requestsPerMinute;
    private final Map<String, Window> store = new ConcurrentHashMap<>();

    public RateLimitFilter(@Value("${app.rateLimit.requestsPerMinute:30}") int rpm) {
        this.requestsPerMinute = rpm;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.startsWith("/api/chat")) {
            String key = request.getRemoteAddr();
            Window w = store.computeIfAbsent(key, k -> new Window());
            synchronized (w) {
                long now = Instant.now().getEpochSecond();
                if (now - w.start >= 60) { w.start = now; w.count = 0; }
                if (++w.count > requestsPerMinute) {
                    response.setStatus(429);
                    response.getWriter().write("Too Many Requests");
                    return;
                }
            }
        }
        filterChain.doFilter(request, response);
    }

    static class Window { long start = Instant.now().getEpochSecond(); int count = 0; }
}
