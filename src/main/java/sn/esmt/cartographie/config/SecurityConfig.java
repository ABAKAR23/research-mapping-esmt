package sn.esmt.cartographie.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .csrf(csrf -> csrf.disable())
                                .authorizeHttpRequests(authz -> authz
                                                // Pages publiques
                                                .requestMatchers("/", "/login",
                                                                "/api/auth/**", "/css/**", "/js/**",
                                                                "/images/**", "/webjars/**")
                                                .permitAll()
                                                // Swagger UI
                                                .requestMatchers("/swagger-ui/**", "/swagger-ui.html",
                                                                "/v3/api-docs/**", "/swagger-resources/**")
                                                .permitAll()
                                                // Import CSV - admin et gestionnaire seulement
                                                .requestMatchers("/import", "/import-csv")
                                                .hasAnyRole("ADMIN", "GESTIONNAIRE")
                                                // Admin endpoints
                                                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                                                // Gestionnaire endpoints
                                                .requestMatchers("/api/manager/**")
                                                .hasAnyRole("ADMIN", "GESTIONNAIRE")
                                                // Tout le reste nécessite une authentification
                                                .anyRequest().authenticated())
                                .formLogin(form -> form
                                                .loginPage("/login")
                                                .loginProcessingUrl("/login")
                                                .defaultSuccessUrl("/dashboard", true)
                                                .failureUrl("/login?error=true")
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                                                .logoutSuccessUrl("/login?logout=true")
                                                .deleteCookies("JSESSIONID")
                                                .invalidateHttpSession(true)
                                                .clearAuthentication(true)
                                                .permitAll());

                return http.build();
        }
}
