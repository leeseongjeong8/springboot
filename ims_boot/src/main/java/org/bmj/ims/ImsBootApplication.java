package org.bmj.ims;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;

@Configuration
@SpringBootApplication
public class ImsBootApplication implements WebMvcConfigurer {
	
	@Autowired
	private HandlerInterceptor interceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		
		registry.addInterceptor(interceptor).addPathPatterns("/idol/**")
		                                    .addPathPatterns("/group/**");
		
	}

	public static void main(String[] args) {
		SpringApplication.run(ImsBootApplication.class, args);
	}

}
