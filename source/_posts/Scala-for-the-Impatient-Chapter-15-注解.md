---
title: Scala for the Impatient Chapter 15 注解
date: 2019-05-26 16:29:33
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十五章练习。
---
#### 第1题 


编写四个JUnit测试用例，分别使用带或不带某个参数的@Test注解。用JUnit执行这些测试。

本人的编码环境是IDEA+SBT，所以需要在项目根目录项目的build.sbt文件当中配置下面代码，将`JUnit`导入。

```scala
// https://mvnrepository.com/artifact/junit/junit
libraryDependencies += "junit" % "junit" % "4.12" % "test"
```

```scala
package excercises.chapter15

import org.junit.Test
import org.junit.Assert.assertEquals

class ScalaTest {
  @Test
  def test1(){
    println("test1")
  }
  @Test(timeout = 1L)
  def test2(){
    println("test2")
  }
  @Test
  def test3(): Unit ={
    assertEquals("True", "True")
    println("test3 is passed")
  }
}
```

测试运行结果如下：


```scala
test1
test2
test3 is passed

Process finished with exit code 0
```



#### 第2题

创建一个类的示例，展示注解可以出现的所有位置。用@deprecated作为你的示例注解。





```scala
package excercises.chapter15

@deprecated(message = "Use * instead", since = "1.0")
class Multiply(val x: Int, val y : Int) {

  @deprecated(message = "Use * instead", since = "1.0")
  val result = x * y

  @deprecated(message = "Use * instead", since = "1.0")
  def multiply() = x * y
}

@deprecated(message = "User * instead", since = "1.0")
object Ex02 extends App {

  val M = new Multiply(4, 4)

  println(M.result)
  println(M.multiply)


}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter15.Ex02 
16
16
[success] Total time: 9 s, completed May 26, 2019 5:22:42 PM
```


#### 第3题

Scala类库中的哪些注解用到了元注解@param,@field,@getter,@setter,@beanGetter或@beanSetter?


@param一般会用来注解方法的参数，@field会用来注解类的成员变量，@getter和@setter会用来注解对于类当中的属性进行设置和获取的方法，@beanGetter和@beanSetter会用来注解符合Java Bean类规范且用来设置或者获得属性的方法。


#### 第4题

编写一个Scala方法sum,带有可变长度的整型参数，返回所有参数之和。从Java调用该方法。


Scala类代码如下：

```scala
package excercises.chapter15

import scala.annotation.varargs

class Chapter_15_04 {
  @varargs def sum(x: Int*): Int = x.sum
}
```


Java调用代码如下：

```java
package excercises.chapter15;

public class Ex04 {
    public static void main(String[] args) {
        Chapter_15_04 ex04 = new Chapter_15_04();
        System.out.println(ex04.sum(1, 2, 3, 4, 5, 6));
    }
}
```


#### 第5题

编写一个返回包含某文件所有行的字符串的方法。从Java调用该方法。


Scala类代码如下：

```scala
package excercises.chapter15

import java.io.IOException

class Chapter_15_05 {
  import scala.io.Source

  @throws(classOf[IOException]) def fileToString(file: String): String = {
    if(file == null) throw new IOException("File not found") else Source.fromFile(file).mkString
  }
}
```


Java调用代码如下：

```java
package excercises.chapter15;

import java.io.File;
import java.io.IOException;

public class Ex05 {
    public static void main(String[] args) throws IOException {
        Chapter_15_05 ex05 = new Chapter_15_05();
        File dir = new File("src/main/scala/excercises/chapter15");
        String path = dir.getAbsolutePath();
        System.out.println(ex05.fileToString(path + "/" + "Chapter_15_04.scala"));

    }
}
```



#### 第6题

编写一个Scala对象，该对象带有一个易失(volatile)的Boolean字段。让某一个线程睡眠一段时间，之后将该字段设为true，打印消息，然后退出。而另一个线程不停的检查该字段是否为true。如果是，它将打印一个消息并退出。如果不是，则它将短暂睡眠，然后重试。如果变量不是易失的，会发生什么？

```scala
package excercises.chapter15

object Ex06 extends App {
  @volatile var status = false

  new Thread{
    override def run(): Unit ={
      Thread.sleep(200)
      status = true
      println("## Status field to true")
    }
  }.start()

  new Thread{
    override def run(): Unit ={
      while (!status){
        println("Status field is false")
        Thread.sleep(50)
      }
      println("Status filed is true")
    }
  }.start()

}
```


运行结果如下：

```scala
[info] Running excercises.chapter15.Ex06 
Status field is false
Status field is false
Status field is false
Status field is false
## Status field to true
Status filed is true
[success] Total time: 23 s, completed May 27, 2019 9:55:17 PM
```

变为不易失的没啥区别。


#### 第7题

给出一个示例，展示如果方法可被重写，则尾递归优化为非法。


根据题意编码如下：

```scala
package excercises.chapter15

import scala.annotation.tailrec

class Sum {
  @tailrec
  final def sumA(s: Seq[Int], partial: BigInt): BigInt = if (s.isEmpty) partial else sumA(s.tail, s.head + partial)

  def sumB(s: Seq[Int], partial: BigInt): BigInt = if (s.isEmpty) partial else sumB(s.tail, s.head + partial)

}

object Ex07 extends App {
  val num = 1 to 100000000
  val sum = new Sum()

  try {
    val resultA = sum.sumA(num, 0)
    println(resultA)

    val resultB = sum.sumA(num, 0)
    println(resultB)
  } catch {
    case exc: StackOverflowError => println("Stack Overflow")

  }

}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter15.Ex07 
5000000050000000
5000000050000000
[success] Total time: 15 s, completed May 28, 2019 6:41:13 PM
```

在加入`@tailrec`以后，编译器要求方法需要用`final`或者`private`进行修饰，需要不可改写。

#### 第8题

将allDifferent方法添加到对象，编译并检查字节码。@specialized注解产生了哪些方法?



根据题意编码如下：

```scala
package excercises.chapter15

object Ex08 extends App {
  def allDifferent[@specialized T](x: T, y: T, z: T) = x != y && x != z && y != z
}
```

编译后因为`@specialized`注解而增加的方法如下：


```scala
/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/bin/javap -c Ex08$
Compiled from "Ex08.scala"
Warning: Binary file Ex08$ contains excercises.chapter15.Ex08$
public final class excercises.chapter15.Ex08$ implements scala.App {
  public static excercises.chapter15.Ex08$ MODULE$;

  public static {};


  public java.lang.String[] args();


  public void delayedInit(scala.Function0<scala.runtime.BoxedUnit>);


  public void main(java.lang.String[]);


  public long executionStart();


  public java.lang.String[] scala$App$$_args();


  public void scala$App$$_args_$eq(java.lang.String[]);


  public scala.collection.mutable.ListBuffer<scala.Function0<scala.runtime.BoxedUnit>> scala$App$$initCode();


  public void scala$App$_setter_$executionStart_$eq(long);
 

  public final void scala$App$_setter_$scala$App$$initCode_$eq(scala.collection.mutable.ListBuffer<scala.Function0<scala.runtime.BoxedUnit>>);


  public <T> boolean allDifferent(T, T, T);

// 以下为因为注解而增加的方法

  public boolean allDifferent$mZc$sp(boolean, boolean, boolean);

  public boolean allDifferent$mBc$sp(byte, byte, byte);

  public boolean allDifferent$mCc$sp(char, char, char);

  public boolean allDifferent$mDc$sp(double, double, double);

  public boolean allDifferent$mFc$sp(float, float, float);

  public boolean allDifferent$mIc$sp(int, int, int);

  public boolean allDifferent$mJc$sp(long, long, long);

  public boolean allDifferent$mSc$sp(short, short, short);

  public boolean allDifferent$mVc$sp(scala.runtime.BoxedUnit, scala.runtime.BoxedUnit, scala.runtime.BoxedUnit);

}
```

#### 第9题

Range.foreach方法被注解为@specialized(Unit)。为什么？通过以下命令检查字节码:
javap -classpath /path/to/scala/lib/scala-library.jar scala.collection.immutable.Range
并考虑Function1上的@specialized注解。点击Scaladoc中的Function1.scala链接进行查看。

查看下`Function1.scala`的源码：

```scala
...
@annotation.implicitNotFound(msg = "No implicit view available from ${T1} => ${R}.")
trait Function1[@specialized(scala.Int, scala.Long, scala.Float, scala.Double) -T1, @specialized(scala.Unit, scala.Boolean, scala.Int, scala.Float, scala.Long, scala.Double) +R] extends AnyRef { self =>
  /** Apply the body of this function to the argument.
   *  @return   the result of function application.
   */
  def apply(v1: T1): R
...

```
可以看到，`Function1.scala`适配的参数可以是`scala.Int,scala.Long,scala.Float,scala.Double`，返回值可以是`scala.Unit,scala.Boolean,scala.Int,scala.Float,scala.Long,scala.Double`。

然后再来看下`Range.foreach`的源码：


```scala
...
@inline final override def foreach[@specialized(Unit) U](f: Int => U) {
    // Implementation chosen on the basis of favorable microbenchmarks
    // Note--initialization catches step == 0 so we don't need to here
    if (!isEmpty) {
      var i = start
      while (true) {
        f(i)
        if (i == lastElement) return
        i += step
      }
    }
  }
...

```

可以看出该方法是没有返回值的，也就是Unit。而Function1的返回值可以是`scala.Unit,scala.Boolean,scala.Int,scala.Float,scala.Long,scala.Double`，因此限定`@specialized(Unit)`的目的是`Range.foreach`的参数能够与`Function1`方法进行匹配。



#### 第10题

添加assert(n >= 0)到factorial方法。在启用断言的情况下编译并校验factorial(-1)会抛异常。在禁用断言的情况下编译。会发生什么？用javap检查该断言调用。

启用断言的情况：	

```scala
package excercises.chapter15

import scala.annotation.elidable, elidable._

object Ex10 extends App {
  @elidable(ALL) def factorial(n: Int): Int = {
    assert(n >= 0)
    if (n <= 0) 1 else n * factorial(n-1)
  }

  println(factorial(-1))
}
```
编译异常如下：

```scala'
/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home/bin/java ...
Exception in thread "main" java.lang.AssertionError: assertion failed
	at scala.Predef$.assert(Predef.scala:208)
	at excercises.chapter15.Ex10$.factorial(Ex10.scala:7)
	at excercises.chapter15.Ex10$.delayedEndpoint$excercises$chapter15$Ex10$1(Ex10.scala:11)
	at excercises.chapter15.Ex10$delayedInit$body.apply(Ex10.scala:5)
	at scala.Function0.apply$mcV$sp(Function0.scala:39)
	at scala.Function0.apply$mcV$sp$(Function0.scala:39)
	at scala.runtime.AbstractFunction0.apply$mcV$sp(AbstractFunction0.scala:17)
	at scala.App.$anonfun$main$1$adapted(App.scala:80)
	at scala.collection.immutable.List.foreach(List.scala:392)
	at scala.App.main(App.scala:80)
	at scala.App.main$(App.scala:78)
	at excercises.chapter15.Ex10$.main(Ex10.scala:5)
	at excercises.chapter15.Ex10.main(Ex10.scala)
```
禁用断言以后编译通过，输出如下：

```scala

测试结果如下：

```scala
[info] Running excercises.chapter15.Ex10 
1
[success] Total time: 156 s, completed May 29, 2019 8:05:20 PM
```

用javap检查断言调用情况如下：

```scala
...
  public int factorial(int);
    Code:
       0: iload_1
       1: iconst_0
       2: if_icmpgt     9
       5: iconst_1
       6: goto          18
       9: iload_1
      10: aload_0
      11: iload_1
      12: iconst_1
      13: isub
      14: invokevirtual #64                 // Method factorial:(I)I
      17: imul
      18: ireturn
...   
```