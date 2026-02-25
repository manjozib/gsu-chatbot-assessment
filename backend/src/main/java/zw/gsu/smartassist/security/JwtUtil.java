package zw.gsu.smartassist.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.Map;

@Component
public class JwtUtil {
    private final Key key;
    private final long expirationMs;

    public JwtUtil(
            @Value("${app.jwt.secret}") String secret,
            @Value("${app.jwt.expirationMs}") long expirationMs
    ) {
        byte[] keyBytes;
        String value = secret == null ? "" : secret.trim();

        if (value.startsWith("base64url:")) {
            // Support URL-safe Base64 (uses '-' and '_')
            String b64 = value.substring("base64url:".length());
            keyBytes = Decoders.BASE64URL.decode(b64);
        } else if (value.startsWith("base64:")) {
            // Standard Base64 (uses '+' and '/')
            String b64 = value.substring("base64:".length());
            keyBytes = Decoders.BASE64.decode(b64);
        } else {
            // Plain ASCII bytes
            keyBytes = value.getBytes(StandardCharsets.UTF_8);
        }

        if (keyBytes.length < 32) {
            throw new IllegalArgumentException(
                    "app.jwt.secret must be at least 256 bits (32 bytes). " +
                            "Use a longer ASCII secret, or Base64/Base64URL with 'base64:'/'base64url:' prefix."
            );
        }

        this.key = Keys.hmacShaKeyFor(keyBytes);
        this.expirationMs = expirationMs;
    }

    public String generate(String subject, Map<String, Object> claims){
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMs))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public Jws<Claims> parse(String token){
        return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
    }
}