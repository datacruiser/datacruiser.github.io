---
title: Scala for the Impatient Chapter 17 类型参数
date: 2019-06-03 15:26:48
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十七章练习。
---
#### 第1题 


定义一个不可变类Pair[T,S], 带一个swap方法，返回组件交换过位置的新对偶。


```scala
package excercises.chapter17

class Pair[T, S](val first: T, val secend: S){
  def swap: Pair[S, T] = new Pair(secend, first)
}
```




#### 第2题

定义一个可变类Pair[T]，带一个swap方法，交换对偶中组件的位置。


```scala
package excercises.chapter17

class Pair[T](val first: T, val second: T) {
  def swap: Pair[T,T] = new Pair(second, first)
}
```


#### 第3题

给定类Pair[T, S] ，编写一个泛型方法swap，接受对偶作为参数并返回组件交换过位置的新对偶。

```scala
package excercises.chapter17

class Pair[T, S](val first: T, val second: S) {
  def swap[T, S](p: Pair[T, S]): Pair[S, T] = {
    new Pair(p.secend, p.first)
  }
}
```


#### 第4题

在17.3节中，如果我们想把Pair[Person]的第一个组件替换成Student，为什么不需要给replaceFirst方法定一个下界？

因为Student本身就是Person的子类，不必定义下界。


Scala代码如下：

```scala
package excercises.chapter17

object Ex04 extends App {
  class Person
  class Student extends Person

  class Pair[T](val first: T, val second: T) {
    def replaceFirst(r: T): Pair[T] = new Pair(r, second)

    override def toString: String = this.first.toString.substring(this.first.toString.indexOf("$") + 1, this.first.toString.indexOf("@")) + ", " +
      this.second.toString.substring(this.second.toString.indexOf("$") + 1, this.second.toString.indexOf("@"))
  }

  val persA = new Person
  val persB = new Person

  val pairA = new Pair(persA, persB)
  println(pairA.toString)

  val studA = new Student

  val pairB = pairA.replaceFirst(studA)
  println(pairB.toString)

}
```
测试输出如下：

```scala
[info] Running excercises.chapter17.Ex04 
Person, Person
Student, Person
[success] Total time: 2 s, completed Jun 3, 2019 5:50:12 PM
```


#### 第5题

为什么RichInt实现的是Comparable[Int]而不是Comparable[RichInt]?

因为“试图界定”包含了隐式的参数转化，如果T是Int的时候，将会自动调用与RichInt匹配的Comparable[RichInt]。实现代码如下：

```scala
package excercises.chapter17

object Ex05 extends App {
  class Pair[T <% Comparable[T]](val first: T, val second: T){
    override def toString: String = this.first.toString + "," + this.second.toString
  }

  val pairA = new Pair(4, 5)
  println(pairA)

}
```


测试结果如下：

```scala
info] Done packaging.
[info] Running excercises.chapter17.Ex05 
4,5
[success] Total time: 4 s, completed Jun 3, 2019 7:15:07 PM
```



#### 第6题

编写一个泛型方法middle，返回任何Iterable[T]的中间元素。举例来说，middle(“World”)应得到’r’。


Scala代码如下：

```scala
package excercises.chapter17

object Ex06 extends App {
  def middle[T](it: Iterable[T]): T = {
    val l = it.toList
    l(l.length / 2)
  }

  val arr = Array(1, 2 ,3 ,54 ,56)
  val s = "World"

  println(middle(arr))
  println(middle(s))
}
```

测试结果如下：

```scala
[info] Running excercises.chapter17.Ex06 
3
r
[success] Total time: 3 s, completed Jun 3, 2019 7:29:15 PM
```

#### 第7题

查看Iterable[+A]特质。哪些方法使用了类型参数A？为什么在这些方法中类型参数位于协变点？


比如head, last,  max, min, product, sum等。因为不能将逆变类型参数用于返回参数类型，这些方法都返回A类型，所以类型参数需要位于协变点。



#### 第8题

在17.10节中，replaceFirst方法带有一个类型界定。为什么你不能对可变的Pair[T]定义一个等效的方法？

```scala
def replaceFirst[R >: T](newFirst : R) { first = newFirst)  //错误
```

首先，newFirst无法赋值给first。因为first是T类型，而newFirst是R类型，R是T的超类，超类不能赋值给之类。



#### 第9题

在一个不可变类Pair[+T]中限制方法参数看上去可能有些奇怪。不过，先假定你可以在Pair[+T]定义
def replaceFirst(newFirst: T)
问题在于，该方法可能会被重写（以某种不可靠的方式）。构造出这样的一个示例。定义一个Pair[Double]的类型NastyDoublePair，重写replaceFirst方法，用newFirst的平方根来做新对偶。然后对实际类型为NastyDoublePair的Pair[Any]调用replaceFirst(“Hello”)。



```scala
package excercises.chapter17

class MyPair[+T](val first: T, val second: T) {
  def replaceFirst[T](newFirst: T) {}
}

class NastyDoublePair[Double](first: Double, second: Double) extends MyPair[Double](first, second) {
  /**
  Error:(10, 110) type mismatch;
  found   : Double(in class NastyDoublePair)
  required: scala.Double
  override def replaceFirst(newFirst: Double) = new NastyDoublePair(newFirst, math.sqrt(newFirst.asInstanceOf[Double]))
    */
  override def replaceFirst(newFirst: Double) = new NastyDoublePair(math.sqrt(newFirst), second)
}


object Ex09 extends App {

  val p: MyPair[Any] = new NastyDoublePair(4.0, 2.0)
  p.replaceFirst("Hello")
  println(p.first)
  println(p.second)

}

```


#### 第10题

给定可变类Pair[S,T]，使用类型约束定义一个swap方法，当类型参数相同时可以被调用。



```scala
package excercises.chapter17

object Ex10 extends App {

  class Pair[S, T](var first: S, var second: T) {
    def swap(implicit ev: S =:= T) : Pair[T, S] = {
      new Pair(second, first)
    }
  }

  val p = new Pair("hello", "world")
  println(p.first + ", " + p.second)
  val q = p.swap
  println(q.first + ", " + q.second)
  
}

```

测试输出如下：

```scala
[info] Running excercises.chapter17.Ex10 
hello, world
world, hello
[success] Total time: 3 s, completed Jun 4, 2019 8:05:16 PM
```

