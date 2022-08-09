package com.finances.backend.data;

import com.finances.backend.security.AuthorizationFilter;
import com.finances.backend.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {
     @Autowired
     AuthorizationFilter authorizationFilter;

     @Autowired
     CustomUserDetails userDetails;

     @Bean
     public PasswordEncoder passwordEncoder() {
      return new BCryptPasswordEncoder();
     }

     @Bean
     public AuthenticationManager authenticationManager(
             AuthenticationConfiguration authenticationConfiguration) throws Exception {
      return authenticationConfiguration.getAuthenticationManager();
     }

    @Bean
    protected SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
     http
             .csrf().disable()
             .exceptionHandling()
             .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
             .and()
             .sessionManagement()
             .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
             .and()
             .authorizeRequests(authorize -> authorize
                     .antMatchers(HttpMethod.GET, "/api/v1/**").permitAll()
                     .antMatchers("/auth/**").permitAll()
                     .antMatchers("/swagger-ui/**").permitAll()
                     .antMatchers("/swagger-resources/**").permitAll()
                     .antMatchers("/swagger-ui.html").permitAll()
                     .antMatchers("/webjars/**").permitAll()
                     .anyRequest()
                     .authenticated());
     http.addFilterBefore(authorizationFilter, UsernamePasswordAuthenticationFilter.class);
     return http.build();
    }




}

