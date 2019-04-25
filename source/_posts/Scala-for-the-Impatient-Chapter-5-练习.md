---
title: Scala for the Impatient Chapter 5 练习
date: 2019-04-23 21:28:25
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第五章练习。
---
#### 第1题 
改进5.1节的` Counter`类，让它不要在 `Int.MaxValue`时变成负数。
本题的要求其实是在不断对 `value` 进行累加是避免溢出，因为溢出了就会变成负数，所以需要对` increment()`进行改造，具体修改及测试代码如下：

```scala
package excercises.chapter5

class Counter {
  private var value = 200
  def increment(): Unit = {
    if(value < Int.MaxValue) //增加一次判断
      value += 1
    else
      value
  }

  def current = value

}

object Counter{
  def main(args: Array[String]): Unit = {
    val max = Int.MaxValue
    var count = 0 //累加次数计数
    println("Int类型的最大值：" + max)
    val counter = new Counter
    for(i <- 1 to (max)) {
      counter.increment()
      count += 1 
    }
    println("经过" + count + "次累后 Value 值为: " + counter.current)
  }
}
```
通过`sbt`编译后，运行结果如下：
```scala
[info] Running excercises.chapter5.Counter 
Int类型的最大值：2147483647
经过2147483647次累后 Value 值为: 2147483647
[success] Total time: 5 s, completed Apr 24, 2019 11:27:27 AM
[IJ]sbt:scalaimpatient> 
```

#### 第2题 
编写一个` BankAccount`类，加入`deposit`和` withdraw`方法，和一个只读的` balance`属性。

代码如下：

```scala
package excercises.chapter5

class BankAccount {
  private var balance = 0.0
  def deposit(depositAmount: Double): Unit ={
    balance += depositAmount
  }
  def withdraw(drawAmount: Double): Unit ={
    balance -= drawAmount
  }

  def current = balance

}

object BankAccount{
  def main(args: Array[String]): Unit ={
    val drawAmount = 800
    val depositAmount = 1000
    val account = new BankAccount
    println("存入金额：" + depositAmount)
    account.deposit(depositAmount)
    println("余额：" + account.current)
    println("取出金额：" + drawAmount)
    account.withdraw(drawAmount)
    println("余额为：" + account.current)
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.BankAccount 
存入金额：1000
余额：1000.0
取出金额：800
余额为：200.0
[success] Total time: 3 s, completed Apr 24, 2019 3:32:38 PM
```
#### 第3题 
编写一个`Time`类，加入只读属性` hours`和` minutes`，和一个检查某一时刻是否早于另一时刻的方法` before(other: Time): Boolean`。`Time`对象应该以` new Time(hrs, min)`方式创建，其中 hrs 小时数以军用时间格式呈现（介于0和23之间）。
代码如下：

```scala
package excercises.chapter5

class Time(val hours: Int, val minutes: Int) {
    def before(other: Time): Boolean ={
      hours < other.hours || (hours == other.hours && minutes < other.minutes)
    }
  def showtime(): String ={
    hours + ":" + minutes
  }
}

object Time{
  def main(args: Array[String]): Unit ={
    val time1 = new Time(12, 30)
    val time2 = new Time(22, 35)
    val time3 = new Time(7, 15)
    println("time1时刻是：" + time1.showtime())
    println("time2时刻是：" + time2.showtime())
    println("time3时刻是：" + time3.showtime())
    println("time1时刻是否早于 time2：" + time1.before(time2))
    println("time2时刻是否早于 time3：" + time2.before(time3))
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.Time 
time1时刻是：12:30
time2时刻是：22:35
time3时刻是：7:15
time1时刻是否早于 time2：true
time2时刻是否早于 time3：false
[success] Total time: 26 s, completed Apr 24, 2019 4:31:33 PM
```
#### 第4题 
重新实现前一个练习中的`Time`类，将内部呈现改成自午夜起的分钟数（介于0到24x60-1之间）。不要改变公有接口。也就是说，客户端代码不应你的修改而受到影响。
根据题意，只要修改原`Time`类当中当中的` showtime()`就可以了，实现代码如下：

```scala
package excercises.chapter5

class NewTime(override val hours: Int, override val minutes: Int) extends Time(hours = 0, minutes = 0) {
  override def before(other: Time): Boolean = super.before(other) //使用原类的方法
  override def showtime(): String = hours * 60 + "" + minutes //根据题意重写原类的方法
}

object NewTime{
  def main(args: Array[String]): Unit = {
    val time1 = new NewTime(12, 30)
    val time2 = new NewTime(22, 35)
    val time3 = new NewTime(7, 15)
    println("time1时刻是：" + time1.showtime())
    println("time2时刻是：" + time2.showtime())
    println("time3时刻是：" + time3.showtime())
    println("time1时刻是否早于 time2：" + time1.before(time2))
    println("time2时刻是否早于 time3：" + time2.before(time3))
  }
```
测试结果如下：

```scala
[info] Running excercises.chapter5.NewTime 
time1时刻是：72030
time2时刻是：132035
time3时刻是：42015
time1时刻是否早于 time2：true
time2时刻是否早于 time3：false
[success] Total time: 11 s, completed Apr 24, 2019 4:59:56 PM
```
#### 第5题 
创建一个`Student`类，加入可以读写的` JavaBeans`属性` name`（类型为 `String`）和` ID`（类型为 Long）。有哪些方法被生成？（用 `javap` 查看）你可以在 `Scala` 中调用`javaBeans` 版的 `getter` 和 `setter` 方法吗？应该这样做吗？
类代码如下：

```scala
package excercises.chapter5

import scala.beans.BeanProperty

class Student {
  @BeanProperty val name: String = null
  @BeanProperty val ID: Long = 0
}
```
生成方法如下：

```scala
⇒  javap -private Student 
Warning: Binary file Student contains excercises.chapter5.Student
Compiled from "Student.scala"
public class excercises.chapter5.Student {
  private final java.lang.String name;
  private final long ID;
  public java.lang.String name();
  public long ID();
  public long getID();
  public java.lang.String getName();
  public excercises.chapter5.Student();
}
```
显然，可以在 `Scala` 中调用`javaBeans` 版的 `getter` 和 `setter` 方法，测试代码如下:

```scala
package excercises.chapter5

import scala.beans.BeanProperty


class Student {
  @BeanProperty var name: String = null
  @BeanProperty var ID: Long = 0
  //为了后面也能够调用 setter 方法，将变量声明为 var 类型
}

object Student{
  def main(args: Array[String]): Unit = {
    val student = new Student()
    println(student.getID())
    println(student.getName())
    student.ID = 1984
    student.name = "Simon"
    println(student.getID())
    println(student.getName())
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.Student 
0
null
1984
Simon
[success] Total time: 62 s, completed Apr 24, 2019 5:22:55 PM
```
出于Java 与 Scala 互操作的考虑，应该需要这样的调用。
#### 第6题 
在5.2节的` Person`类中提供一个主构造器，将负年龄转换为0。
代码如下：

```scala
package excercises.chapter5

class Person(var age: Int = 0) {
  age = if(age < 0) 0 else age
}

object Person{
  def main(args: Array[String]): Unit = {
    val age1 = 15
    val age2 = -25

    println("将Simon的年龄初始化为:"+age1)
    val Simon = new Person(age1)
    println("Simon的实际年龄为:" + Simon.age)
    println("将Jack的年龄初始化为:"+age2)
    val Jack = new Person(age2)
    println("Jack的实际年龄为:" + Jack.age)
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.Person 
将Simon的年龄初始化为:15
Simon的实际年龄为:15
将Jack的年龄初始化为:-25
Jack的实际年龄为:0
[success] Total time: 4 s, completed Apr 24, 2019 5:34:34 PM
```
#### 第7题
编写一个` Person`类，其主构造器接受一个字符串，该字符串包含名字、空格和姓，如` new Person("Fred Smith")`。提供只读属性` firstName`和` lastName`。主构造器参数应该是 var、val还是普通参数呢？为什么？

根据题意，firstName和lastName为只读的，所以不能重复赋值。如果为var，则对应的此字符串有get和set方法，会因为可能发生的重复赋值而报错。
并且名字一般不会轻易变更，实现代码如下：

```scala
package excercises.chapter5

class NewPerson(val name: String) {
  val firstName: String = {val tokens = name.mkString.split("\\s+"); tokens.head}
  val lastName: String = {val tokens = name.mkString.split("\\s+"); tokens.last}
}

object NewPerson{
  def main(args: Array[String]): Unit = {
    val person=new NewPerson("Simon Peter")
    //name参数自动转为私有字段,并生成公有getter
    println("person的名称为:" + person.name)
    println("person的FisrtName:" + person.firstName)
    println("person的LastName:" + person.lastName)
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.NewPerson 
person的名称为:Simon Peter
person的FisrtName:Simon
person的LastName:Peter
[success] Total time: 4 s, completed Apr 24, 2019 6:30:41 PM
```

#### 第8题
创建一个 Car 类，以只读属性对应制造商、型号名称、型号年份以及一个可读写的属性用于车牌。提供四组构造器。每一个构造器都要求制造商和型号名称为必填。型号年份以及车牌为可选，如果未填，则型号年份设置为-1，车牌设置为空字符串。你会选择哪一个作为你的主构造器？为什么？

为了少写一些代码，以四个参数都带齐的构造器为主构造器。具体代码如下：

```scala
package excercises.chapter5

class Car(val producer: String, val model: String, val year: String = null, var identify: Int = -1) {

}

object Car{
  def main(args: Array[String]): Unit = {
    val Tesla = new Car("特斯拉","Tesla-Model S")
    val Audi = new Car("一汽","大众-奥迪","2015-1-1")
    val Volvo = new Car("吉利","Volvo-s40","2015-1-2",666666)
    val nameArr = Array("特斯拉","大众","沃尔沃")
    val carArr = Array(Tesla,Audi,Volvo)
    infoOutput(nameArr,carArr)
  }
  def infoOutput(carName:Array[String],carArr:Array[Car])={
    for(i <- 0 until carName.length){
      println(carName(i))
      println("汽车制造商为: " + carArr(i).producer)
      println("汽车型号为: " + carArr(i).model)
      println("汽车产年份为: " + carArr(i).year)
      println("汽车车牌号为: " + carArr(i).identify)
    }
  }
}
```
测试结果如下：

```scala
[info] Running excercises.chapter5.Car 
特斯拉
汽车制造商为: 特斯拉
汽车型号为: Tesla-Model S
汽车产年份为: null
汽车车牌号为: -1
大众
汽车制造商为: 一汽
汽车型号为: 大众-奥迪
汽车产年份为: 2015-1-1
汽车车牌号为: -1
沃尔沃
汽车制造商为: 吉利
汽车型号为: Volvo-s40
汽车产年份为: 2015-1-2
汽车车牌号为: 666666
[success] Total time: 8 s, completed Apr 24, 2019 7:20:49 PM
```
#### 第9题
在 Java、C#或 C++（你自己选）重做前一个练习。Scala 相比之下精简多少？
java 代码如下：

```java
package excercises.chapter5;

class JavaCar {

    private String producer;
    private String model;
    private String year;
    private int identify;

    public JavaCar(){

    }
    public JavaCar(String producer, String model){
        this.producer = producer;
        this.model = model;
        this.year = null;
        this.identify = -1;
    }

    public JavaCar(String producer, String model, String year){
        this.producer = producer;
        this.model = model;
        this.year = year;
        this.identify = -1;
    }

    public JavaCar(String producer, String model, String year, int identify){
        this.producer = producer;
        this.model = model;
        this.year = year;
        this.identify = identify;
    }

    public String getProducer(){
        return this.producer;
    }

    public String getModel(){
        return this.model;
    }

    public String getYear(){
        return this.year;
    }

    public int getIdentify(){
        return this.identify;
    }

    public void setIdentify(int identify){
        this.identify = identify;
    }

    public static void main(String[] args) {

    }
}

public class CarTest{
    public static void main(String[] args) {
        JavaCar Tesla = new JavaCar("特斯拉","特斯拉-Model S");
        JavaCar Audi = new JavaCar("一汽","大众-奥迪","2015-1-1");
        JavaCar Volvo = new JavaCar("吉利","Volvo-S40","2015-1-2",66666);
        String[] nameArr = {"特斯拉", "大众", "沃尔沃"};
        JavaCar[] carinfoArr = {Tesla, Audi, Volvo};
        CarTest cartest = new CarTest();
        cartest.infoOutput(nameArr,carinfoArr);
    }
    public void infoOutput(String[] nameArr,JavaCar[] carinfoArr){
        for(int i = 0;i < nameArr.length; i++){
            System.out.println(nameArr[i]);
            System.out.println("汽车制造商: " + carinfoArr[i].getProducer());
            System.out.println("汽车型号: " + carinfoArr[i].getModel());
            System.out.println("汽车年份: " + carinfoArr[i].getYear());
            System.out.print("车牌号: "+ carinfoArr[i].getIdentify());
        }
    }
}
``` 输出结果如下：

```java
[info] Running excercises.chapter5.CarTest 
特斯拉
汽车制造商: 特斯拉
汽车型号: 特斯拉-Model S
汽车年份: null
车牌号: -1大众
汽车制造商: 一汽
汽车型号: 大众-奥迪
汽车年份: 2015-1-1
车牌号: -1沃尔沃
汽车制造商: 吉利
汽车型号: Volvo-S40
汽车年份: 2015-1-2
车牌号: 66666[success] Total time: 3 s, completed Apr 25, 2019 8:25:29 AM
```
相比较而言，Scala实在精简太多了……

#### 第10题
考虑如下类：

```scala
class Employee(val name: String, var salary: Double){
    def this(){this("John Q. Public", 0.0)}
}
```
重写该类，使用显式的字段定义，和一个缺省主构造器。你更倾向于使用哪种形式？为什么？

重写的类代码如下：

```scala
class Employee(){
    private val name: String = "John Q. Public"
    private val salary: Double = 0.0
}
```

重写类的风格更加趋向于 Java，自带主构造器的则更加 scalable，从后续拓展，减少代码量的角度倾向于后一种。
