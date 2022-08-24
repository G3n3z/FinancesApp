package com.backendfinancesjpa;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan
public class BackendFinancesJpaApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendFinancesJpaApplication.class, args);
	}

}
