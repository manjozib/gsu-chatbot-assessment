package zw.gsu.smartassist.dto.auth;

public record AuthResponse(String token, String role, String name, String email) {}

