package org.bmj.ims.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Aspect
@Component
@Slf4j
public class LoggingAspect {
	
	/*
	 * 자바에서는 AOP를 메서드에만 적용(조인포인트가 메서드)
	 * 
	 * 메서드 전 : before
	 * 메서드 후 : after
	 * 메서드 전후 : around
	 * 에러발생시 : afterthrowing
	 * 
	 */
	
//	@Before(value = "bean(*DAOImpl) || bean(*ServiceImpl)")
//	public void dsfasdf(JoinPoint jp) {
//		logger.info(jp.getSignature().toString());
//	}
	
	@Around(value = "bean(*DAOImpl) || bean(*ServiceImpl)")
	public Object aroundadsfasfa(ProceedingJoinPoint pjp)
	throws Throwable {
		
		log.info("메서드 수행전처리");
		Signature signature = pjp.getSignature();
		log.info(signature.getName());
		log.info(signature.getDeclaringTypeName());
		Object result = pjp.proceed();
		log.info("메서드 수행후처리");
		
		return result;
	}

}






