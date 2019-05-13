---
title: Scala for the Impatient Chapter 11 练习
date: 2019-05-11 16:03:49
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十一章练习。
---
#### 第1题 


根据优先级规则，`3 + 4 -> 5`和`3 -> 4 + 5`是如何被求值的？

脚本运行结果如下：

```scala
scala> 3 + 4 -> 5
res0: (Int, Int) = (7,5)

scala> 3 -> 4 + 5
<console>:12: error: type mismatch;
 found   : Int(5)
 required: String
       3 -> 4 + 5
                ^
```

首先，`->`方法是所有Scala对象都有的方法，返回一个二元的元组(A,B)，举例如下：

```scala
scala> "test" -> 156
res2: (String, Int) = (test,156)
```

从优先级规则的角度，`->`和`+`这两个方法平级的，且都是左结合的，即从左到右进行求值运算。因此`3 + 4 -> 5`的求值结果就是`res0: (Int, Int) = (7,5)`，而`3 -> 4 + 5`的求值就会报错，因为二元的元组(A,B)后面再接`+`的时候会以`String`来对待，而`5`是`Int`类型，如果改成这样就不会报错了：

```scala
scala> (7,5) + "test"
res1: String = (7,5)test
```



#### 第2题

BigInt类有一个pow方法，但没有用操作符字符。Scala类库的设计者为什么没有选用`**`(像Fortran那样)或者`^`(像Pascal那样)作为乘方操作符呢？

Scala当中的操作符都是方法，除赋值操作符外，其优先级是根据首字母来确定的，优先级如下：

```scala
* / % 
+ - 
: 
= ! 
< > 
& 
ˆ 
| 
非操作符
最低优先级:赋值操作符
```

而一般乘方的操作符是优于乘法操作的，如果使用`**`作为乘方的话，那么其优先级则与`*`相同，而如果使用`^`的话，则优先级低于`*`操作，这样显然会造成各个操作符的优先级混乱。可能从优先级的角度考虑而没有采用操作符字符。



#### 第3题

实现Fraction类，支持+/操作。支持约分，例如将15/-6变为-5/2。除以最大公约数,像这样:

```scala
class Fraction(n:Int,d:Int){
private val num:Int = if(d==0) 1 else n sign(d)/gcd(n,d);
private val den:Int = if(d==0) 0 else d * sign(d)/gcd(n,d);
override def toString = num + “/“ + den
def sign(a:Int) = if(a > 0) 1 else if (a < 0) -1 else 0
def gcd(a:Int,b:Int):Int = if(b==0) abs(a) else gcd(b,a%b)
…
}

```

根据题意编码如下：

```scala
package excercises.chapter11

import scala.math.abs

class Fraction(n: Int,d: Int) {
  private val num: Int = if (d == 0) 1 else n * sign (d) / gcd(n, d)
  private val den: Int = if (d == 0) 0 else d * sign (d) / gcd(n, d)

  override def toString = num + " / " +den

  def sign(a: Int) = if (a > 0) 1 else if (a < 0) -1 else 0

  def gcd(a: Int, b: Int): Int = if (b == 0) abs(a) else gcd(b, a % b)

  def +(other:Fraction): Fraction ={
    new Fraction((this.num * other.den) + (other.num * this.den),this.den * other.den)
  }
  def -(other:Fraction): Fraction ={
    new Fraction((this.num * other.den) - (other.num * this.den),this.den * other.den)
  }
  def *(other:Fraction): Fraction ={
    new Fraction(this.num * other.num,this.den * other.den)
  }
  def /(other:Fraction): Fraction ={
    new Fraction(this.num * other.den,this.den * other.num)
  }
}

object ex03 extends App{
  val f = new Fraction(15,-9)
  val p = new Fraction(20,80)
  println(f)
  println(p)
  println(f + p)
  println(f - p)
  println(f * p)
  println(f / p)
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter11.ex03 
-5 / 3
1 / 4
-17 / 12
-23 / 12
-5 / 12
-20 / 3
[success] Total time: 4 s, completed May 11, 2019 5:21:51 PM
```


#### 第4题

实现一个Money类，加入美元和美分字段。提供`+`、`-`操作符以及比较操作符`==`和`<`。举例来说，Money(1, 75) + Money(0, 50) == Money(2, 25)应为`True`。你应该同时提供`*`和`/`操作符吗？为什么？

不需要提供乘除，从业务的角度，金额的乘除没有意义。

结合题意，编码如下：

```scala
package excercises.chapter11


class Money(val dollar: Int,val cent: Int){
  def + (other: Money): Money = {
    val a: Int = (this.cent + other.cent) / 100 //获取美分进位美元数
    val b: Int = (this.cent + other.cent) % 100 //获取进位后的美分余数
    new Money(this.dollar + other.dollar + a, b)
  }
  def - (other: Money): Money = {
    val d: Int = (this.toCent() - other.toCent()) / 100 
    val c: Int = (this.toCent() - other.toCent()) % 100
    new Money(d, c)
  }
  def == (other: Money): Boolean = this.toCent == other.toCent
  def < (other: Money): Boolean = this.toCent < other.toCent
  override def toString = "dollar = " + dollar + " cent = " + cent
  private def toCent(): Int = {
    this.dollar * 100 + this.cent
  }
}
object Money{
  def apply(dollar:Int, cent:Int): Money ={
    new Money(dollar,cent)
  }
  def main(args:Array[String]){
    val m1 = Money(1, 200)
    val m2 = Money(2, 1)
    println(m1 + m2)
    println(m1 - m2)
    println(m1 == m2)
    println(m1 < m2)
    println(Money(1,175) + Money(0, 25))
    println(Money(1,175) + Money(0, 50) == Money(3, 25))
  }
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter11.Money 
dollar = 5 cent = 1
dollar = 0 cent = 99
false
false
dollar = 3 cent = 0
true
[success] Total time: 2 s, completed May 11, 2019 5:59:28 PM
```


#### 第5题

提供操作符用于构造HTML表格。例如：

```html
Table() | "Java" | "Scala" || "Gosling" | "Odersky" || "JVM" | "JVM, .NET"
```

应产出

```html
<table><tr><td>Java</td><td>Scala</td></tr><tr><td>Gosling...

```


根据题意编码如下：

```scala
package excercises.chapter11

class Table{
  var s:String = ""
  def |(str:String):Table={
    val t = Table()
    t.s = this.s + "<td>" + str + "</td>"
    t
  }
  def ||(str:String):Table={
    val t = Table()
    t.s = this.s + "</tr><tr><td>" + str + "</td>"
    t
  }
  override def toString():String={
    "<table><tr>" + this.s + "</tr></table>"
  }
}
object Table{
  def apply():Table={
    new Table()
  }
  def main(args: Array[String]) {
    println(Table() | "Java" | "Scala" || "Gosling" | "Odersky" || "JVM" | "JVM,.NET")
  }
}
```

测试运行结果如下：

```scala
info] Running excercises.chapter11.Table 
<table><tr><td>Java</td><td>Scala</td></tr><tr><td>Gosling</td><td>Odersky</td></tr><tr><td>JVM</td><td>JVM,.NET</td></tr></table>
[success] Total time: 1 s, completed May 11, 2019 10:00:16 PM
```



#### 第6题

提供一个ASCIIArt类，其对象包含类似这样的图形:

```scala
 /\_/\
( ' ' )
(  -  )
 | | |
(__|__)

```


提供将两个ASCIIArt图形横向或纵向结合的操作符。选用适当优先级的操作符命名。纵向结合的实例：

```scala    
 /\_/\     -----
( ' ' )  / Hello \
(  -  ) <  Scala  |
 | | |   \ Coder /
(__|__)    -----

```

参考下面博文：


[快学Scala学习笔记及习题解答（10-11特质与操作符）](https://blog.csdn.net/u013980127/article/details/53331803)

编码如下：

```scala
package excercises.chapter11

import scala.collection.mutable.ArrayBuffer


class ASCIIArt(str: String) {
  val arr: ArrayBuffer[ArrayBuffer[String]] = new ArrayBuffer[ArrayBuffer[String]]()

  if (str != null && !str.trim.equals("")) {
    str.split("[\r\n]+").foreach(
      line => {
        val s = new ArrayBuffer[String]()
        s += line
        arr += s
      }
    )
  }

  def this() {
    this("")
  }

  /**
    * 横向结合
    * @param other
    * @return
    */
  def +(other: ASCIIArt): ASCIIArt = {
    val art = new ASCIIArt()
    // 获取最大行数
    val length = if (this.arr.length >= other.arr.length) this.arr.length else other.arr.length
    for (i <- 0 until length) {
      val s = new ArrayBuffer[String]()
      // 获取this中的行数据, 行数不足,返回空行
      val thisArr: ArrayBuffer[String] = if (i < this.arr.length) this.arr(i) else new ArrayBuffer[String]()
      // 获取other中的行数据, 行数不足,返回空行
      val otherArr: ArrayBuffer[String] = if (i < other.arr.length) other.arr(i) else new ArrayBuffer[String]()
      // 连接this
      thisArr.foreach(s += _)
      // 连接other
      otherArr.foreach(s += a_)
      art.arr += s
    }
    art
  }

  /**
    * 纵向结合
    * @param other
    * @return
    */
  def *(other: ASCIIArt): ASCIIArt = {
    val art = new ASCIIArt()
    this.arr.foreach(art.arr += _)
    other.arr.foreach(art.arr += _)
    art
  }

  override def toString = {
    var ss: String = ""
    arr.foreach(ss += _.mkString(" ") + "\n")
    ss
  }
}


object Ex06 extends App {
  val a = new ASCIIArt(""" /\_/\
                         |( ' ' )
                         |(  -  )
                         | | | |
                         |(__|__)
                         |""".stripMargin)

  val b = new ASCIIArt("""   -----
 / Hello \
<  Scala |
 \ Coder /
   -----""".stripMargin)



  println(a)
  println(b)
  println(a + b)
  println(a * b)

}
```

运行结果如下：

```scala
[info] Running excercises.chapter11.Ex06 
 /\_/\
( ' ' )
(  -  )
 | | |
(__|__)

   -----
 / Hello \
<  Scala |
 \ Coder /
   -----

 /\_/\    -----
( ' ' )  / Hello \
(  -  ) <  Scala |
 | | |  \ Coder /
(__|__)    -----

 /\_/\
( ' ' )
(  -  )
 | | |
(__|__)
   -----
 / Hello \
<  Scala |
 \ Coder /
   -----

[success] Total time: 3 s, completed May 11, 2019 10:48:35 PM

```


#### 第7题

实现一个BigSequence类，将64个bit的序列打包在一个Long值中。提供apply和update操作来获取和设置某个具体的bit。


根据题意编码如下：

```scala
package excercises.chapter11

class BitSequence(s: String) {
  var l = java.lang.Long.parseLong(s, 2)

  def apply(i: Int) = l & (1<<i)
  def update(i: Int, v: Boolean) {
    l = v match {
      case true => l | (1<<i)
      case false => l ^ (1<<i)
    }
  }
  override def toString = l.toString
}


object Ex07 extends App {
  val b = new BitSequence("010101010101010101010101010101010101010101010101010101010101110")

  b(0) = true

  assert( b.toString == "3074457345618258607" )

}

```

测试运行结果如下：

```scala
info] Running excercises.chapter11.Ex07 
[success] Total time: 3 s, completed May 11, 2019 11:27:20 PM
```

#### 第8题

提供一个Matrix类——你可以选择需要的是一个2x2的矩阵，任意大小的正方形矩阵，或是$m$x$n$的矩阵。支持`+`和`*`操作。`*`操作应同样适用于单值，例如 $mat * 2$。单个元素可以通过`mat(row, col)`得到。



根据题意编码如下：

```scala
package excercises.chapter11

class Matrix(val m: Array[Array[Double]]) {

  val rows = m.length
  val cols = m(0).length

  def apply(r: Int, c: Int) = m(r)(c)
  def update(r: Int, c: Int, v: Double) = {m(r)(c) = v}
  def dim = (rows, cols)

  private def compute(other: Matrix, f:(Double, Double) => Double): Array[Array[Double]] = {
    if(other.dim != this.dim) throw new Exception("Can only add matrix with same size") //判断矩阵的维度是否满足计算条件
    (for (i <- m.indices) yield m(i).zip(other.m(i)).map( v => f(v._1, v._2))).toArray
  }

  def +(other: Matrix) = new Matrix(compute(other, (a, b) => a + b))
  def *(other: Matrix) = new Matrix(compute(other, (a, b) => a * b))

  def *(s: Double) = {
    new Matrix(
      (for (i <- m.indices) yield m(i).map(_*s)).toArray
    )
  }

  override def toString: String = m.map(_.mkString(" ")).mkString("\n")
}

object Ex08 extends App {
  val m = new Matrix(Array(Array(1.0, 2.0, 3.0), Array(4.0, 5.0, 6.0)))
  val n = new Matrix(Array(Array(1.0, 2.0, 3.0), Array(4.0, 5.0, 6.0)))

  println(m + n)
  println(m * n)
  println(m * 1.5)
  println((m * 2 + n) * m)

}

```

运行结果如下：

```scala
[info] Done packaging.
[info] Running excercises.chapter11.Ex08 
2.0 4.0 6.0
8.0 10.0 12.0
1.0 4.0 9.0
16.0 25.0 36.0
1.5 3.0 4.5
6.0 7.5 9.0
3.0 12.0 27.0
48.0 75.0 108.0
[success] Total time: 5 s, completed May 12, 2019 5:46:32 PM
```

#### 第9题

为RichFile类定义unapply操作，提取文件路径，名称和扩展名。举例来说，文件/home/cay/readme.txt的路径为/home/cay,名称为readme,扩展名为txt。

编码如下：


```scala
package excercises.chapter11

object Ex09 extends App {

  object RichFile {

    def unapply(s: String) = {
      val r = """(.+?)/([^/]+)\.([^\.]+)$""".r
      val r(p, n, e) = s
      Some(p, n , e)
    }

  }

  val RichFile(path, name, extension) = "/home/cay/readme.txt"

  println(path)
  println(name)
  println(extension)
}
```

测试输出如下：

```scala
[info] Running excercises.chapter11.Ex09 
/home/cay
readme
txt
[success] Total time: 22 s, completed May 12, 2019 6:33:33 PM
```


#### 第10题

为RichFile类定义一个unapplySeq，提取所有路径段。举例来说，对于/home/cay/readme.txt，你应该产出三个路径段的序列:home,cay和readme.txt。	

根据题意，编码如下：

```scala
package excercises.chapter11

object Ex10 extends App {

  object RichFile {

    def unapplySeq(input: String): Option[Seq[String]] = {
      if (input.trim == "") None else Some(input.trim.split("/"))
    }
  }

  val RichFile(a @ _*) = "/home/cay/readme.txt"
  println(a)
}
```

测试结果如下：

```scala
[info] Running excercises.chapter11.Ex10 
WrappedArray(, home, cay, readme.txt)
[success] Total time: 7 s, completed May 13, 2019 2:29:13 PM
```

