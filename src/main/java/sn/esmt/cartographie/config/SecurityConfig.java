package sn.esmt.cartographie.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import sn.esmt.cartographie.security.CustomOAuth2UserService;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

        @Autowired
        private CustomOAuth2UserService customOAuth2UserService;

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
                                .oauth2Login(oauth2 -> oauth2
                                                .userInfoEndpoint(userInfo -> userInfo
                                                                .userService(customOAuth2UserService))
                                                .defaultSuccessUrl("/dashboard", true))
                                .formLogin(form -> form.disable())
                                .logout(logout -> logout
                                                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                                                .logoutSuccessUrl("/")
                                                .deleteCookies("JSESSIONID")
                                                .invalidateHttpSession(true)
                                                .clearAuthentication(true));

                return http.build();
        }
}
