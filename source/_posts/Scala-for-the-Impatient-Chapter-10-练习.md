---
title: Scala for the Impatient Chapter 10 练习
date: 2019-05-08 16:38:44
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十章练习。
---
#### 第1题 


`java.awt.Rectangle`类有两个有用的方法`translate`和`grow`，但可惜的是像`java.awt.geom.Ellipse2D`这样的类中没有。在Scala当中，你可以解决掉这个问题。定一个一个`RectangleLike`特质，加入具体的`translate`和`grow`方法。提供任何你需要用来实现的抽象方法，以便你可以像如下代码这样混入该特质：

```scala
val egg = new java.awt.geom.Ellipse2D.Double(5, 10, 20, 30) with RectangleLike 
egg.translate(10, -10)
egg.grow(10, 20)
```

利用自身类型将特质指定为`java.awt.geom.Ellipse2D`类型，然后加入具体的`translate`和`grow`方法，在方法体当中调用重写`Ellipse2D`类型当中的`setFrame(double x, double y, double w, double h)`方法，实现`Rectangle`类当中`translate`和`grow`方法的功能。具体代码如下：


```scala
package excercises.chapter10

import java.awt.geom.Ellipse2D

object RectangleLike extends App {
  trait RectangleLike {
    this: java.awt.geom.Ellipse2D =>
    def translate(dx: Int, dy: Int): Unit ={
      setFrame(getX + dx, getY + dy, getWidth, getHeight)
    }

    def grow(dw: Int, dh: Int): Unit ={
      setFrame(getX, getY, getWidth + dw, getHeight + dh)
    }
  }

  val egg = new Ellipse2D.Double(5, 10, 20, 30) with RectangleLike
  egg.translate(10, 10)
  assert(egg.getX == 15)
  assert(egg.getY == 20)
  egg.grow(10, 20)
  assert(egg.getWidth == 30)
  assert(egg.getHeight == 50)

  println(egg.getX == 15)

}
```


运行结果如下：


```scala
[info] Running excercises.chapter10.RectangleLike 
true
[success] Total time: 2 s, completed May 8, 2019 7:14:38 PM
```

#### 第2题

通过把`scala.math.Ordered[Point]`混入`java.awt.Point`的方式，定义OrderedPoint类。按辞典编辑方式排列，也就是说，如果$x<x^{'}$或者$x=x^{'}$且$y<y^{'}$则$(x,y)<(x^{'},y^{'})$。

根据题意编写代码如下：


```scala
package excercises.chapter10
import java.awt.Point

class OrderedPoint(x: Int, y: Int) extends Point(x, y) with scala.math.Ordered[Point] {
  override def compare(that: Point): Int = {
    if (this.x <= that.x && this.y < that.y)
      -1
    else if (this.x == that.x && this.y == that.y)
      0
    else
      1
  }

}

object orderPoint extends App {
  val op1 = new OrderedPoint(10, 5)
  val op2 = new OrderedPoint(10 ,6)
  println(op1 < op2)

}```

测试结果如下：

```scala
[info] Running excercises.chapter10.orderPoint 
true
[success] Total time: 8 s, completed May 8, 2019 8:03:17 PM
```


#### 第3题

查看`BitSet`类，将它所有超类和特质绘制成一张图。忽略类型参数（[...]中的所有内容）。然后给出该特质的线性化规格说明。

查看`BitSet`类，结构如下：

```scala
abstract class BitSet extends AbstractSet[Int] with SortedSet[Int] with collection.BitSet with BitSetLike[BitSet] with Serializable
```
线性化规格说明如下：


```scala
lin(BitSet) = BitSet >> lin(Serializable) >> lin(BitSetLike) >> lin(collection.BitSet) >> lin(SortedSet) >> lin(AbstractSet)
```


#### 第4题

提供一个`CryptoLogger`类，将日志消息以凯撒密码加密。缺省情况下密钥为3，不过使用者也可以重写它。提供缺省密钥和-3作为密钥时的使用示例。

首先，根据题意需要理解凯撒密码加密是怎么一回事，密钥是如何起作用的。凯撒密码加密的具体内容可以参阅下面这个文档：

[凯撒密码加密](https://zh.wikipedia.org/wiki/%E5%87%B1%E6%92%92%E5%AF%86%E7%A2%BC)

然后结合题意，编码如下：

```scala
package excercises.chapter10

trait Logger{
  def log(str:String,key:Int = 3):String
}

class CryptoLogger extends Logger {

  def log(str: String, key:Int): String = {
    for ( i <- str) yield if (key >= 0) (97 + ((i - 97 + key) % 26)).toChar else (97 + ((i - 97 + 26 + key) % 26)).toChar
  }
}

object cryptoTest extends App{
  val plain = "Simon Scala";
  println("明文为：" + plain)
  println("加密后为：" + new CryptoLogger().log(plain))
  println("加密后为：" + new CryptoLogger().log(plain,-3))
} 
```

测试运行结果如下：

```scala
[info] Running excercises.chapter10.cryptoTest 
明文为：Simon Scala
加密后为：VlprqWVfdod
加密后为：jfjlkQjzxix
[success] Total time: 3 s, completed May 9, 2019 5:59:41 PM
```

需要特别指出的一点是，在代码的26行，新建的一个变量`numberArray`用来存储` Double`类型的数组，这样可以在后面方便地调用` sum`、`max`以及` min`等函数。	

#### 第5题

JavaBeans规范里有一种提法讲座属性变更监听器（property change listener），这是bean用来通知其属性变更的标准方式。PropertyChangeSupport类对于任何想要支持属性变更监听器的bean而言是个便捷的超类。但可惜已有其他超类的类——比如JComponet——必须重新实现相应的方法。将PropertyChangeSupport重新实现为一个特质，然后把它混入到java.awt.Point类中。

查了下Java API，对于`PropertyChangeSupport`类，根据`JavaBeans`规范，文档当中给出了下面一段代码示例：



```java
public class MyBean {
     private final PropertyChangeSupport pcs = new PropertyChangeSupport(this);

     public void addPropertyChangeListener(PropertyChangeListener listener) {
         this.pcs.addPropertyChangeListener(listener);
     }

     public void removePropertyChangeListener(PropertyChangeListener listener) {
         this.pcs.removePropertyChangeListener(listener);
     }

     private String value;

     public String getValue() {
         return this.value;
     }

     public void setValue(String newValue) {
         String oldValue = this.value;
         this.value = newValue;
         this.pcs.firePropertyChange("value", oldValue, newValue);
     }

     [...]
 }
```


从这段代码可以看出，任何服从`JavaBean`规范的类都首先需要实例化一个PropertyChangeSupport对象，然后实现`addPropertyChangeListener()`和`removePropertyChangeListener()`方法。

根据题意编码如下：

```scala
package excercises.chapter10

import java.awt.Point
import java.beans.{PropertyChangeEvent, PropertyChangeListener, PropertyChangeSupport}

trait ScalaPropertyChangeSupport {
  val pcs = new PropertyChangeSupport(this)

  def addPropertyChangeListener(propertyName: String, listener: PropertyChangeListener): Unit ={
    this.pcs.addPropertyChangeListener(propertyName, listener)
  }
  def removePropertyChangeListener(listener: PropertyChangeListener): Unit ={
    this.pcs.removePropertyChangeListener(listener)
  }
}

class Listener extends PropertyChangeListener{
  override def propertyChange(evt: PropertyChangeEvent): Unit = {
    println(evt.getSource.asInstanceOf[Point].x)
  }
}

trait ListenedPoint extends Point{
  this: ScalaPropertyChangeSupport =>
  override def setLocation(x: Int, y: Int): Unit = {
    pcs.firePropertyChange("setLocation", (getX, getY), (x, y))
    super.setLocation(x, y)
  }
}

object pcsTest extends App{
   println(P.getX, P.getY)
  P.addPropertyChangeListener("setLocaltion", L)
  P.setLocation(5, 10)
  println(P.getX, P.getY)
  
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter10.pcsTest 
(4.0,4.0)
(5.0,10.0)
[success] Total time: 5 s, completed May 10, 2019 6:26:52 PM
```



#### 第6题

在Java AWT类库中，我们有一个Container类，一个可以用于各种组件的Component子类。举例来说，Button是一个Component，但Panel是Container。这是一个运转中的组合模式。Swing有JComponent和JContainer，但如果你仔细看的话，你会发现一些奇怪的细节。尽管把其他组件添加到比如JButton中毫无意义，JComponent依然扩展自Container。Swing的设计者们理想情况下应该会更倾向于图10-4中的设计。但在Java中那是不可能的。请解释这是为什么？Scala中如何用特质来设计出这样的效果?

![Imgur](https://i.imgur.com/Q10Nz0G.png)

因为Java不支持多重继承，Java只能单继承，JContainer不能同时继承自Container和JComponent。Scala可以通过特质实例化并实现Component类中的方法来解决这个问题。


#### 第7题

市面上有不下数十种关于Scala特质的教程，用的都是些“在叫的狗”啦，“讲哲学的青蛙”啦之类的傻乎乎的示例。阅读和理解这些机巧的继承层级很乏味且对于理解问题没什么帮助，但自己设计一套继承层级就不同了，会很有启发。做一个你自己的关于特质的继承层级，要求体现出叠加在一起的特质、具体的和抽象的方法，以及具体的和抽象的字段。


根据题意编码如下：

```scala
package excercises.chapter10

trait Cycle {
  def cycle(): Unit ={
    println("Ride a bicycle")
  }
}

trait Run {
  def run(): Unit ={
    println("Run Run Run")
  }

  def runWithNothing()
}

trait Swim {
  def swim(): Unit ={
    println("Swim in a pool")
  }
}

class People(name: String){
  val height: Double = 0
}

class Athletes(name: String) extends People(name: String) with Cycle with Run with Swim {
  override def runWithNothing(): Unit = {
    println("Run with Nothing by an athletes")
  }
}
object TraitTest extends App {
  val athletes = new Athletes("Triathlon")
  athletes.runWithNothing()
  athletes.run()
  athletes.swim()
  athletes.cycle()
}

```

测试运行结果如下：

```scala
[info] Running excercises.chapter10.TraitTest 
Run with Nothing by an athletes
Run Run Run
Swim in a pool
Ride a bicycle
[success] Total time: 14 s, completed May 10, 2019 7:42:45 PM
```

#### 第8题

在java.io类库中，你可以通过BufferedInputStream修饰器来给输入流增加缓冲机制。用特质来重新实现缓冲。简单起见，重写read方法。

根据题意编码如下：

```scala
package excercises.chapter10

import java.io.{BufferedInputStream, File, FileInputStream}

trait TraitBuffer {
  this: FileInputStream =>
  val b = new BufferedInputStream(this)
  override def read(ab: Array[Byte]): Int = b.read(ab)
}

object traintBuffer extends App {
  val dir = new File("src/main/scala/excercises/chapter10")
  val path: String = dir.getAbsolutePath()
  val b = new FileInputStream(path + "/" + "test.txt") with TraitBuffer
  val ab = new Array[Byte](1024)

  b.read(ab)

  ab.foreach(a => print(a.toChar))
}
```

运行结果如下：

```scala
[info] Running excercises.chapter10.traintBuffer 
Scala
Java
Hadoop
Spark
[success] Total time: 2 s, completed May 10, 2019 7:59:44 PM
```

#### 第9题

使用本章的日志生成器特质,给前一个练习中的方案增加日志功能，要求体现缓冲的效果。

借助9.7节提供的遍历目录的代码段，编码如下：


```scala
package excercises.chapter10

import java.io.{BufferedInputStream, File, FileInputStream}

trait TLogger {
  def log(msg: String): Unit ={

  }
}

trait LogTraitBuffer extends TLogger {
  this: FileInputStream =>
  val b = new BufferedInputStream(this)

  override def read(): Int = {
    log("可用性差异：" + (b.available() - this.available()))
    b.read()
  }

  override def log(msg: String): Unit = {
    println(msg)
  }
}

object logTraitBuffer extends App {
  val dir = new File("src/main/scala/excercises/chapter10")
  val path: String = dir.getAbsolutePath()
  val b = new FileInputStream(path + "/" + "test.txt") with LogTraitBuffer
  Iterator.continually(b.read()).takeWhile(_ != -1).map(_.toChar).mkString
}
```


#### 第10题

实现一个IterableInputStream类，扩展java.io.InputStream并混入Iterable[Byte]特质。	

根据题意，编码如下：

```scala
package excercises.chapter10

import java.io.{File, FileInputStream, InputStream}

class IterableInputStream(is: InputStream) extends java.io.InputStream with Iterable[Byte] {
  def iterator = new Iterator[Byte] {
    def hasNext() = is.available > 0
    def next() = is.read.toByte
  }
  def read = is.read()

}

object iterableInputSteam extends App {
  val dir = new File("src/main/scala/excercises/chapter10")
  val path: String = dir.getAbsolutePath()
  val b = new IterableInputStream(new FileInputStream(path + "/" + "test.txt")).iterator
  val r = b.map(_.toChar).mkString
  println(r)
}
```

测试结果如下：

```scala
[info] Running excercises.chapter10.iterableInputSteam 
Scala
Java
Hadoop
Spark
[success] Total time: 7 s, completed May 11, 2019 3:17:23 PM
```
	