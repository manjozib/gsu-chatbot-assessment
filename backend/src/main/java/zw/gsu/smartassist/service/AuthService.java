package zw.gsu.smartassist.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import zw.gsu.smartassist.dto.auth.AuthResponse;
import zw.gsu.smartassist.dto.auth.LoginRequest;
import zw.gsu.smartassist.entity.Role;
import zw.gsu.smartassist.entity.User;
import zw.gsu.smartassist.repository.UserRepository;
import zw.gsu.smartassist.security.JwtUtil;

import java.util.Map;

@Service
public class AuthService {
    private final UserRepository userRepo;
    private final PasswordEncoder encoder;
    private final AuthenticationManager authManager;
    private final JwtUtil jwt;

    @Value("${app.security.admin-default-password}")
    String adminDefaultPassword;

    public AuthService(UserRepository userRepo, PasswordEncoder encoder, AuthenticationManager authManager, JwtUtil jwt) {
        this.userRepo = userRepo; this.encoder = encoder; this.authManager = authManager; this.jwt = jwt;
    }

    public void ensureDefaultAdmin(){
        if (!userRepo.existsByEmail("admin@gsu.ac.zw")) {
            var admin = User.of("GSU Admin", "admin@gsu.ac.zw", encoder.encode(adminDefaultPassword), Role.ADMIN);
            userRepo.save(admin);
        }
    }

    public AuthResponse login(LoginRequest req){
        Authentication auth = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.email(), req.password()));
        var user = userRepo.findByEmail(req.email()).orElseThrow();
        String token = jwt.generate(user.getEmail(), Map.of(
                "role", user.getRole().name(),
                "name", user.getName()
        ));
        return new AuthResponse(token, user.getRole().name(), user.getName(), user.getEmail());
    }
}
