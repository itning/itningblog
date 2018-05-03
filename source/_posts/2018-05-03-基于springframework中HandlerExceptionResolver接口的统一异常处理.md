---
layout: post
title: ' 基于springframework中HandlerExceptionResolver接口的统一异常处理 '
comments: true
date: 2017-03-29 17:49:49
updated: 2017-03-29 17:49:49
urlname: Unified-exception-handling-based-on-HandlerExceptionResolver-interface-in-springframework
categories: SpringMVC
tags: 异常处理
---
> 系统中异常类型有哪些？
包括预期可能发生的异常、运行时异常（RuntimeException），运行时异常不是预期会发生的。
针对预期可能发生的异常，在代码手动处理异常可以try/catch捕获，可以向上抛出。
针对运行时异常，只能通过规范代码质量、在系统测试时详细测试等排除运行时异常。
#### 1.定义异常类继承Exception

```
//登录异常（账号不存在 密码错误..）
public class LoginException extends Exception{
    private String errorMessage;

    public LoginException(String message) {
        super(message);
        this.errorMessage=message;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
```
#### 2.异常处理（统一异常处理器实现HandlerExceptionResolver接口）

> 前端控制器DispatcherServlet在进行HandlerMapping、调用HandlerAdapter执行Handler过程中，如果遇到异常，进行异常处理。

```
public class ExceptionResolver implements HandlerExceptionResolver{
    public ModelAndView resolveException(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) {
        //打印异常信息
       e.printStackTrace();
        //所有异常类声明
       LoginException loginException;
       DefaultException defaultException;
       //
       String errorMessage;
       if(e instanceof LoginException){
           loginException=(LoginException)e;
           errorMessage=loginException.getErrorMessage();

       }
       else {
            defaultException = new DefaultException("未知错误");
           errorMessage=defaultException.getErrorMessage();
       }
        httpServletRequest.setAttribute("errorMessage",errorMessage);
        try {
            //转发到错误页面
            httpServletRequest.getRequestDispatcher("error.jsp").forward(httpServletRequest,httpServletResponse);
        } catch (ServletException e1) {
            e1.printStackTrace();
        } catch (IOException e1) {
            e1.printStackTrace();
        }

        return new ModelAndView();
    }
}

```
#### 3.在SpringMVC配置文件中配置异常处理bean

```
<bean class="com.ning.exception.ExceptionResolver"/>
```
#### 4.在可能发生异常的位置抛出自定义异常

```
throw new LoginException("登陆失败");
```

> 根据不同的异常类型进行异常处理。
> 系统自定义异常类，在controller方法中、service方法中手动抛出此类异常。
> 针对系统自定义的异常，就可以直接从异常类中获取异常信息，将异常处理在错误页面展示。
针对非自定义异常，对这类重新构造成一个自定义异常，异常信息为“未知错误”，此类错误需要在系统测试阶段去排除。
在统一异常处理器中实现上边的逻辑。
