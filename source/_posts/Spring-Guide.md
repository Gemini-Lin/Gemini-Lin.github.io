---
title: Spring Guide
date: 2020-07-28 09:38:41
tags:
- Spring
- AOP
- IOC
- Bean
categories:
- Java后端
- Spring Framework
- Spring
---
# Free Talk
**Spring 是一种轻量级开发框架，旨在提高开发人员的开发效率以及系统的可维护性。**
它包含以下核心模块：
![SpringFramework](https://s1.ax1x.com/2020/07/28/ak6x8H.png)
<!--more-->
# @RestController vs @Controller
## @Controller
`Controller`返回一个页面视图，对应传统的Spring MVC应用，应用于前后端不分离的开发。
![Controller](https://s1.ax1x.com/2020/07/28/akgMSH.png)
## @RestController
`RestController`返回JSON或XML格式的对象数据，属于RESTFUL Web服务，是目前主流的前后端分离开发。
![RestController](https://s1.ax1x.com/2020/07/28/akgy7V.png)
## @Controller + @ResponseBody
`@Controller + @ResponseBody = @RestController`
> `@ResponseBody`注解的作用是将 `Controller`的方法返回对象转换为指定的格式后，写入到 HTTP 响应(Response)对象的 body,通常来返回 JSON 数据。
PS：注解不是 Spring 所特有的，而且 Java 语言的特性，可以看我之前写过的 Java 注解篇

![@Controller + @ResponseBody](https://s1.ax1x.com/2020/07/28/ak2cDI.png)
# MVC vs RESTful
## MVC
**Spring MVC 是一个模型 - 视图 - 控制器（MVC）的Web框架**，建立在中央前端控制器servlet（DispatcherServlet），它负责发送每个请求到合适的处理程序，使用视图来最终返回响应结果的概念。
![MVC](https://s1.ax1x.com/2020/07/28/akRvwt.png)
## RESTful
RESTful是一种网络应用程序的设计风格和开发方式，只要一个架构符合REST原则，就可以称为RESTful架构。
RESTFUL特点包括：
1. 每一个URI代表1种资源；
2. 客户端使用GET、POST、PUT、DELETE4个表示操作方式的动词对服务端资源进行操作：GET用来获取资源，POST用来新建资源（也可以用于更新资源），PUT用来更新资源，DELETE用来删除资源；
3. 通过操作资源的表现形式来操作资源；
4. 资源的表现形式是XML或者HTML；
5. 客户端与服务端之间的交互在请求之间是无状态的，从客户端到服务端的每个请求都必须包含理解请求所必需的信息。

# IOC & AOP
## IOC
**IoC(全称为Invere of Control,控制翻转)，是一种设计思想，它将原本在程序中手动创建对象的控制权交给 Spring 框架来管理。** IoC 容器是 Spring 用来实现 IoC 的载体， IoC 容器实际上是个 Map(key,value), Map 中存放的是各种对象。
**通俗来讲，IoC 容器就像是一个工厂一样，当我们需要创建一个对象的时候，只需要配置好配置文件/注解即可，完全不用考虑对象是如何被创建出来的。**
## AOP
**AOP(全称为Aspect-Oriented Programming,面向切面编程),通过预编译方式和运行期间动态代理实现程序功能的统一维护的一种技术。**
AOP是OOP(面向对象编程)的延续，OOP把系统看作多个对象的交互，AOP把系统分解为不同的关注点，称为切面(Aspect)。AOP的理念：就是将分散在各个业务逻辑代码中相同的代码通过横向切割的方式抽取到一个独立的模块中！
# Bean
**在 Spring 中，构成应用程序主干并由Spring IoC容器管理的对象称为Bean。**Bean是一个由Spring IoC容器实例化、组装和管理的对象。
Bean规范如下：
1. 所有属性为private
2. 提供默认构造方法
3. 提供getter和setter
4. 实现serializable接口

## @Component vs @Bean
### @Component
`@Component` 注解作用于类,通常是通过类路径扫描来自动侦测以及自动装配到Spring容器中(我们可以使用 `@ComponentScan` 注解定义要扫描的路径从中找出标识了需要装配的类自动装配到 Spring 的 Bean 容器中)。
### @Bean
`@Bean` 注解作用于方法,通常是我们在标有该注解的方法中定义产生这个 Bean ,`@Bean` 告诉了 Spring 这是某个类的实例，当我需要用它的时候还给我。
> `@Bean `注解比 Component 注解的自定义性更强，而且很多地方我们只能通过 `@Bean` 注解来注册 Bean。比如当我们引用第三方库中的类需要装配到 Spring容器时，则只能通过 `@Bean`来实现。

使用示例：
```Java
@Configuration
public class AppConfig {
    @Bean
    public TransferService transferService() {
        return new TransferServiceImpl();
    }

}
```
上面的代码相当于下面的 xml 配置
```xml
<beans>
    <bean id="transferService" class="com.acme.TransferServiceImpl"/>
</beans>
```
## Bean注解
我们一般使用 `@Autowired` 注解自动装配 bean，要想把类标识成可用于 `@Autowired` 注解自动装配的 bean 的类,采用以下注解可实现：
+ `@Component` ：通用的注解，可标注任意类为 Spring 组件。如果一个Bean不知道属于哪个层，可以使用 `@Component` 注解标注。
+ `@Repository` : 对应持久层即 Dao 层，主要用于数据库相关操作。
+ `@Service` : 对应服务层，主要涉及一些复杂的逻辑，需要用到 Dao层。
+ `@Controller` : 对应 Spring MVC 控制层，主要用户接受用户请求并调用 Service 层返回数据给前端页面。

# 参考资料
1. https://snailclimb.gitee.io/javaguide/#/docs/system-design/framework/spring/SpringInterviewQuestions
2. https://dzone.com/articles/spring-framework-restcontroller-vs-controller（图片来源）
3. https://javarevisited.blogspot.com/2017/08/difference-between-restcontroller-and-controller-annotations-spring-mvc-rest.html?m=1
4. https://www.yiibai.com/spring_mvc/
5. https://baike.baidu.com/item/RESTful