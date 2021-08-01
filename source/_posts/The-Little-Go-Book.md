---
title: The Little Go Book
date: 2020-12-15 23:10:22
tags:
- Goland
categories: 
- Goland
---

# Free Talk

因为下个月将要去字节实习，技术栈要从 Java 转为 Goland ，大约半年多前，我粗略地学习过一次 Goland ，完成了一个简单项目研发。这次打算系统地学习一下 Goland ，这篇文章主要是阅读 The Little Go Book 的笔记，适合有一定其他语言经验的开发者快速了解 Goland。

<!--more-->

# 基础知识

## 简单定义

Go是一种**编译型**、具有**静态类型**和类C语言语法的语言，并具备**垃圾回收机制**。

编译型之前已经讲过， 不再赘述。

**静态类型：**变量必须指定一个类型，可以在声明变量时指定变量类型，但是在大多数情况下，让编译器去自动推断类型。

下载地址：https://golang.org/dl/

## 程序示例

```go
package main // 文件包名

// 导入标准包
import (
    "fmt"
    "os"
)
// 函数名
func main() {
    // 第一个参数即索引0，一直表示当前正在运行的可执行文件的路径
    if len(os.Args) != 2 {
        os.Exit(1)
    }
    // 函数名前加了包名作为前缀
    fmt.Println("It's over ", os.Args[1])
}
```

## 变量和声明

```Go
package main

import (
    "fmt"
)
func main() {
    // 变量声明
    // Go语言会给变量赋默认初始值，整型赋0、布尔型赋false、字符串型赋""
    // 一个变量不能被声明两次（不在相同的代码范围）
    // 不能存在未使用的变量
    var power int
    power = 9000
    // var power int = 9000
    // power := 9000
    fmt.Printf("It's over %d\n", power)
}
```

## 函数声明

Go语言函数支持多值返回

```go
// 无返回值
func log(message string) {
}

// 一个返回值
func add(a int, b int) int {
}

// 两个返回值
func power(name string) (int, bool) {
}
```

```go
// 接受返回值
// _是一个空白标识符，尤其用在返回值时没有真正的赋值
_, exists := power("goku")
    if exists == false {
    // 处理出错情况
}
```

# 结构体

Go不是面向对象语言，没有对象和继承的概念，因此也不存在多态和重载等特性。

```go
type Saiyan struct {
    Name string
    Power int
}
```

## 声明和初始化

```go
// 完全赋值
goku := Saiyan{
    Name: "Goku", //逗号不可省略
    Power: 9000,
}

// 不赋值，为默认值
goku := Saiyan{}

// 部分赋值
goku := Saiyan{Name: "Goku"}
goku.Power = 9000

// 省略字段的名字，按字段的顺序赋值
goku := Saiyan{"Goku", 9000}
```

### 指针

Go不希望我一个变量直接关联一个值，而是希望一个指针指向变量的值，即**间接取值**。

Go中，函数的参数传递都是按值传递，即传递的是一个拷贝。

```go
func main() {
    goku := Saiyan{"Goku", 9000}
    Super(goku)
    fmt.Println(goku.Power)
    // Super 改变的只是 goku 的拷贝
    // 打印输出的值为9000，而不是19000
}

func Super(s Saiyan) {
    s.Power += 10000
}
```

```go
func main() {
	// &取地址符，获得结构体的地址
    goku := &Saiyan{"Goku", 9000}
    Super(goku)
    fmt.Println(goku.Power)
    // 打印输出的值为19000
}
	// 传入一个指针*
func Super(s *Saiyan) {
    s.Power += 10000
}
```

赋值一个指针变量的开销比复制一个复杂的结构体小的多，在一个64位的系统上，指针的大小只有64位（就是表示一个内存地址），因此**指针的真正意义就是通过指针可以共享值**。

## 结构体上的函数

```go
type Saiyan struct {
	Name string
	Power int
}

// 函数的接收者是结构体指针，这个概念第一次见到
func (s *Saiyan) Super() {
	s.Power += 10000
}
```

```Go
goku := &Saiyan{"Goku", 9001}
// 这边的调用函数的方式太新颖了
goku.Super()
fmt.Println(goku.Power) // 将打印：19001
```

## 构造函数

结构体没有构造函数，可以创建一个函数返回一个相应类型的实例代替（类似一个工厂）

```Go
func NewSaiyan(name string, power int) Saiyan {
	return Saiyan{
		Name: name,
		Power: power,
	}
}
```

## new

尽管没有构造函数，Go有一个内置的函数new，用来分配一个类型需要的内存

```Go
goku := new(Saiyan)
// 等效
goku := &Saiyan{}
```

## 结构体字段

结构体里面还可以嵌套其他结构体

```go
type Saiyan struct {
    Name string
    Power int
    Father *Saiyan
}

// 初始化
gohan := &Saiyan{
    Name: "Gohan",
    Power: 1000,
    Father: &Saiyan {
        Name: "Goku",
        Power: 9001,
        Father: nil,
    },
}
```

## 组合

Go 使用组合来替代继承，这本书这部分讲的不清楚，我打算重新梳理一下。

```go
type Animal struct {
    Name string
}

func (a *Animal) Eat() {
    fmt.Printf("%v is eating", a.Name)
    fmt.Println()
}

type Cat struct {
    *Animal
}

cat := &Cat{
    Animal: &Animal{
        Name: "cat",
    },
}
cat.Eat() // cat is eating
```

Cat 的结构体本身没有 Name 字段，也没有去实现 Eat 方法，但却得到了正常的输出。

这边我看了一些文章，还是了解的比较浅，之后再深入了解。

## 指针类型和值类型

在以下情况我们都有实现指针类型，因为传递值类型的数据不可变：

- 一个局部变量赋值
- 结构体字段
- 函数返回值
- 传递给函数的参数
- 方法的接收者

如果不确定使用哪个，就使用指针。

# 映射、数组和切片

## 数组

Go 中数组是**固定大小**的，声明一个数组时我们必须指明它的大小，并且不能被扩展变大。

```go
var scores [10]int
scores[0] = 339
```

## 切片

切片是一个轻量级的结构体，代表数组的一部分。

```go
// 和声明数组不同，切片不需要再[]中指定大小
scores := []int{1,4,293,4,9}

/*
	make 方式
	没有使用 new, 是因为创建一个切片不仅仅是为底层数组分配一段内存，而且也要初始化这个切片
	长度表示切片的长度，容量表示底层数组的大小，索引不能超过切片的长度
*/
scores := make([]int, 10) // 长度和容量都为10
scores := make([]int,0,10) // 长度为0，容量为10
```

使用 append 函数可以扩展切片长度，如果底层的数组已经达到上限， append 会重新创建一个更大的数组，使用2倍算法。

```go
func main() {
    scores := make([]int, 0, 10)
    scores = append(scores, 5)
    fmt.Println(scores) // 打印：[5]
}
```

## 映射

Go 中的映射和 Java 的中哈希表其实一样，包含一个键和值，可以从映射中获取、设置和删除这个值。

和切片一样，映射也是可以通过 `make` 创建的：

```go
func main() {
    lookup := make(map[string]int)
    lookup["goku"] = 9001
    power, exists := lookup["vegeta"]
    // 打印：0和false
    // 0代表一个整数型的默认值
    fmt.Println(power, exists)
}
```

使用`len`可以获得映射中键的个数。使用`delete`可以删除映射中的一个键值对。

```go
// 返回 1
total := len(lookup)
// 没有返回值, 可以调用一个不存在的键
delete(lookup, "goku")
```

映射是动态增长的，可以在使用 `make` 时传递第二个参数设置映射的初始大小：

```go
lookup := make(map[string]int, 100)
```

# 代码组织和接口

## 包

在 Go 中，包名和你的 Go 语言工作空间的目录结构有关。

默认路径为：`$GOPATH/src`

### 循环导入

简单讲就是 A  包导入 B 包，B 包导入 A 包。

### 可见性

如果命令类型或者函数时一一个大写字母开发，那么这个类型和函数就是可见的。

### 包管理

go get 可以将远程文件保存到工作空间 `$GOPATH/src`

## 接口

Go 的接口和 Java 很像，是一种类型，只定义了声明，没有具体实现，用于代码解耦。

```go
type Logger interface {
    Log(message string)
}
```

# Go特性

## 错误处理

Go 语言没有异常处理，一般通过返回值处理错误。

```Go
package main

import (
    "fmt"
    "os"
    "strconv"
)

func main() {
    if len(os.Args) != 2 {
        os.Exit(1)
    }
    n, err := strconv.Atoi(os.Args[1])
    if err != nil {
        fmt.Println("not a valid number")
    } else {
        fmt.Println(n)
    }
}
```

## defer

Go 语言提供了垃圾回收机制，但是一些资源需要手动释放更安全，使用 defer 关键词释放。

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    file, err := os.Open("a_file_to_read")
    if err != nil {
        fmt.Println(err)
        return
    }
    defer file.Close()
    // 读这个文件
}
```

## Go语言风格

Go 语言程序都遵循相同的格式化规则，如使用 tab 缩进并且花括号和语句在同一行。

当你在工程内部，你可以通过下面的命令将工程下所有文件使用相同的格式化规则：

```go
go fmt ./...
```

## 初始化的if

一个值可以在条件语句执行前定义并初始化：

```go
if x := 10; count > x {
    ...
}
```

`if`语句中定义并初始化的值在`if`语句之外是不可用的，但是可以在`else if`和`else`语句中使用。

## 空接口和转换

在大多数面向对象语言中，都有一种内置的基类，叫`object`，它是所有其他类的超类。但是go语言不支持继承，所以没有类似超类的概念。go拥有一个没有任何方法的空接口：`interface{}`。因为每种类型都实现了空接口的0个方法，并且接口都是隐式实现，所以每种类型都实现了空接口的条约。

## 字符串和字节数组

字符串和字节数组有密切关系，我们可以轻易的将它们转换成对方：

```go
stra := "the spice must flow"
byts := []byte(stra)
strb := string(byts)
```

# 并发

## Go 协程

Go 协程类似一个线程，但是 Go 协程是有 Go 自己调度，而不是系统。在协程中的代码可以和其他代码并发执行。

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Println("start")
    go process()
    time.Sleep(time.Millisecond * 10) // this is bad, don't do this!
    fmt.Println("done")
}

func process() {
    fmt.Println("processing")
}
```

Go 协程很容易创建且开销较小。最终多个 Go 协程将会在同一个底层的系统线程上运行。这也常称之为**`M:N`线程模型**，因为我们有`M`个应用线程（Go 协程）运行在`N`个系统线程上。结果就是，一个 Go 协程的开销和系统线程比起来相对很低（一般都是几KB）。在现代的硬件上，有可能拥有成千上万个 Go 协程。

## 同步

在编写并发执行的代码时，特别需要关注的是在**哪里**和**如何**读写一个值（Where、How）。

```go
package main

import (
    "fmt"
    "time"
)

var counter = 0

func main() {
    for i := 0; i < 2; i++ {
        go incr()
    }
    time.Sleep(time.Millisecond * 10)
}

func incr() {
    counter++
    fmt.Println(counter)
}
```

这里应该有两个协程同时读写 counter 变量，可以使用一个互斥锁保证原子性。

```Go
package main

import (
    "fmt"
    "sync"
    "time"
)

var (
    counter = 0
    lock    sync.Mutex
)

func main() {
    for i := 0; i < 2; i++ {
        go incr()
    }
    time.Sleep(time.Millisecond * 10)
}
func incr() {
    lock.Lock()
    defer lock.Unlock()
    counter++
    fmt.Println(counter)
}
```

关于 Go 并发编程这块内容很深，涉及死锁，读写锁等等其他问题。

## 通道

并发编程最难的就是共享数据，在Go 协程中通过通道 channel 传递数据。

### 通道使用

```go
c := make(chan int) // 创建通道
func worker(c chan int) { ... } // 将通道传递给一个函数
CHANNEL <- DATA // 往通道发送数据
VAR := <-CHANNEL // 从通道接受数据
```

```go
package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    c := make(chan int)
    for i := 0; i < 5; i++ {
        worker := &Worker{id: i}
        go worker.process(c)
    }

    for {
        c <- rand.Int()
        time.Sleep(time.Millisecond * 50)
    }
}

type Worker struct {
    id int
}

func (w *Worker) process(c chan int) {
    for {
        data := <-c
        fmt.Printf("worker %d got %d\n", w.id, data)
    }
}
```

### 带缓存的通道

顾名思义，可以指明通道的长度：

```go
c := make(chan int, 100)
```

通过查看通道的长度，我们可以了解到，带缓存通道中有待处理的缓存数据：

```go
for {
    c <- rand.Int()
    fmt.Println(len(c))
    time.Sleep(time.Millisecond * 50)
}
```

### select

`select` 用于丢弃通道中的消息，使用时类似于 `switch`：

```go
for {
    select {
        case c <- rand.Int():
            //可选的代码
        default:
            //这里可以留下空行以丢弃数据
            fmt.Println("dropped")
    }
    time.Sleep(time.Millisecond * 50)
}
```

使用`select`的最主要目的是，通过它管理多个通道。给定多个通道，`select`将阻塞直到有一个通道可用。如果没有可用的通道，当提供了`default`语句时，执行该分支。当多个通道都可用时，选择其中的一个通道是随机的。

### 超时

我们也可以利用超时来丢弃通道中的信息，使用`time.After`函数。

```Go
for {
    select {
        case c <- rand.Int():
        case <-time.After(time.Millisecond * 100): // 返回的是一个通道
            fmt.Println("timed out")
    }
    time.Sleep(time.Millisecond * 50)
}
```

# 总结

这本书确实是非常浅显地讲解了 Goland 的基本特性，花费了大约四个小时做了一下记录，接下来对于语法需要代码训练实现熟悉，常见包和并发编程等需要阅读源码和博客文章进一步了解。