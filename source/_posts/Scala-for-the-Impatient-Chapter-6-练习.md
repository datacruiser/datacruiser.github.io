---
title: Scala for the Impatient Chapter 6 练习
date: 2019-04-25 10:10:23
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第六章练习。
---
#### 第1题 
编写一个 Conversions 对象，加入 inchesToCentimeters、gallonsToLiters 和 milesToKilometers方法。
首先查询得到各个转化的系数，具体代码如下：

```scala
package excercises.chapter6

object Conversions {
  private val inchesToCms: Double = 30.48
  private val gallonsToLs: Double = 3.785
  private val milesToKms: Double = 1.61 

  def inchesToCentimeters(inches: Double): Double = {
    inches * inchesToCms
  }

  def gallonsToLiters(gallons: Double): Double = {
    gallons * gallonsToLs
  }

  def milesTokilometers(miles: Double): Double = {
    miles * milesToKms
  }

  def main(args: Array[String]): Unit = {
    val inch: Double = 10
    val gallon: Double = 20
    val mile: Double = 30
    println(inch + "英尺= " + inchesToCentimeters(inch))
    println(gallon + "加仑= " + gallonsToLiters(gallon))
    println(mile + "公里= " + milesTokilometers(mile))
  }
}
```
通过`sbt`编译后，运行结果如下：
```scala
[info] Running excercises.chapter6.Conversions 
10.0英尺= 304.8
20.0加仑= 75.7
30.0公里= 48.300000000000004
[success] Total time: 7 s, completed Apr 25, 2019 10:25:40 AM
```

#### 第2题 
前一个练习不是很面向对象。提供一个通用的超类 UnitConversion并定义扩展该超类的 InchesToCentimeters、GallonsToLiters和MilesToKilometers对象。

代码如下：

```scala
package excercises.chapter6

abstract class UnitConversion {
  def converse(from: Double): Double
}

object inchesToCentimeters extends UnitConversion{
  private val inchesToCms: Double = 30.48
  override def converse(inches: Double): Double = {
    inches * inchesToCms
  }
}

object gallonsToLiters extends UnitConversion{
  private val gallonsToLs: Double = 3.785
  override def converse(gallons: Double): Double = {
    gallons * gallonsToLs
  }
}
object milesToKilometers extends UnitConversion{
  private val milesToKms: Double = 1.61
  override def converse(miles: Double): Double = {
    miles * milesToKms
  }
}

object unitTest{
  def main(args: Array[String]): Unit = {
    val inch: Double = 10
    val gallon: Double = 20
    val mile: Double = 30
    println(inch + "英尺= " + inchesToCentimeters.converse(inch))
    println(gallon + "加仑= " + gallonsToLiters.converse(gallon))
    println(mile + "公里= " + milesToKilometers.converse(mile))
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter6.unitTest 
10.0英尺= 304.8
20.0加仑= 75.7
30.0公里= 48.300000000000004
[success] Total time: 7 s, completed Apr 25, 2019 4:39:56 PM
```
#### 第3题 
定义一个扩展自 java.awt.Point 的Origin对象。为什么说这实际上不是个好主意？（仔细看 Point 类的方法）
Origin 对象定义代码如下：

```scala
package excercises.chapter6
import java.awt.Point

object Origin extends Point with App{
  override def getLocation: Point=super.getLocation()
  Origin.move(2, 3)
  println(Origin.toString)
  Origin.setLocation(0, 0)
  println(Origin.toString)
}
```
程序运行结果如下：

```scala
[info] Running excercises.chapter6.Origin 
excercises.chapter6.Origin$[x=2,y=3]
excercises.chapter6.Origin$[x=0,y=0]
[success] Total time: 4 s, completed Apr 25, 2019 4:53:56 PM
```
根据题意，我们来看看 Point 类当中的方法：
![Point 类方法](https://i.imgur.com/f0kSLoZ.png)

首先，getLocation()返回的是Point类型，如果需要 Origin 类型，还需要有完整的 Origin 类。另外，Point 类当中还有 move、setLocation、translate等对对象进行修改的方法，显然这样的修改对于 Origin 类型是不合适的。
#### 第4题 
定义一个 Point 类和一个伴生对象，使得我们可以不用 new 而直接使用 Point(3, 4)来构造 Point 实例。
定义代码如下：
```scala
package excercises.chapter6

class Points(x: Double, y: Double) {
  override def toString: String = "x= " + x + ", y= " + y
}

object Points extends App{
  def apply(x: Double, y: Double): Points = new Points(x, y)
  val p: Points = Points(3.5, 5)
  println(p.toString)
}
```
测试结果如下：

```scala
[info] Running excercises.chapter6.Points 
x= 3.5, y= 5.0
[success] Total time: 3 s, completed Apr 25, 2019 5:26:20 PM
```
#### 第5题 
编写一个 Scala 应用程序，使用 App 特质，以反序打印命令行参数，用空格隔开。举例来说，scala Reverse Hello World 应该打印出 World Hello。
代码如下：

```scala
package excercises.chapter6

object Reverse extends App{
  var count = 0
  for (str <- args.reverse) {
    count += 1
    if (count < args.length)
      print(str + " ")
    else
      println(str)
  }
}
```
运行结果如下：

```scala
[info] Running excercises.chapter6.Reverse Hello World
World Hello
[success] Total time: 3 s, completed Apr 25, 2019 6:14:47 PM```

#### 第6题 
编写一个扑克牌4中花色的枚举，让其 toString 方法分布返回♣️、♦️、♥️、♠️。
代码如下：

```scala
package excercises.chapter6

object PokerFace extends Enumeration with App {
  val M = Value("♣️")
  val T = Value("♠️")
  val H = Value("♥️")
  val F = Value("♦️")

  println(PokerFace.M.toString())
  println(PokerFace.T.toString())
  println(PokerFace.H.toString())
  println(PokerFace.F.toString())
}
```
测试结果如下：

```scala
[info] Running excercises.chapter6.PokerFace 
♣️
♠️
♥️
♦️
[success] Total time: 8 s, completed Apr 25, 2019 9:14:31 PM
```
#### 第7题
实现一个函数，检查某张牌的花色是否为红色。
实现代码如下：

```scala
package excercises.chapter6

object PokerFace extends Enumeration with App {
  val M = Value("♣️")
  val T = Value("♠️")
  val H = Value("♥️")
  val F = Value("♦️")

//  println(PokerFace.M.toString())
//  println(PokerFace.T.toString())
//  println(PokerFace.H.toString())
//  println(PokerFace.F.toString())

  def checkColor(color: PokerFace.Value): Boolean = {
    color == PokerFace.H || color == PokerFace.F
  }

  println(checkColor(PokerFace.H))
  println(checkColor(PokerFace.T))
}
```
测试结果如下：

```scala
[info] Running excercises.chapter6.PokerFace 
true
false
[success] Total time: 2 s, completed Apr 25, 2019 9:22:23 PM
```

#### 第8题
编写一个枚举，描述 RGB 立方体的8个角。ID 使用颜色值（例如，红色是0xff0000）
描述：RGB如果分别用8

位表示，红是0xff0000，绿是0x00ff00，蓝是0x0000ff。以此类推 ，8个顶点分别是(0,0,0) (0,0,1) (0,1,0) (0,1,1) (1,0,0) (1,0,1) (1,1,0) (1,1,1)

程序代码如下:


```scala
object RGB extends Enumeration with App {  
  val RED = Value(0xff0000,"Red")  
  val BLACK = Value(0x000000,"Black")  
  val GREEN = Value(0x00ff00,"Green")  
  val CYAN = Value(0x00ffff,"Cyan")  
  val YELLOW = Value(0xffff00,"Yellow")  
  val WHITE = Value(0xffffff,"White")  
  val BLUE = Value(0x0000ff,"Blue")  
  val MAGENTA = Value(0xff00ff,"Magenta")  
}  
```