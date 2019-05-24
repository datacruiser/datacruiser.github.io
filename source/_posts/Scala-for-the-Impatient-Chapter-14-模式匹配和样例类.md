---
title: Scala for the Impatient Chapter 14 模式匹配和样例类
date: 2019-05-21 15:04:13
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十四章练习。
---
#### 第1题 


JDK发行包有一个src.zip文件包含了JDK的大多数源代码。解压并搜索样例标签(用正则表达式case [^:]+:)。然后查找以//开头并包含[Ff]alls?thr的注释，捕获类似// Falls through或// just fall thru这样的注释。假定JDK的程序员们遵守Java编码习惯，在该写注释的地方写下了这些注释，有多少百分比的样例是会掉入到下一个分支的？

虽然题目有点看不懂，不过参考以下链接还是写了一段程序跑一跑：

[scala for the impatient ch14](https://github.com/BasileDuPlessis/scala-for-the-impatient/blob/master/src/main/scala/com/basile/scala/ch14/Ex01.scala)

```scala
package excercises.chpater14
import java.nio.file.attribute.BasicFileAttributes

object Ex01 extends App {

  import java.nio.file._
  import scala.io.Source
  import scala.language.implicitConversions

  implicit def makeFileVisitor(f: (Path) => Unit) =  new SimpleFileVisitor[Path] {
    override def visitFile(file: Path, attrs: BasicFileAttributes): FileVisitResult = {
      f(file)
      FileVisitResult.CONTINUE
    }
  }

  var (cf, cc) = (0, 0)
  val matchComment = (f: Path) => {
    val rf = """(?s)case [^:]+:[^:]+?/[/*] [Ff]alls? thr""".r
    val rc = """case [^:]+:""".r

    val str = Source.fromFile(f.toString, "ISO-8859-1").getLines.mkString

    cf += rf.findAllIn(str).length
    cc += rc.findAllIn(str).length
  }

  Files.walkFileTree(FileSystems.getDefault().getPath("src"), matchComment)
  println(cf)
  println(cc)

}
```

测试运行结果如下：


```scala
[info] Running excercises.chpater14.Ex01 
0
4
[success] Total time: 2 s, completed May 21, 2019 4:58:58 PM
```



#### 第2题

利用模式匹配，编写一个swap函数，接受一个整数的对偶，返回对偶的两个组成部件互换位置的新对偶。



```scala
package excercises.chpater14

object Ex02 extends App {
  def swap(p: (Int, Int)): (Int, Int) = p match {
    case (x, y) => (y, x)
  }

  println(swap(20, 5))

}
```

测试运行结果如下：

```scala
[info] Running excercises.chpater14.Ex02 
(5,20)
[success] Total time: 3 s, completed May 21, 2019 5:53:26 PM
```


#### 第3题

利用模式匹配，编写一个swap函数，交换数组中的前两个元素的位置，前提条件是数组长度至少为2。



```scala
package excercises.chpater14

object Ex03 extends App {
  def swap(a: Array[Any]) = a match {
    case Array(first, second, end @ _*) if a.length >=2 => Array(second, first) ++ end
  }

  println(swap(Array("1", 2, "3", 4)).deep.mkString(" "))

}

```

测试运行结果如下：

```scala
[info] Running excercises.chpater14.Ex03 
2 1 3 4
[success] Total time: 4 s, completed May 21, 2019 6:36:59 PM
```



#### 第4题

添加一个样例类Multiple，作为Item的子类。举例来说，Multiple(10,Article(“Blackwell Toster”,29.95))描述的是10个烤面包机。当然了，你应该可以在第二个参数的位置接受任何Item，无论是Bundle还是另一个Multiple。扩展price函数以应对新的样例。




```scala
package excercises.chpater14



object Ex04 extends App {

  abstract class Item
  case class Article(description: String, price: Double) extends Item
  case class Bundle(description: String, discount: Double, items: Item*) extends Item
  case class Multiple(quantity: Int, items: Item) extends Item


  def price(item: Item): Double = item match {
    case Article(_, p) => p
    case Bundle(_, disc, its @ _*) => its.map(price _).sum - disc
    case Multiple(n, it) => n * price(it)
  }

  val m = Multiple(100, Article("Dr No", 4.00))
  println("价格为：" + price(m))
}

```


```scala
[info] Running excercises.chpater14.Ex04 
价格为：400.0
[success] Total time: 5 s, completed May 21, 2019 7:57:57 PM
```



#### 第5题

我们可以用列表制作只在叶子节点存放值的树。举例来说，列表((3 8) 2 (5))描述的是如下这样一棵树:

```scala
 	  •
	/ | \
   •  2  •
  / \    |
 3   8   5
```

不过，有些列表元素是数字，而另一些是列表。在Scala中，你不能拥有异构的列表，因此你必须使用List[Any]。编写一个leafSum函数，计算所有叶子节点中的元素之和，用模式匹配来区分数字和列表。




```scala
package excercises.chpater14

object Ex05 extends App {
  val l = List(List(3,8),2,List(5))

  def leafSum(l: List[Any]): Int = l.map(_ match {
    case l: List[Any] => leafSum(l)
    case x: Int => x
    case _ => 0
  }).sum

  println("元素之和为：" + leafSum(l))

}
```


测试运行结果如下：

```scala
[info] Running excercises.chpater14.Ex05 
元素之和为：18
[success] Total time: 4 s, completed May 23, 2019 10:30:49 AM
```



#### 第6题

制作这样的树更好的做法是使用样例类。我们不妨从二叉树开始。

```scala
sealed abstract class BinaryTree
case class Leaf(value : Int) extends BinaryTree
case class Node(left : BinaryTree,right : BinaryTree) extends BinaryTree
```
编写一个函数计算所有叶子节点中的元素之和。

```scala
 package excercises.chpater14

object Ex06 extends App {
  sealed abstract class BinaryTree
  case class Leaf(value: Int) extends BinaryTree
  case class Node(left: BinaryTree, right: BinaryTree) extends BinaryTree

  val n = Node(Node(Leaf(3), Leaf(8)), Leaf(5))

  def leafSum(bt: BinaryTree): Int = bt match {
    case Node(left, right) => leafSum(left) + leafSum(right)
    case Leaf(value) => value
    case _ => 0
  }

  println("元素之和为：" + leafSum(n))
}
```


运行结果如下：

```scala
[info] Running excercises.chpater14.Ex06 
元素之和为：16
[success] Total time: 5 s, completed May 23, 2019 11:01:43 AM
```


#### 第7题

扩展前一个练习中的树，使得每个节点可以有任意多的后代，并重新实现leafSum函数。第五题中的树应该能够通过下述代码表示：
```scala
Node(Node(Leaf(3),Leaf(8)),Leaf(2),Node(Leaf(5)))
```

根据题意编码如下：

```scala
package excercises.chpater14

object Ex07 extends App {
  sealed abstract class BinaryTree
  case class Leaf(value: Int) extends BinaryTree
  case class Node(bt: BinaryTree*) extends BinaryTree

  val n = Node(Node(Leaf(3), Leaf(8)), Leaf(2), Node(Leaf(5)))

  def leafSum(bt: BinaryTree): Int = bt match {
    case Node(bts @ _*) => bts.map(leafSum).sum
    case Leaf(value) => value
    case _ => 0
  }

  println("元素之和为：" + leafSum(n))

}
```

测试运行结果如下：

```scala
[info] Running excercises.chpater14.Ex07 
元素之和为：18
[success] Total time: 8 s, completed May 23, 2019 11:12:35 AM
```

#### 第8题

扩展前一个练习中的树，使得每个非叶子节点除了后代之外，能够存放一个操作符。然后编写一个eval函数来计算它的值。举例来说：

```scala
 	  +
	/ | \
   *  2  -
  / \    |
 3   8   5

```
上面这棵树的值为(3 * 8) + 2 + (-5) = 21



根据题意编码如下：

```scala
package excercises.chpater14

object Ex08 extends App {
  sealed abstract class BinaryTree
  case class Leaf(value: Int) extends BinaryTree
  case class Node(op: Char, leafs: BinaryTree*) extends BinaryTree

  val n = Node('+', Node('*', Leaf(3), Leaf(8)), Leaf(2), Node('-', Leaf(5)))

  def eval(bt: BinaryTree): Int = bt match{
    case Node('+', bts @ _*) => bts.map(eval).sum
    case Node('-', bts @ _*) => bts.map(eval).foldLeft(0)(_ - _)
    case Node('*', bts @ _*) => bts.map(eval).product
    case Leaf(value) => value
    case _ => 0
  }

  println("这颗二叉树的计算值为：" + eval(n))
}
```

运行结果如下：

```scala
[info] Running excercises.chpater14.Ex08 
这颗二叉树的计算值为：21
[success] Total time: 6 s, completed May 23, 2019 11:29:30 AM
```

#### 第9题

编写一个函数，计算List[Option[Int]]中所有非None值之和。不得使用match语句。



```scala
package excercises.chpater14

object Ex09 extends App {

  def sum(list: List[Option[Int]]): Int = (for (Some(v) <- list) yield v).sum

  val list: List[Option[Int]] = List(Some(1), Some(2), Some(3), Some(4), None)

  println("列表的和为：" + sum(list))

}
```
运行结果如下：


```scala
[info] Running excercises.chpater14.Ex09 
列表的和为：10
[success] Total time: 10 s, completed May 24, 2019 3:48:53 PM
```



#### 第10题

编写一个函数，将两个类型为Double=>Option[Double]的函数组合在一起，产生另一个同样类型的函数。如果其中一个函数返回None，则组合函数也应返回None。例如：


```scala
def f(x : Double) = if ( x >= 0) Some(sqrt(x)) else None
def g(x : Double) = if ( x != 1) Some( 1 / ( x - 1)) else None
val h = compose(f,g)
```
h(2)将得到Some(1)，而h(1)和h(0)将得到None。

	

```scala
package excercises.chpater14

object Ex10 extends App {

  import scala.math._

  def f(x: Double) = if (x >= 0) Some(sqrt(x)) else None
  def g(x: Double) = if (x != 1) Some (1 / (x - 1)) else None

  def compose(f: Double => Option[Double], g: Double => Option[Double]): Double => Option[Double] = {
    (x: Double) => (f(x), g(x)) match {
      case (Some(_), r @ Some(_)) => r
      case _ => None
    }
  }

  val h = compose(f, g)

  for (x <- 0 until 3)
    println(h(x))
}
```


测试结果如下：

```scala
[info] Running excercises.chpater14.Ex10 
Some(-1.0)
None
Some(1.0)
[success] Total time: 3 s, completed May 24, 2019 4:12:25 PM
```