---
title: Scala for the Impatient Chapter 12 练习
date: 2019-05-13 14:41:54
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十二章练习。
---
#### 第1题 


编写函数values(fun:(Int)=>Int,low:Int,high:Int),该函数输出一个集合，对应给定区间内给定函数的输入和输出。比如，values(x=>x*x,-5,5)应该产出一个对偶的集合(-5,25),(-4,16),(-3,9),…,(5,25)

函数编码如下：

```scala
package excercises.chapter12

object Ex01 extends App {

  def values(fun: (Int) => Int, low: Int, high: Int): IndexedSeq[(Int, Int)] = {
    for(v <- low to high) yield (v, fun(v))
  }
  val result = values(x => x * x, -5, 5)
  println( result )
}
```

测试运行结果如下：


```scala
[info] Running excercises.chapter12.Ex01 
Vector((-5,25), (-4,16), (-3,9), (-2,4), (-1,1), (0,0), (1,1), (2,4), (3,9), (4,16), (5,25))
[success] Total time: 3 s, completed May 13, 2019 3:17:13 PM
```



#### 第2题

如何用reduceLeft得到数组中的最大元素?


```scala
scala> val a = Array(1, 25, 46, 75, 22, 45, 0, -12, 18)
a: Array[Int] = Array(1, 25, 46, 75, 22, 45, 0, -12, 18)

scala> a.reduceLeft((a, b) => if (a>b) a else b)
res0: Int = 75
```


#### 第3题

用to和reduceLeft实现阶乘函数,不得使用循环或递归。


```scala
scala> def fact(n: Int): Long = (1 to n).reduceLeft( _ * _)
fact: (n: Int)Long

scala> fact(10)
res1: Long = 3628800

```



#### 第4题

前一个实现需要处理一个特殊情况，即n<1的情况。展示如何用foldLeft来避免这个需要。（在Scaladoc中查找foldLeft的说明。它和reduceLeft很像，只不过所有需要结合在一起的这些值的首值在调用的时候给出。）


查看API，了解到`foldLeft()`函数如下：

```scala
abstract def foldLeft[B](z: B)(op: (B, A) ⇒ B): B
Applies a binary operator to a start value and all elements of this collection or iterator, going left to right.

Note: will not terminate for infinite-sized collections.

Note: might return different results for different runs, unless the underlying collection type is ordered or the operator is associative and commutative.
B
the result type of the binary operator.
z
the start value.
op
the binary operator.
returns
the result of inserting op between consecutive elements of this collection or iterator, going left to right with the start value z on the left:

op(...op(z, x_1), x_2, ..., x_n)
where x1, ..., xn are the elements of this collection or iterator. Returns z if this collection or iterator is empty.
```

这里面有一个参数`z: the start value`，利用这个参数编码测试如下：

```scala
scala> def fact(n: Int): Long = (1 to n).foldLeft(1)(_ * _)
fact: (n: Int)Long

scala> fact(-2)
res7: Long = 1

scala> fact(5)
res8: Long = 120
```



#### 第5题

编写函数largest(fun:(Int)=>Int,inputs:Seq[Int]),输出在给定输入序列中给定函数的最大值。举例来说，largest(x=>10x-xx,1 to 10)应该返回25.不得使用循环或递归。


```scala
package excercises.chapter12

object Ex05 extends App {
  def largest(fun: (Int) => Int, inputs: Seq[Int]) = {
    inputs.map(fun).reduceLeft((a, b) => if (a>b) a else b)
  }

  println(largest(x => 10 * x - x * x, 1 to 10))

}
```


测试运行结果如下：

```scala
[info] Running excercises.chapter12.Ex05 
25
[success] Total time: 1 s, completed May 13, 2019 5:47:57 PM
```



#### 第6题

修改前一个函数，返回最大的输出对应的输入。举例来说,largestAt(fun:(Int)=>Int,inputs:Seq[Int])应该返回5。不得使用循环或递归。

```scala
 package excercises.chapter12

object Ex06 extends App {
  def largestIndex(fun: (Int) => Int, inputs: Seq[Int]) = {
    inputs.map(a => (fun(a), a)).reduceLeft((a,b) => if (a._1 > b._1) a else b)._2
  }
  println(largestIndex(x => 10 * x - x * x, 1 to 10))
}
```




运行结果如下：

```scala
[info] Running excercises.chapter12.Ex06 
5
[success] Total time: 11 s, completed May 13, 2019 7:06:47 PM
```


#### 第7题

要得到一个序列的对偶很容易，比如:
val pairs = (1 to 10) zip (11 to 20)
假定你想要对这个序列做某中操作—比如，给对偶中的值求和，但是你不能直接使用:

pairs.map( + )
函数 + 接受两个Int作为参数，而不是(Int,Int)对偶。编写函数adjustToPair,该函数接受一个类型为(Int,Int)=>Int的函数作为参数，并返回一个等效的, 可以以对偶作为参数的函数。举例来说就是:adjustToPair( * )((6,7))应得到42。然后用这个函数通过map计算出各个对偶的元素之和。


根据题意编码如下：

```scala
package excercises.chapter12

object Ex07 extends App {
  def adjustToPair(f: (Int, Int) => Int) = (t: (Int, Int)) => f(t._1, t._2)

  val x = adjustToPair(_ * _)((6, 7))
  println(x)
  val pairs = (1 to 10) zip (11 to 20)
  println(pairs)
  val y = pairs.map(adjustToPair(_ + _))
  println(y)

}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter12.Ex07 
42
Vector((1,11), (2,12), (3,13), (4,14), (5,15), (6,16), (7,17), (8,18), (9,19), (10,20))
Vector(12, 14, 16, 18, 20, 22, 24, 26, 28, 30)
[success] Total time: 5 s, completed May 13, 2019 7:22:54 PM
```

#### 第8题

在12.8节中，你看到了用于两组字符串数组的corresponds方法。做出一个对该方法的调用，让它帮我们判断某个字符串数组里的所有元素的长度是否和某个给定的整数数组相对应。



根据题意编码如下：

```scala
package excercises.chapter12

object Ex08 extends App {
  val a = Array("hello", "world")
  val b = Array(5, 5)
  val c = Array(5, 10)

  println(a.corresponds(b)(_.length == _))
  println(a.corresponds(c)(_.length == _))
}

```

运行结果如下：

```scala
[info] Running excercises.chapter12.Ex08 
true
false
[success] Total time: 8 s, completed May 14, 2019 7:26:40 PM
```

#### 第9题

不使用柯里化实现corresponds。然后尝试从前一个练习的代码来调用。你遇到了什么问题？

编码如下：


```scala
package excercises.chapter12

object Ex09 extends App {

  val a = Array("Scala", "Java")
  val b = Array(5, 4)

  def corresponds(a: Array[String], b: Array[Int], f: (String, Int) => Boolean): Boolean = {
    (a zip b).map(t => f(t._1, t._2)).reduce(_ & _)
  }
  println(corresponds(a, b, (x, y) => x.length == y))
}
```

测试输出如下：

```scala
[info] Running excercises.chapter12.Ex09 
true
[success] Total time: 9 s, completed May 15, 2019 10:12:21 AM
```


#### 第10题

实现一个unless控制抽象，工作机制类似if,但条件是反过来的。第一个参数需要是换名调用的参数吗？你需要柯里化吗？

	
首先，需要换名调用和柯里化。根据题意，编码如下：

```scala
package excercises.chapter12

object Ex10 extends App {
  def unless(condition: => Boolean)(block : => Unit): Unit = {
    if(!condition) block
  }

  val pos = 15
  unless( pos == 10) {println("good")}

}
```

测试结果如下：

```scala
[info] Running excercises.chapter12.Ex10 
good
[success] Total time: 6 s, completed May 15, 2019 11:19:19 AM
```
