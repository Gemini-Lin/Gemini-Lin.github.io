---
title: SpringBoot系列 (一) -- 启动原理解析
date: 2020-07-28 17:01:46
tags:
- SpringBoot
- SpringBootApplication
categories:
- Java后端
- Spring Framework
- SpringBoot
---
# Free Talk
SpringBoot 通过 `@SpringBootApplication` 注解及`SpringApplication.run()`方法，进行启动类的配置加载：
```Java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```
<!--more-->
# @SpringBootApplication
查看源代码可知：
```Java
@Target({ElementType.TYPE}) // 定义注解的作用目标，接口、类、枚举、注解
@Retention(RetentionPolicy.RUNTIME) // 定义注解的保留策略，注解会在class字节码文件中存在，在运行时可以通过反射获取到
@Documented // 说明该注解将被包含在javadoc中
@Inherited // 说明子类可以继承父类中的该注解

// 前四个为元注解，指注解的注解
// 后面三个注解，为@SpringBootApplication的核心

@SpringBootConfiguration // 点开源码为@Configuration
@EnableAutoConfiguration
@ComponentScan(
    excludeFilters = {@Filter(
    type = FilterType.CUSTOM,
    classes = {TypeExcludeFilter.class}
), @Filter(
    type = FilterType.CUSTOM,
    classes = {AutoConfigurationExcludeFilter.class}
)}
)
```
## @Configuration
```Java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Component // 配置类也是IoC容器中的一个组件
public @interface Configuration {
    @AliasFor(
        annotation = Component.class
    )
    String value() default "";

    boolean proxyBeanMethods() default true;
}
```
## @ComponentScan
`@ComponentScan`这个注解在 Spring 中很重要，它对应 XML 配置中的元素，`@ComponentScan`的功能其实就是自动扫描并加载符合条件的组件（比如`@Component`和`@Repository`等）或者 bean 定义，最终将这些 bean 定义加载到 IoC 容器中。

我们可以通过 basePackages 等属性来细粒度的定制`@ComponentScan`自动扫描的范围，如果不指定，则默认 Spring 框架实现会从声明`@ComponentScan`所在类的 package 进行扫描。

## @EnableAutoConfiguration
**开启自动配置功能**
```Java
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@AutoConfigurationPackage // 自动配置包  
@Import({AutoConfigurationImportSelector.class}) 
// @Import 注解可以普通类导入到 IoC容器中 
```
### @AutoConfigurationPackage
通过查看`@AutoConfigurationPackage`源码
```Java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@Import(AutoConfigurationPackages.Registrar.class) 
// 仍然采用的是@Import注解将这个类导入 IoC 容器中
```
我好奇地打开了这个类的实现方法
```Java
@Override
public void registerBeanDefinitions(AnnotationMetadata metadata, BeanDefinitionRegistry registry) {
    register(registry, new PackageImports(metadata).getPackageNames().toArray(new String[0]));
}
```
在此处进行断点Debug发现：
![metadata](https://s1.ax1x.com/2020/07/28/aElEIf.png)
在 metadata 元信息中获得了我们导入的类：`cn.geminiplanet.springboot.helloworld`
Amazing !!!

### Import({AutoConfigurationImportSelector.class}) 
导入需要组件的选择器,将所有需要导入的组件以全类名的方式返回。
```Java
@Override
public String[] selectImports(AnnotationMetadata annotationMetadata) {
    if (!isEnabled(annotationMetadata)) {
        return NO_IMPORTS;
    }
    AutoConfigurationEntry autoConfigurationEntry = getAutoConfigurationEntry(annotationMetadata);
    return StringUtils.toStringArray(autoConfigurationEntry.getConfigurations());
}
```
这里内部使用 SpringFactoriesLoader,从指定的配置文件META-INF/spring.factories加载配置, 自动配置类就生效了。


# SpringApplication
> 以下这一部分内容，我没怎么弄懂，来源：http://www.51gjie.com/javaweb/1042.html

**SpringApplication 是 SpringBoot 驱动 Spring 应用上下文的引导类，他的run() 方法启动 Spring 应用，实质上是为 Spring 应用创建并初始化 Spring 上下文。**

## 执行流程

1. 初始化监听器，以及添加到SpringApplication的自定义监听器。
2. 发布ApplicationStartedEvent事件，如果想监听ApplicationStartedEvent事件，你可以这样定义：public class ApplicationStartedListener implements ApplicationListener，然后通过SpringApplication.addListener(..)添加进去即可。
3. 装配参数和环境，确定是web环境还是非web环境。
4. 装配完环境后，就触发ApplicationEnvironmentPreparedEvent事件。
5. 如果SpringApplication的showBanner属性被设置为true，则打印启动的Banner。
6. 创建ApplicationContext，会根据是否是web环境，来决定创建什么类型的ApplicationContext。
7. 装配Context的环境变量，注册Initializers、beanNameGenerator等。
8. 发布ApplicationPreparedEvent事件。
9. 注册springApplicationArguments、springBootBanner，加载资源等
10. 遍历调用所有SpringApplicationRunListener的contextLoaded()方法。
11. 调用ApplicationContext的refresh()方法,装配context beanfactory等非常重要的核心组件。
12. 查找当前ApplicationContext中是否注册有CommandLineRunner，如果有，则遍历执行它们。
13. 发布ApplicationReadyEvent事件，启动完毕，表示服务已经可以开始正常提供服务了。通常我们这里会监听这个事件来打印一些监控性质的日志，表示应用正常启动了。

SpringBoot会触发其他的一些事件，这些事件按下列顺序触发：
（1）ApplicationStartingEvent：项目刚启动时触发，此时除了注册监听器和初始器之外，其他所有处理都没有开始；
（2）ApplicationEnvironmentPreparedEvent：上下文得到环境信息之后触发，此时上下文创建还没有创建；
（3）ApplicationPreparedEvent：bean的定义信息加载完成之后触发，此时bean还没有初始化；
（4）ApplicationReadyEvent：在所有bean初始化完毕，所有回调处理完成，系统准备处理服务请求时触发；
（5）ApplicationFailedEvent：启动过程出现异常时候触发。

## SpringApplication.run()
如果我们使用的是SpringApplication的静态run方法，那么，这个方法里面首先要创建一个SpringApplication对象实例，然后调用这个创建好的SpringApplication的实例方法。在SpringApplication实例初始化的时候，它会提前做几件事情：
1. 根据classpath里面是否存在某个特征类（org.springframework.web.context.ConfigurableWebApplicationContext）来决定是否应该创建一个为Web应用使用的ApplicationContext类型。
2. 使用SpringFactoriesLoader在应用的classpath中查找并加载所有可用的ApplicationContextInitializer。
3. 使用SpringFactoriesLoader在应用的classpath中查找并加载所有可用的ApplicationListener。
4. 推断并设置main方法的定义类。
它会执行以下步骤：
1. 创建一个合适的ApplicationContext实例 （取决于classpath）。
2. 注册一个CommandLinePropertySource，以便将命令行参数作为Spring properties。
3. 刷新application context，加载所有单例beans。
4. 激活所有CommandLineRunner beans。


# 参考资料
1. http://tengj.top/2017/03/09/springboot3/
2. https://blog.csdn.net/yixiaogang109/article/details/7328466
3. http://www.51gjie.com/javaweb/1042.html