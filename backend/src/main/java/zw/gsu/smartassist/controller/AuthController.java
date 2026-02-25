package zw.gsu.smartassist.controller;

import jakarta.annotation.PostConstruct;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import zw.gsu.smartassist.dto.auth.AuthResponse;
import zw.gsu.smartassist.dto.auth.LoginRequest;
import zw.gsu.smartassist.service.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    public AuthController(AuthService authService) { this.authService = authService; }

    @PostConstruct
    public void init(){ authService.ensureDefaultAdmin(); }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody @Valid LoginRequest req){
        return ResponseEntity.ok(authService.login(req));
    }
}
