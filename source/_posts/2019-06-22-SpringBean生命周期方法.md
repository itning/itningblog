---
layout: post
title: ' SpringBean生命周期方法 '
comments: true
date: 2019-06-22 10:29:01
updated: 2019-06-22 10:29:01
urlname: SpringBean-lifecycle-method
categories: Spring
tags:
- Spring
- Bean
---

对Spring Bean 生命周期方法的总结

```java
@Bean(initMethod = "initMethod", destroyMethod = "destroyMethod")
public BeanTest beanTest() {
	return new BeanTest();
}
```

```java
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;
import org.springframework.boot.web.servlet.context.AnnotationConfigServletWebServerApplicationContext;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

/**
 * @author itning
 * @date 2019/6/22 10:04
 */
public class BeanTest implements InitializingBean, DisposableBean, BeanPostProcessor, ApplicationContextAware {
    public BeanTest() {
        System.out.println("1.constructor");
    }

    @PostConstruct
    public void postConstruct() {
        System.out.println("2.PostConstruct");
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("3.InitializingBean:afterPropertiesSet");
    }


    public void initMethod() {
        System.out.println("4.initMethod");
    }

    @PreDestroy
    public void annDestroy() {
        System.out.println("1.PreDestroy");
    }

    @Override
    public void destroy() throws Exception {
        System.out.println("2.DisposableBean:destroy");
    }


    public void destroyMethod() {
        System.out.println("3.destroyMethod");
    }

    /*@Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessBeforeInitialization:" + beanName + "  " + bean);
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessAfterInitialization:" + beanName + "  " + bean);
        return bean;
    }*/

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        AnnotationConfigServletWebServerApplicationContext a = (AnnotationConfigServletWebServerApplicationContext) applicationContext;
        DefaultListableBeanFactory beanFactory = (DefaultListableBeanFactory) a.getBeanFactory();
        new Thread(() -> {
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            beanFactory.removeBeanDefinition("beanTest");
        }).start();
    }
}
```
初始化：

1. constructor
2. PostConstruct
3. InitializingBean:afterPropertiesSet
4. initMethod

销毁：

1. PreDestroy
2. DisposableBean:destroy
3. destroyMethod
