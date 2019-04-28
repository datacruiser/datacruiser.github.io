---
title: Scala for the Impatient Chapter 7 练习
date: 2019-04-26 15:22:47
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第七章练习。
---
#### 第1题 
编写示例程序，展示为什么

```scala
package com.horstmann.impatient
```
不同于

```scala
package com
package horstmann
package impatient
```

主要区别在于包的可见性不同，后者上层包也可见，而串写以后只要当前的包可见，即只有 impatient 包是可见的。

示例代码如下：
```scala
package excercises.chapter7

package com {
  package horstmann{
    object A{
      def hello = println("I am A")
    }
    package impatient{
      object B extends App{
        def hello = A.hello
        hello
      }
    }
  }
}
```
运行结果如下：

```scala
[info] Running excercises.chapter7.com.horstmann.impatient.B 
I am A
[success] Total time: 4 s, completed Apr 26, 2019 3:37:34 PM
```

如果代码修改如下：

```scala
package excercises.chapter7

package com.horstmann.impatient {
  object C extends App{
    B.hello
    A.hello
  }
}
```

则会编译错误：

```scala
[error]     A.hello
[error]     ^
[error] one error found
[error] (Compile / compileIncremental) Compilation failed
[error] Total time: 0 s, completed Apr 26, 2019 3:44:51 PM
```

此时，IDE 的提示如下:
![Imgur](https://i.imgur.com/bHk3X0y.png)
显然，当前的只有impatient 包是可见的，上层的 horstmann 里面的内容并不可见，正确的修改后的能够运行的代码应该是这样的：

```scala
package excercises.chapter7

package com.horstmann.impatient {

  import excercises.chapter7.com.horstmann.A

  object C extends App{
    B.hello
    A.hello
  }
}
```
执行结果如下：

```scala
[info] Running excercises.chapter7.com.horstmann.impatient.C 
I am A
I am A
[success] Total time: 8 s, completed Apr 26, 2019 3:52:03 PM
```

#### 第2题 
编写一段让你的 Scala 朋友们感到困惑的代码，使用一个不在顶部的 com 包。

编写两段代码，a2.scala：
```scala
package excercises.chapter7

package com {
  package horstmann {
    package com {
      package horstmann {
        object A2 {
          def hello = println("I am the Ghost A")
        }
      }
    }
  }
}
```

b2.scala:

```scala
package excercises.chapter7

package com {
  package horstmann {
    object A2 {
      def hello =println("I am A2")
    }
    package impatient {
      object B2 extends App {
        def hello = com.horstmann.A2.hello
        hello
      }
    }
  }
}
```

在IDE 集成环境当中 sbt 编译后的运行结果如下：

```scala
[info] Running excercises.chapter7.com.horstmann.impatient.B2 
I am the Ghost A
[success] Total time: 7 s, completed Apr 26, 2019 4:22:12 PM
```

手动编译，先编译b2.scala，再编译a2.scala，然后再运行，结果如下：

```bash
scalac b2.scala 
scalac a2.scala
scala -cp . excercises.chapter7.com.horstmann.impatient.B2
I am A2
```
如果先编译b2，则 B2会调用同文件当中的 com.horstmann包中的 A2对象，如果先编译 a2，则 a2.scala文件当中的com.horstmann.A2会被调用。

#### 第3题 
编写一个包 random，加入函数 nextInt(): Int、nextDouble(): DoubleHesetSeed(seed: Int): Unit。生成随机数的算法采用线性同余生成器：
$$后值=(前值 *a+b)mod2^2$$其中，$a=1664525,b=1013904223,n=32,$前值的初始值为 seed。


在编码之前先了解下线性同余法，随机数的求解步骤如下：
$$
\begin{cases}
X_0 = SEED, & \text{设定初始值}
\\X_n = (A * X_{n-1} + B) (Mod M)
\\R_n = X_n/M, & \text{取模}
\end{cases}
$$

本题中$M=2^{32}$。

代码如下：

```scala
package excercises.chapter7

package random {
  object Random{
    private val a: Int = 1664525
    private val b: Int = 1013904223
    private val n: Int = 32

    private var seed: Int = 0
    private var current: BigInt = 0
    private var next: BigInt = 0

    def nextInt(): Int = {
      next = (current * a + b) % BigInt(math.pow(2, n).toLong)
      current = next
      (next % BigInt(math.pow(2, n).toLong)).intValue() //Converts this BigDecimal to an Int. If the BigDecimal is too big to fit in an Int, only the low-order 32 bits are returned.
    }

    def nextDouble(): Double = {
      nextInt().toDouble
    }

    def setSeed(newSeed: Int): Unit = {
      seed = newSeed
      current = seed
    }
  }
}

object randomTest extends App{
  var r  = random.Random
  r.setSeed(args(0).toInt)
  for(i <- 1 to 10) println(r.nextInt())
  for(i <- 1 to 10) println(r.nextDouble())
}
```
测试结果如下：

```scala
[info] Running excercises.chapter7.randomTest 10
1030549473
797165516
-1431871301
163339998
209336485
424841664
-1485645281
-852270862
-1739764823
671228148
1.434441667E9
-1.779459514E9
1.642573037E9
1.73212708E9
1.245609383E9
7.54638554E8
1.027678321E9
1.991483164E9
1.588539339E9
-2.09385813E9
[success] Total time: 8 s, completed Apr 26, 2019 5:48:35 PM
```
#### 第4题 
在你看来，Scala 的设计者为什么要提供package object语法而不是简单地让你将函数和变量添加到包中呢？

从封装性的角度把工具函数或常量添加到包而不是某一个对象更加合理，但是非常可惜 JVM 不支持，于是 Scala 的设计者提供了 package object 这样的语法来解决这个问题的局限性。
#### 第5题 

```scala
private[com] def giveRaise(rate: Double)
```
的含义是什么？有用吗？

这意味着 giveRaise函数除了在自己的包内可见以外，在 com 包中也可见，其它包不可见，这样可以拓展函数的可见范围，有用。
#### 第6题 
编写一段程序，将Java哈希映射中的所有元素拷贝到 Scala哈希映射。用映入语句重命名这两个类。代码如下：

```scala
package excercises.chapter7
import java.util.{HashMap => JavaHashMap}
import scala.collection.mutable.{HashMap => ScalaHashMap}

object JMapToSMap extends App {
  def mapTranster (javaMap: JavaHashMap[Any, Any]): ScalaHashMap[Any, Any] = {
    val result: ScalaHashMap[Any, Any] = new ScalaHashMap[Any, Any]
    for (k <- javaMap.keySet().toArray()){
      result += k -> javaMap.get(k)
    }
    result
  }

  val javaMap: JavaHashMap[Any, Any] = new JavaHashMap[Any, Any]
  var scalaMap: ScalaHashMap[Any, Any] = new ScalaHashMap[Any, Any]

  for (i <- 1 to 10)
    javaMap.put(i, "JavaMap" + i)
  scalaMap = mapTranster(javaMap)
  scalaMap foreach println
}
```
测试结果如下：

```scala
[info] Running excercises.chapter7.JMapToSMap 
(8,JavaMap8)
(2,JavaMap2)
(5,JavaMap5)
(4,JavaMap4)
(7,JavaMap7)
(10,JavaMap10)
(1,JavaMap1)
(9,JavaMap9)
(3,JavaMap3)
(6,JavaMap6)
[success] Total time: 9 s, completed Apr 26, 2019 7:26:01 PM
```
#### 第7题
在前一个练习中，将所有引入语句移动到尽可能小的作用域里。

可以将引入语句直接移动 object 内，代码修改如下：

```scala
package excercises.chapter7


object JMapToSMap extends App {
  import java.util.{HashMap => JavaHashMap}
  import scala.collection.mutable.{HashMap => ScalaHashMap}

  def mapTranster (javaMap: JavaHashMap[Any, Any]): ScalaHashMap[Any, Any] = {

    val result: ScalaHashMap[Any, Any] = new ScalaHashMap[Any, Any]
    for (k <- javaMap.keySet().toArray()){
      result += k -> javaMap.get(k)
    }
    result
  }

  val javaMap: JavaHashMap[Any, Any] = new JavaHashMap[Any, Any]
  var scalaMap: ScalaHashMap[Any, Any] = new ScalaHashMap[Any, Any]

  for (i <- 1 to 10)
    javaMap.put(i, "JavaMap" + i)
  scalaMap = mapTranster(javaMap)
  scalaMap foreach println
}
```
测试结果如下：

```scala
[info] Running excercises.chapter7.JMapToSMap 
(8,JavaMap8)
(2,JavaMap2)
(5,JavaMap5)
(4,JavaMap4)
(7,JavaMap7)
(10,JavaMap10)
(1,JavaMap1)
(9,JavaMap9)
(3,JavaMap3)
(6,JavaMap6)
[success] Total time: 5 s, completed Apr 26, 2019 7:32:09 PM
```

#### 第8题
以下代码的作用是什么？这是个好主意吗？


```scala
import java._
import javax._
```

这样会引入了java和javax的所有内容。虽然Scala会自动覆盖java的同名类，不会有冲突。但引入过多的包，一会让人很迷惑，二会导致scala编译速度变慢。
#### 第9题

编写一段程序，引人java.lang.System类，从user.name系统属性读取用户名，从Console对象读取一个密码，如果密码不是" secret"，则在标准错误流中打印一个消息；如果密码是" secret"，则在标准输出流中打印一个问候消息。不要使用任其他引入，也不要使用任何限定词（即带句点的那种）。

代码如下：

```scala
package excercises.chapter7
import java.lang.System._
import scala.io.StdIn

object Sys extends App {
  val pass=StdIn.readLine()
  if(pass == "secret"){
    val username = getProperty("user.name")
    out.printf("Greetings,%s!", username)
    println()
  }else{
    err.println("error")
  }
}```

运行结果如下：

```scala
[info] Running excercises.chapter7.Sys 
Greetings,datacruiser!
[success] Total time: 6 s, completed Apr 26, 2019 7:58:33 PM
```
#### 第10题
除了 StringBuilder，还有哪些 java.lang的成员是被 Scala 包覆盖的？
对比下 java.lang下的类和 Scala 当中的类，主要有Console,Math, 还有基本类型包装对象，Long,Double,Char,Short等。
