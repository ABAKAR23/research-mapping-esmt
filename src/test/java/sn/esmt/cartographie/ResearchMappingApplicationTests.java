package sn.esmt.cartographie;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import sn.esmt.cartographie.security.CustomOAuth2UserService;

@SpringBootTest(
    properties = {
        "spring.security.oauth2.client.registration.google.client-id=test-client-id",
        "spring.security.oauth2.client.registration.google.client-secret=test-client-secret",
        "spring.security.oauth2.client.registration.google.scope=openid,profile,email"
    }
)
class ResearchMappingApplicationTests {

    @MockBean
    private CustomOAuth2UserService customOAuth2UserService;

    @Test
    void contextLoads() {
        // Test that the application context loads successfully
    }
}
