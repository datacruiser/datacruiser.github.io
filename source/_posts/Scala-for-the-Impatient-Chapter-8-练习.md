---
title: Scala for the Impatient Chapter 8 练习
date: 2019-04-27 11:22:32
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第八章练习。
---
#### 第1题 
扩展如下的 BankAccount 类，新类 ChekingAccount 对每次存款和取款都收取1美元的手续费。

```scala
class BankAccount(InitialBalance: Double){
	private var balance = initialBalance
	def deposit(amount: Double) = {balance += amount; balance}
	def withdraw(amount: Double) = {balance += amount; balance}
	def currentBalance = balance
	}
```

编码如下：


```scala
package excercises.chapter8

class CheckingAccount(InitialBalance: Double) extends BankAccount(InitialBalance: Double) {
  override def deposit(amount: Double): Double = {
    super.deposit(amount - 1)
  }
  override def withdraw(amount: Double): Double = {
    super.withdraw(amount + 1)
  }
  override def currentBalance: Double = super.currentBalance
}

object CheckingAccount extends App {
  val checkingAccount = new CheckingAccount(2000)
  val deposit = 1000
  val withdraw = 800
  checkingAccount.deposit(deposit)
  println("存入 :" + deposit + "余额: " + checkingAccount.currentBalance)
  checkingAccount.withdraw(withdraw)
  println("取出 :" + withdraw + "余额: " + checkingAccount.currentBalance)
}
``` 

运行结果如下：


```scala
[info] Running excercises.chapter8.CheckingAccount 
存入 :1000余额: 2999.0
取出 :800余额: 3800.0
[success] Total time: 3 s, completed Apr 27, 2019 3:15:56 PM
```



#### 第2题

扩展前一个练习的 BankAccount类，新类 SavinigsAccount ，每个月有利息产生（earnMonthlyInterest 方法被调用），并且有每月三次免手续费的存款或取款。在 earnMonthlyInterest方法中重置交易次数。

新类代码如下：


```scala
package excercises.chapter8

class SavingsAccount(InitialBalance: Double) extends BankAccount(InitialBalance){
  private var freeTradeCount = 3
  private val interstRate = 0.01
  def currentCount = freeTradeCount //用于后续测试用例时调用当前的免费次数

  override def deposit(amount: Double): Double = {
    if(freeTradeCount > 0){
      freeTradeCount -= 1
      super.deposit(amount)
    }
    else
      super.deposit(amount - 1)
  }
  override def withdraw(amount: Double): Double = {
    if(freeTradeCount > 0){
      freeTradeCount -= 1
      super.withdraw(amount)
    }
    else
      super.withdraw(amount + 1)
  }

  def earnMonthlyInterest(): Double = {
    freeTradeCount = 3
    super.deposit(super.deposit(0) * interstRate)
    super.deposit(0) * interstRate
  }
}

object saveingsAccount extends App{
  private val depBal: Double = 1000
  private val witBal: Double  = 200
  private var interest: Double = 0.0
  private val saveingsaccount: SavingsAccount = new SavingsAccount(500)

  for(i <- 1 to 32){
    if(i >= 1 && i <= 5){
      saveingsaccount.deposit(depBal)
      println(i + "号存入: " + depBal + "，余额: " + saveingsaccount.currentBalance + "，剩余免费次数: " + saveingsaccount.currentCount)
    }
    else if(i >= 29 && i <= 31){
      if(i == 30){
        interest = saveingsaccount.earnMonthlyInterest()
        saveingsaccount.deposit(interest) //将产生的利息存回余额
        saveingsaccount.currentCount 
      }
      saveingsaccount.withdraw(witBal)
      println(i + "号取出: " + witBal + "，余额: " + saveingsaccount.currentBalance + "，剩余免费次数: " + saveingsaccount.currentCount)

    }
  }
  println("一个月产生的利息：" + interest + "，剩余免费次数：" + saveingsaccount.currentCount)
}

```

测试结果如下：

```scala
[info] Running excercises.chapter8.saveingsAccount 
1号存入: 1000.0，余额: 1500.0，剩余免费次数: 2
2号存入: 1000.0，余额: 2500.0，剩余免费次数: 1
3号存入: 1000.0，余额: 3500.0，剩余免费次数: 0
4号存入: 1000.0，余额: 4499.0，剩余免费次数: 0
5号存入: 1000.0，余额: 5498.0，剩余免费次数: 0
29号取出: 200.0，余额: 5699.0，剩余免费次数: 0
30号取出: 200.0，余额: 6013.5499，剩余免费次数: 1
31号取出: 200.0，余额: 6213.5499，剩余免费次数: 0
一个月产生的利息：57.5599，剩余免费次数：0
```

#### 第3题

翻开你喜欢的 Java 或 C++教科书，一定会找到用来讲解继承层级的示例，可能是员工、宠物、图形或类似的东西。用 Scala 来实现这个示例。

这里找到了Daniel Liang的《Introduction to Java Comprehension Version》中的 Listing 11.1 和11.2，代码如下：



- Listing 11.1 SimpleGeometricObject.java


```java
package excercises.chapter8;

public class SimpleGeometricObject {

    private String color = "white";
    private boolean filled;
    private java.util.Date dateCreated;

    /** Construct a default geometric object */
    public SimpleGeometricObject() {

        dateCreated = new java.util.Date();

    }
    /** Construct a geometric object with the specified color * and filled value */
    public SimpleGeometricObject(String color, boolean filled) {

        dateCreated = new java.util.Date(); this.color = color; this.filled = filled;

    }

    /** Return color */
    public String getColor() { return color; }

    /** Set a new color */
    public void setColor(String color) { this.color = color; }

    /** Return filled. Since filled is boolean, its getter method is named isFilled */
    public boolean isFilled() {

        return filled;
    }

    /** Set a new filled */
    public void setFilled(boolean filled) { this.filled = filled; }

    /** Get dateCreated */
    public java.util.Date getDateCreated() { return dateCreated; }

    /** Return a string representation of this object */
    public String toString() {

        return "created on " + dateCreated + "\ncolor: " + color + " and filled: " + filled;
    }

}
```

- Listing 11.2 CircleFromSimpleGeometricObject.java

```java
package excercises.chapter8;

public class CircleFromSimpleGeometricObject extends SimpleGeometricObject {
        private double radius;

        public CircleFromSimpleGeometricObject() { }

        public CircleFromSimpleGeometricObject(double radius) { this.radius = radius; }

        public CircleFromSimpleGeometricObject(double radius, String color, boolean filled) {
            this.radius = radius;
            setColor(color);
            setFilled(filled);
        }

        /** Return radius */
        public double getRadius() { return radius; }

        /** Set a new radius */
        public void setRadius(double radius) { this.radius = radius; }

        /** Return area */
        public double getArea() { return radius * radius * Math.PI; }

        /** Return diameter */
        public double getDiameter() { return 2 * radius; }

        /** Return perimeter */
        public double getPerimeter() { return 2 * radius * Math.PI; }

        /** Print the circle info */
        public void printCircle() {

            System.out.println("The circle is created " + getDateCreated() + " and the radius is " + radius);
        }

}
```

如果用 scala，则实现如下：

```scala
package excercises.chapter8

class Geometric(color: String, filled: Boolean, dateCreated: java.util.Date) {
  override def toString: String = "created on " + dateCreated + "\ncolor: " + color + " and filled: " + filled
}

class Circle(color: String, filled: Boolean, dateCreated: java.util.Date, radius: Double) extends Geometric(color, filled, dateCreated) {
  def printCircle(): Unit = {
    println("The circle is created " + dateCreated + " and the radius is " + radius)
  }
}
```

#### 第4题

定义一个抽象类 Item，加入方法 price 和 description。SimpleItem 是一个在构造器中给出价格和描述的物件。利用 val 可以重写 def 这个事实。Bundle 是一个可以包含其他物件的物件。其价格是打包中所有物件的价格之和。同时提供一个将物件添加到打包当中的机制。以及一个合适的 description 方法。

根据题意，编码如下：

```scala
package excercises.chapter8

abstract class Item {
  def price: Double
  def description: String
}

class SimpleItem(override val price: Double, override val description: String) extends Item{
  //利用 override 来重写原类中 def 的方法
}

class Bundle() extends Item{
  val itemList = scala.collection.mutable.ArrayBuffer[Item]() //如果此处用 private 修饰，则后面 ItemTest 当中会访问不到

  def addItem(item: Item): Unit ={
    itemList += item
  }

  override def price: Double = {
    var itemPrice: Double = 0.0
    itemList.foreach(i => itemPrice += itemPrice + i.price)
    itemPrice
  }

  override def description: String = {
    var itemDescription = ""
    itemList.foreach(i => itemDescription = itemDescription + "," + i.description)
    itemDescription
  }
}

object ItemTest extends App{
  val bundle = new Bundle
  val priceArr = Array(4299, 6888, 8999, 20888)
  val descriptionArr = Array("Ipad", "Iphone XS", "MacBook", "MacBook Pro")

  for (i <- 0 until 4){
    bundle.addItem(new SimpleItem(priceArr(i), descriptionArr(i)))
  }

  println("购物车信息如下：")
  bundle.itemList.foreach( item => println("描述：" + item.description + ", " + "价格：" + item.price))
  println("所购物品清单如下：" + bundle.description)
  println("本次消费合计：" + bundle.price + " ¥")
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter8.ItemTest 
购物车信息如下：
描述：Ipad, 价格：4299.0
描述：Iphone XS, 价格：6888.0
描述：MacBook, 价格：8999.0
描述：MacBook Pro, 价格：20888.0
所购物品清单如下：,Ipad,Iphone XS,MacBook,MacBook Pro
本次消费合计：100830.0¥
[success] Total time: 7 s, completed Apr 28, 2019 3:11:14 PM
```

#### 第5题

设计一个 Point 类，其 x 和 y 坐标可以通过构造器提供。提供一个子类 LabeledPoint，其构造器接受一个标签值和 x、y 坐标，比如：

```scala
new LabeledPoint("Black Thursday", 1929, 230.07)
```

根据题意编码如下：

```scala
package excercises.chapter8

class Point(val x: Double, val y: Double) {
  override def toString: String = "x坐标为：" + x + ", " + "y坐标为：" + y //对 toString 方法进行重写
}

class LabeledPoint(val label: String, override val x: Double, override val y: Double) extends Point(x, y){
  override def toString: String = "label = " + label + ", " + super.toString
}

object PointTest extends App{
  val point = new Point(3, 4)
  val labeledPoint = new LabeledPoint("*", 3, 4)
  println(point)
  println(labeledPoint)
}
```

测试结果如下：

```scala
[info] Running excercises.chapter8.PointTest 
x坐标为：3.0, y坐标为：4.0
label = *, x坐标为：3.0, y坐标为：4.0
[success] Total time: 3 s, completed Apr 28, 2019 3:33:00 PM
```

#### 第6题

定义一个抽象类 Shape、一个抽象方法 centerPoint，以及该抽象类的子类 Rectangle 和 Circle。为子类提供合适的构造器，并重写 centerPoint 方法。

根据题意编码如下：

```scala
package excercises.chapter8

abstract class Shape {
  def centerPoint: Point
}

class Rectangle(val p1: Point, val p2: Point, val p3: Point, val p4: Point) extends Shape{ //给定四个点的坐标来构造长方形
  override def centerPoint: Point = {
    var x: Double = 0.0
    var y: Double = 0.0
    x = (p1.x + p2.x + p3.x +p4.x) / 2
    y = (p1.y + p2.y + p3.y +p4.y) / 2
    val centerpoint = new Point(x, y)
    centerpoint
  }
}

class GeoCircle(val cp: Point, val radius: Double) extends Shape{
  override def centerPoint: Point = {
    cp
  }
}

object ShapeTest extends App{
  val p1 = new Point(1, 5)
  val p3 = new Point(1, 15)
  val p2 = new Point(10, 5)
  val p4 = new Point(10, 15)

  val rect = new Rectangle(p1, p2, p3, p4)
  println("rect的中心点坐标是：" + rect.centerPoint.toString)

  val circle = new GeoCircle(p4, 15)
  println("circle的中心点坐标是：" + p4.toString)
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter8.ShapeTest 
rect的中心点坐标是：x坐标为：11.0, y坐标为：20.0
circle的中心点坐标是：x坐标为：10.0, y坐标为：15.0
[success] Total time: 20 s, completed Apr 28, 2019 4:14:18 PM
```

#### 第7题

提供一个 Square 类，扩展自 java.awt.Rectangle并且有三个构造器：一个以给定的端点和宽带构造正方形，一个以(0, 0)为端点和给定的宽度构造正方形，一个以(0, 0)为端点、0为宽度构造正方形。

根据题意编码如下：

```scala
package excercises.chapter8
//为了避免与前面作业当中同名类的干扰，重命名
import java.awt.{Point => JavaPoint}
import java.awt.{Rectangle => JavaRectangle}

class Square extends JavaRectangle{
  //以下变量为 java.awt.Rectange类当中已经定义的变量，且类型为 Int
  this.height = 0
  this.width = 0
  this.x = 0
  this.y = 0

  def this(p: JavaPoint, w: Int){
    this()
    this.height = w
    this.width = w
    this.x = p.x
    this.y = p.y
  }

  def this(width: Int){
    this(new JavaPoint(0, 0), width)
  }

}

object SqureTest extends App{
  val rect1 = new Square()
  val rect2 = new Square(15)
  val rect3 = new Square(new JavaPoint(2, 3), 25)
  println(rect1)
  println(rect2)
  println(rect3)
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter8.SqureTest 
excercises.chapter8.Square[x=0,y=0,width=0,height=0]
excercises.chapter8.Square[x=0,y=0,width=15,height=15]
excercises.chapter8.Square[x=2,y=3,width=25,height=25]
[success] Total time: 4 s, completed Apr 28, 2019 5:26:57 PM

```

#### 第8题

编译8.6节中的 Person 和 SecretAgent 类并使用 javap 分析类文件。总共多少 name 的 getter 方法？他们分别取什么值？（提示：可以用-c 和-private 选项）

原程序代码如下：

```scala
package excercises.chapter8

class Person ( val name: String ) {

  override def toString=getClass.getName + "name=" + name + "]"

}

class SecretAgent (codename: String) extends Person (codename) {

  override val name = "secret" // 不想暴露真名…
  override val toString = "secret" // …或类名

}
```

将代码编译以后用 javap -p 查看结果如下：

```scala
⇒  javap -p excercises.chapter8.Person 
Compiled from "Person.scala"
public class excercises.chapter8.Person {
  private final java.lang.String name;
  public java.lang.String name();
  public java.lang.String toString();
  public excercises.chapter8.Person(java.lang.String);
}

⇒  javap -p excercises.chapter8.SecretAgent 
Compiled from "Person.scala"
public class excercises.chapter8.SecretAgent extends excercises.chapter8.Person {
  private final java.lang.String name;
  private final java.lang.String toString;
  public java.lang.String name();
  public java.lang.String toString();
  public excercises.chapter8.SecretAgent(java.lang.String);
}

```

很明显，两个类中都有 name()方法，但是子类的方法重载了父类的方法。

#### 第9题

在8.10节的 Creature 类中，将 val range 替换成一个 def。如果你在 Ant 子类中也用 def 的话会有什么效果？如果在子类中使用 val 又会有什么效果？为什么？

def覆写def，子类的env可以正确初始化。而用val覆写def，env会被初始化成0长度。这个跟val覆写val的道理是一样的。父类和子类同时存在私有的同名变量range和相同的range的getter，但是父类构造函数先被调用，却在其中调用子类的getter。因为父类 的getter已被子类覆写。子类的range因为此时还没初始化，所以返回了0，而且因为是 val变量，一旦被初始化以后，子类的 range 无法继续修改。父类构造函数，错误地使用0来初始化了env。这种行为本身就是个坑，但是也提供了非常大的灵活性。面向对象的Template设计模式就依赖这种行为实现的，所以还是多多善用为妙。

回答参考以下链接：

[Scala学习(八)练习](https://www.cnblogs.com/sunddenly/p/4441491.html)

#### 第10题

文件scala/collection/immutable/Stack.scala包含如下定义：

```scala
class Stack[A] protected (protected val elems: List[A])
```

请解释 protected 关键字的含义。（提示：回顾我们在第5章关于私有构造器的讨论）

前一个 protected 是指主构造器的权限， 即默认情况下，是不能以传入 elems 的方式创建 Stack 对象的，只能通过辅助构造器来构造 Stack 对象。elems的 protected 指的是这个参数只有该类的子类才能访问，这个访问的范围与 Java 中的有些不同，Java 的 protected 关键字除了子类，类本身以及同一个包内都可以访问。



