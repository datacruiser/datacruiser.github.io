---
title: Scala for the Impatient Chapter 13 练习
date: 2019-05-15 16:45:53
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十三章练习。
---
#### 第1题 


编写一个函数，给定字符串，产出一个包含所有字符的下标的映射。举例来说：indexes(“Mississippi”)应返回一个映射，让’M’对应集{0}，’i’对应集{1,4,7,10}，依此类推。使用字符到可变集的映射。另外，你如何保证集是经过排序的？

函数编码如下：

```scala
package excercises.chapter13

import scala.collection.{SortedSet, mutable}

object Ex01 extends App {
  def indexes(s: String): mutable.HashMap[Char,SortedSet[Int]] = {
    var indexMap = new mutable.HashMap[Char, SortedSet[Int]]()
    var i = 0
    s.toCharArray.foreach{
      c => indexMap.get(c) match {
        case Some(result) => indexMap(c) = result + i
        case None => indexMap += (c -> SortedSet{i})
      }
        i += 1
    }
    indexMap
  }


  println(indexes("Mississippi"))
  indexes("Mississippi").foreach(t => println(t._1 + ":" + t._2.mkString("{", ",", "}")))
}
```

测试运行结果如下：


```scala
[info] Running excercises.chapter13.Ex01 
Map(M -> TreeSet(0), s -> TreeSet(2, 3, 5, 6), p -> TreeSet(8, 9), i -> TreeSet(1, 4, 7, 10))
M:{0}
s:{2,3,5,6}
p:{8,9}
i:{1,4,7,10}
[success] Total time: 2 s, completed May 15, 2019 6:12:08 PM
```



#### 第2题

重复前一个练习，这次用字符到列表的不可变映射。



```scala
package excercises.chapter13

import scala.collection.mutable
import scala.collection.mutable.ListBuffer

object Ex02 extends App {
  def indexes(s: String): mutable.HashMap[Char,ListBuffer[Int]] = {
    var indexMap = new mutable.HashMap[Char, ListBuffer[Int]]()
    var i = 0
    s.toCharArray.foreach{
      c => indexMap.get(c) match {
        case Some(result) => result += i
        case None => indexMap += (c -> ListBuffer{i})
      }
        i += 1
    }
    indexMap
  }


  println(indexes("Mississippi"))
  indexes("Mississippi").foreach(t => println(t._1 + ":" + t._2.mkString("{", ",", "}")))
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter13.Ex02 
Map(M -> ListBuffer(0), s -> ListBuffer(2, 3, 5, 6), p -> ListBuffer(8, 9), i -> ListBuffer(1, 4, 7, 10))
M:{0}
s:{2,3,5,6}
p:{8,9}
i:{1,4,7,10}
[success] Total time: 10 s, completed May 15, 2019 6:10:55 PM
```


#### 第3题

编写一个函数，从一个整型链表中去除所有的零值。



```scala
package excercises.chapter13

object Ex03 extends App {
  def removeZero(list: List[Int]) ={
    list.filter( _!= 0)
  }

  val list = List(3, 1, 25, 0, 0, 21, 0, 189,0)
  println(removeZero(list))

}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter13.Ex03 
List(3, 1, 25, 21, 189)
[success] Total time: 2 s, completed May 15, 2019 6:34:50 PM
```



#### 第4题

编写一个函数，接受一个字符串的集合，以及一个从字符串到整数值的映射。返回整型的集合，其值为能和集合中某个字符串相对应的映射的值。举例来说，给定Array(“Tom”,”Fred”,”Harry”)和Map(“Tom”->3,”Dick”->4,”Harry”->5)，返回Array(3,5)。提示：用flatMap将get返回的Option值组合在一起。




```scala
package excercises.chapter13

object Ex04 extends App {
  def filterMap(strArr: Array[String], map: Map[String, Int]): Array[Int] ={
    strArr.flatMap(map.get(_))
  }

  val a = Array("Tom", "Fred", "Harry")
  val m = Map("Tom" -> 3, "Dick" -> 4, "Harry" -> 5)

  println(filterMap(a, m).mkString(", "))
}
```


```scala
[info] Running excercises.chapter13.Ex04 
3,5
[success] Total time: 4 s, completed May 15, 2019 9:03:15 PM
[IJ]sbt:scalaimpatient> 
```



#### 第5题

实现一个函数，作用与mkString相同，使用reduceLeft。




```scala
package excercises.chapter13

import scala.collection.mutable

trait MkToString {
  this: collection.mutable.Iterable[String] =>
  def mkToString(split: String = "") = if(this != Nil) this.reduceLeft(_ + split + _)
}


object Ex05 extends App {
  var test = new mutable.HashSet[String] with MkToString
  test += "Hello"
  test += "Scala"
  test += "Spark"
  println(test.mkToString(","))
}
```


测试运行结果如下：

```scala
[info] Running excercises.chapter13.Ex05 
Scala,Spark,Hello
[success] Total time: 12 s, completed May 16, 2019 10:18:26 AM
```



#### 第6题

给定整型列表lst,(lst :\ ListInt)( :: )得到什么?(ListInt /: lst)( :+ )又得到什么？如何修改它们中的一个，以对原列表进行反向排序？

```scala
 package excercises.chapter13

object Ex06 extends App {
  val lst = List(0, 1, 2, 3, 4, 5, 6, 7, 8)
  println((lst :\ List[Int]())(_ :: _)) //相当于用foldRight，创建一个包含所有新的元素的列表
  println((List[Int]() /: lst)(_ :+ _)) //相当于用foldLeft，创建一个包含所有新的元素的列表
  println((List[Int]() /: lst)((a, b) => b :: a))

}
```


运行结果如下：

```scala
[info] Running excercises.chapter13.Ex06 
List(0, 1, 2, 3, 4, 5, 6, 7, 8)
List(0, 1, 2, 3, 4, 5, 6, 7, 8)
List(8, 7, 6, 5, 4, 3, 2, 1, 0)
[success] Total time: 1 s, completed May 16, 2019 10:40:16 AM
```


#### 第7题

在13.11节中，表达式(prices zip quantities) map { p => p.1 * p._2}有些不够优雅。我们不能用(prices zip quantities) map { }，因为 _ 是一个带两个参数的函数，而我们需要的是一个带单个类型为元组的参数的函数，Function对象的tupled方法可以将带两个参数的函数改为以元俎为参数的函数。将tupled应用于乘法函数，以使我们可以用它来映射由对偶组成的列表。


根据题意编码如下：

```scala
package excercises.chapter13

object Ex07 extends App {
  val prices = List(5.0, 20.0, 9.95)
  val quantities = List(10, 2, 1)

  println((prices zip quantities) map{p => p._1 * p._2})
  println((prices zip quantities) map(p => p._1 * p._2))
  println((prices zip quantities).map(Function.tupled(_ * _)))
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter13.Ex07 
List(50.0, 40.0, 9.95)
List(50.0, 40.0, 9.95)
List(50.0, 40.0, 9.95)
[success] Total time: 1 s, completed May 16, 2019 11:38:12 AM
```

#### 第8题

编写一个函数。将Double数组转换成二维数组。传入列数作为参数。举例来说，Array(1,2,3,4,5,6)和三列，返回Array(Array(1,2,3),Array(4,5,6))。用grouped方法。



根据题意编码如下：

```scala
package excercises.chapter13

object Ex08 extends App {
  val arr: Array[Double] = Array(1, 2, 3, 4, 5, 6)
  def arrayGrouped(arr: Array[Double], row: Int) = {
    arr.grouped(row).toArray
  }

  arrayGrouped(arr, 3).foreach(a => println(a.mkString(", ")))
}
```

运行结果如下：

```scala
[info] Running excercises.chapter13.Ex08 
1.0,2.0,3.0
4.0,5.0,6.0
[success] Total time: 2 s, completed May 16, 2019 2:32:20 PM
```

#### 第9题

Harry Hacker写了一个从命令行接受一系列文件名的程序。对每个文件名，他都启动一个新的线程来读取文件内容并更新一个字母出现频率映射，声明为：

```scala
val frequencies = new scala.collection.multable.HashMap[Char,Int] with scala.collection.mutable.SynchronizedMap[Char,Int]
```
当读到字母c时，他调用

```scala
frequencies(c) = frequencies.getOrElse(c,0) + 1
```
为什么这样做得不到正确答案？如果他用如下方式实现呢：

```scala
import scala.collection.JavaConversions.asScalaConcurrentMap
val frequencies:scala.collection.mutable.ConcurrentMap[Char,Int] = new java.util.concurrent.ConcurrentHashMap[Char,Int]
```

这是由并发问题造成的，因为并发地修改或者遍历集合并不安全。如果改用`java.util.concurrent`包能够很好地解决这个问题。

#### 第10题

Harry Hacker把文件读取到字符串中，然后想对字符串的不同部分用并行集合来并发地更新字母出现频率映射。他用了如下代码：

```scala
val frequencies = new scala.collection.mutable.HashMap[Char,Int]
for(c <- str.par) frequencies(c) = frequencies.getOrElse(c,0) + 1
```

为什么说这个想法很糟糕？要真正地并行化这个计算，他应该怎么做呢？（提示：用aggregate。） 

	
首先，这个想法的糟糕在于并行修改共享变量，结果无法估计。

为了正确使用`aggregate`，先了解如下：

```scala
abstract def aggregate[B](z: ⇒ B)(seqop: (B, A) ⇒ B, combop: (B, B) ⇒ B): B
Aggregates the results of applying an operator to subsequent elements.

This is a more general form of fold and reduce. It is similar to foldLeft in that it doesn't require the result to be a supertype of the element type. In addition, it allows parallel collections to be processed in chunks, and then combines the intermediate results.

aggregate splits the collection or iterator into partitions and processes each partition by sequentially applying seqop, starting with z (like foldLeft). Those intermediate results are then combined by using combop (like fold). The implementation of this operation may operate on an arbitrary number of collection partitions (even 1), so combop may be invoked an arbitrary number of times (even 0).

As an example, consider summing up the integer values of a list of chars. The initial value for the sum is 0. First, seqop transforms each input character to an Int and adds it to the sum (of the partition). Then, combop just needs to sum up the intermediate results of the partitions:

List('a', 'b', 'c').aggregate(0)({ (sum, ch) => sum + ch.toInt }, { (p1, p2) => p1 + p2 })
B
the type of accumulated results
z
the initial value for the accumulated result of the partition - this will typically be the neutral element for the seqop operator (e.g. Nil for list concatenation or 0 for summation) and may be evaluated more than once
seqop
an operator used to accumulate results within a partition
combop
an associative operator used to combine results from different partitions
```

了解`aggregate`需要传入的参数以后，编码修改如下：

```scala
package excercises.chapter13


object Ex10 extends App {
  val str = "abcdefghijkwerwseofnwoenroejrwhtowehtokweht"

  val frequencies = str.par.aggregate(new collection.immutable.HashMap[Char, Int]())(
    {(m, c) =>  m + (c -> (m.getOrElse(c, 0) + 1))},
    {(m1, m2) => m1 ++ m2.map{ case (k,v) => k -> (v + m1.getOrElse(k, 0)) }}
  )

  println(frequencies)

}
```

测试结果如下：

```scala
[info] Running excercises.chapter13.Ex10 
Map(e -> 7, s -> 1, n -> 2, j -> 2, t -> 3, f -> 2, a -> 1, i -> 1, b -> 1, g -> 1, c -> 1, h -> 4, r -> 3, w -> 6, k -> 2, o -> 5, d -> 1)
[success] Total time: 2 s, completed May 17, 2019 7:28:45 PM
```