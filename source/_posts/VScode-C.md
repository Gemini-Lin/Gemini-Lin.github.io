---
title: VScode配置C/C++
date: 2020-08-13 17:25:20
tags:
- VScode
- C
- C++
categories: 
- 工具分享
---
# Free Talk

大一的时候第一次学习C语言，使用的编译器是C-Free 5.0。后面陆陆续续地使用了Clion、VS，到在Linux下直接用记事本写代码。这次电脑重装系统之后，一直都没有配置一下C语言编译器。**作为导生，正好趁这个机会写一篇配置教程给未来班上的学弟学妹们。**VScode在微软的大力扶持和开源社区下，逐渐称为相当主流的编译器，它有很多的优势，有兴趣可以自己了解。
<!--more-->

# 安装VScode

下载官网：https://code.visualstudio.com/

直接点击Download，下载安装

![image-20200813173941539](https://i.loli.net/2020/08/13/Ylp6EbHky1Lig5o.png)

# 安装MinGW编译器

下载地址：https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/

选择图片中的第一个下载

> 因为是在网站服务器在国外，下载可能很慢，推荐购买一个VPN，每月5元30G
>
> VPN推荐链接：https://sockboom.club/auth/register?affid=210592

![image-20200813175934062](https://i.loli.net/2020/08/13/zWJrsAwHNiYZVbQ.png)

**注意事项：**安装过程中路径不能出现**中文和空格**，以后安装程序最好自己选择一个路径

## 配置环境变量

1.  点击编辑系统环境变量

![image-20200813180646257](https://i.loli.net/2020/08/13/yzcUV5WA2MOYRpB.png)

2. 点击环境变量![image-20200813180908840](https://i.loli.net/2020/08/13/sGhumn8LFfH4JEq.png)

3. 点击Path![image-20200813180931500](https://i.loli.net/2020/08/13/2OqDH98A7xcsGoi.png)

4. 添加刚刚安装的mingw下的bin目录地址

   ![image-20200813181028331](https://i.loli.net/2020/08/13/7KGoyvR6nPO2peS.png)

5. cmd输入gcc -v查看是否配置成功![image-20200813181152415](https://i.loli.net/2020/08/13/NzrE5F8IcYf7d9t.png)

# 配置C/C++环境

## 安装C/C++插件

在扩展商店中搜索C/C++，选择第一个下载

![image-20200813181521127](https://i.loli.net/2020/08/13/Hj8IXUbrns6WmPN.png)

## 配置C/C++插件

按下Ctrl+Shift+P，进入命令面板，输入C/C++，选择图片中的第一个

![image-20200813181930127](https://i.loli.net/2020/08/13/wGKVqJ4I9SkUhCD.png)

![image-20200813183555906](https://i.loli.net/2020/08/13/mlVbNa1SFefyOnr.png)

配置编译器路径（自己刚刚安装的）

![image-20200813182056549](https://i.loli.net/2020/08/13/S5E2nhz891wsAjc.png)

配置IntelliSense 模式位gcc-x64

![image-20200813182158923](https://i.loli.net/2020/08/13/r7u58U4yGVADmOn.png)

这个时候，我们会发现资源管理器的左侧出现了.vscode文件

![image-20200813182415041](https://i.loli.net/2020/08/13/Ub4DP3wYeMNmln9.png)

接下来我们需要配置这三个文件

## launch.json

```json
{
    "version": "0.2.0",  
    "configurations": [  
        {  
            "name": "(gdb) Launch", // 配置名称，将会在启动配置的下拉菜单中显示
            "type": "cppdbg",       // 配置类型，这里只能为cppdbg
            "request": "launch",    // 请求配置类型，可以为launch（启动）或attach（附加）  
            "program": "${workspaceFolder}/${fileBasenameNoExtension}.exe",// 将要进行调试的程序的路径  
            "args": [],             // 程序调试时传递给程序的命令行参数，一般设为空即可  
            "stopAtEntry": false,   // 设为true时程序将暂停在程序入口处，一般设置为false  
            "cwd": "${workspaceFolder}", // 调试程序时的工作目录，一般为${workspaceFolder}即代码所在目录  
            "environment": [],  
            "externalConsole": true, // 调试时是否显示控制台窗口，一般设置为true显示控制台  
            "MIMode": "gdb",  
            "miDebuggerPath": "F:\\mingw64\\bin\\gdb.exe", // miDebugger的路径，注意这里要与MinGw的路径对应  
            "preLaunchTask": "gcc", // 调试会话开始前执行的任务，一般为编译程序，c++为g++, c为gcc  
            "setupCommands": [  
                {   
            "description": "Enable pretty-printing for gdb",  
                    "text": "-enable-pretty-printing",  
                    "ignoreFailures": true  
                }  
            ]  
        }  
    ]  
}
```

## tasks.json

```json
{
    "version": "2.0.0",
    "command": "gcc",
    "args": ["-g","${file}","-o","${fileBasenameNoExtension}.exe"],    // 编译命令参数
    "problemMatcher": {
        "owner": "cpp",
        "fileLocation": ["relative", "${workspaceFolder}"],
        "pattern": {
            "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
            "file": 1,
            "line": 2,
            "column": 3,
            "severity": 4,
            "message": 5
        }
    },
    "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "new", //这里shared表示共享，改成new之后每个进程创建新的端口
        "showReuseMessage": true,
        "clear": false
    }

}
```

## c_cpp_properties.json

```json
{
    "configurations": [
        {
            "name": "Win32",
            "includePath": [
                "${workspaceFolder}/**"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE"
            ],
            "windowsSdkVersion": "10.0.18362.0",
            "compilerPath": "F:/mingw64/bin/gcc.exe",
            "cStandard": "c11",
            "cppStandard": "c++17",
            "intelliSenseMode": "gcc-x64"
        }
    ],
    "version": 4
}
```

# 启动调试

## 编写测试文件

```C
#include<stdio.h>

int main(){
    printf("hello world!\n");
    getchar();
    return 0;
}
```

![image-20200813182743400](https://i.loli.net/2020/08/13/xB9GJj5pEOwArPN.png)

## 调试测试

按下F5键

![image-20200813182849756](https://i.loli.net/2020/08/13/6QXv1gfn7srRGa9.png)

# 问题说明

因为每个人在配置的过程中，都会出现各种问题，最好方法是谷歌（百度）

因为我的教程有遗漏的部分，可以看看下面的参考链接

## 参考链接

1. https://zhuanlan.zhihu.com/p/87864677
2. https://zhuanlan.zhihu.com/p/77074009
3. https://blog.csdn.net/bat67/article/details/76095813
4. https://juejin.im/post/6844904098354069512