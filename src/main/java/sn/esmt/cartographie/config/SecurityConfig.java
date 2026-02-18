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
                                .csrf(csrf -> csrf.disable()) // Disable CSRF for simplicity in this project (as per
                                                              // requirements often
                                                              // implies simpler setup)
                                .authorizeHttpRequests(authz -> authz
                                                .requestMatchers("/", "/login", "/dashboard", "/candidat", "/api/auth/**", "/css/**", "/js/**",
                                                                "/images/**",
                                                                "/webjars/**")
                                                .permitAll()
                                                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/manager/**", "/import", "/import-csv")
                                                .hasAnyRole("ADMIN", "GESTIONNAIRE")
                                                .anyRequest().authenticated())
                                .oauth2Login(oauth2 -> oauth2
                                                .loginPage("/login") // Custom login page (we have index.jsp acting as
                                                                     // one or login.jsp)
                                                .userInfoEndpoint(userInfo -> userInfo
                                                                .userService(customOAuth2UserService))
                                                .defaultSuccessUrl("/dashboard", true))
                                .logout(logout -> logout
                                                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                                                .logoutSuccessUrl("/")
                                                .deleteCookies("JSESSIONID")
                                                .invalidateHttpSession(true)
                                                .clearAuthentication(true));

                return http.build();
        }
}