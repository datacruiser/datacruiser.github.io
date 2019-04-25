---
title: Scala for the Impatient Chapter 4 练习
date: 2019-04-22 23:12:40
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第四章练习。
---
#### 第1题 
设置一个映射，其中包含你想要的一些装备，以及他们的价格。然后构建另一个映射，采用同一组键，但在价格上打9折。
代码如下：

```scala
val items = Map("MacBook" -> 9888, "MacBook Pro" -> 20888, "Iphone XS Max" -> 10888)

for ((k, v) <- items) yield (k, v * 0.9)
```

测试结果如下：
 
```scala
scala> val items = Map("MacBook" -> 9888, "MacBook Pro" -> 20888, "Iphone XS Max" -> 10888)
items: scala.collection.immutable.Map[String,Int] = Map(MacBook -> 9888, MacBook Pro -> 20888, Iphone XS Max -> 10888)

scala> items
res0: scala.collection.immutable.Map[String,Int] = Map(MacBook -> 9888, MacBook Pro -> 20888, Iphone XS Max -> 10888)

scala> for ((k, v) <- items) yield (k, v * 0.9)
res1: scala.collection.immutable.Map[String,Double] = Map(MacBook -> 8899.2, MacBook Pro -> 18799.2, Iphone XS Max -> 9799.2)
```
#### 第2题
编写一段程序，从文件中读取单词。用一个可变映射来清点每一个单词出现的频率。读取这些单词的操作可以使用` java.util.Scanner`:

```scala
val in = new java.util.Scanner(new java.io.File("myfile.txt"))
while (in.hasNext()) 处理 in.next()
```
或者翻到第9章看看更` Scala`的做法。
最后打印出所有单词和他们出现的次数

首先在`scala`命令行启动目录下新建文本文件`file.txt`，内容如下：

```
hello
world
scala
java
java
erlang
go
C
C++
C
C++
hello
world
java
scala
scala
spark
spark
hadoop
hadoop
hadoop
python
python
python
scala
C
java
go
go
go
scala
scala
```
采用题干中提到的方法的代码如下：

```scala
import scala.collection.mutable.HashMap

val in = new java.util.Scanner(new java.io.File("file.txt"))

val maps = new HashMap[String, Int]
var key: String = null
while(in.hasNext()){
    key = in.next()
    maps(key) = maps.getOrElse(key, 0) + 1
}
maps.foreach(println)
```
测试结果如下：

```scala
scala> val in = new java.util.Scanner(new java.io.File("file.txt"))
in: java.util.Scanner = java.util.Scanner[delimiters=\p{javaWhitespace}+][position=0][match valid=false][need input=false][source closed=false][skipped=false][group separator=\,][decimal separator=\.][positive prefix=][negative prefix=\Q-\E][positive suffix=][negative suffix=][NaN string=\Q�\E][infinity string=\Q∞\E]

scala> val maps = new HashMap[String, Int]
maps: scala.collection.mutable.HashMap[String,Int] = Map()

scala> var key: String = null
key: String = null

scala> while(in.hasNext()){
     |     key = in.next()
     |     maps(key) = maps.getOrElse(key, 0) + 1
     | }

scala> maps.foreach(println)
(go,4)
(hadoop,3)
(spark,2)
(erlang,1)
(scala,6)
(world,2)
(C,3)
(java,4)
(hello,2)
(python,3)
(C++,2)
```

按照第九章的文件处理来做的代码如下：

```scala
import scala.io.Source
import scala.collection.mutable.HashMap

val fileSource = Source.fromFile("file.txt").mkString
val tokens = fileSource.split("\\s+")

val maps = new HashMap[String, Int]

for (key <- tokens) {
	maps(key) = maps.getOrElse(key, 0) + 1 // 用 getOrElse 来加入新的元素或加1
}

maps.foreach(println)
```
测试结果如下：
```scala
scala> import scala.io.Source
import scala.io.Source

scala> import scala.collection.mutable.HashMap
import scala.collection.mutable.HashMap

scala> val fileSource = Source.fromFile("file.txt").mkString
fileSource: String =
"hello
world
scala
java
java
erlang
go
C
C++
C
C++
hello
world
java
scala
scala
spark
spark
hadoop
hadoop
hadoop
python
python
python
scala
C
java
go
go
go
scala
scala

"

scala> val tokens = fileSource.split("\\s+")
tokens: Array[String] = Array(hello, world, scala, java, java, erlang, go, C, C++, C, C++, hello, world, java, scala, scala, spark, spark, hadoop, hadoop, hadoop, python, python, python, scala, C, java, go, go, go, scala, scala)

scala> val maps = new HashMap[String, Int]
maps: scala.collection.mutable.HashMap[String,Int] = Map()

scala> for (key <- tokens) {
     |   maps(key) = maps.getOrElse(key, 0) + 1 // 用 getOrElse 来加入新的元素或加1
     | }

scala> maps.foreach(println)
(go,4)
(hadoop,3)
(spark,2)
(erlang,1)
(scala,6)
(world,2)
(C,3)
(java,4)
(hello,2)
(python,3)
(C++,2)
```
#### 第3题 
重复前一个练习，这次用不可变的映射。
代码如下：

```scala
import scala.collection.immutable.Map

val in = new java.util.Scanner(new java.io.File("file.txt"))

var maps = Map[String, Int]() 
var key: String = null
while(in.hasNext()){
    key = in.next()
    maps += (key -> (maps.getOrElse(key, 0) + 1))
}
maps.foreach(println)
```

测试结果如下：

```scala
scala> import scala.collection.immutable.Map
import scala.collection.immutable.Map

scala> val in = new java.util.Scanner(new java.io.File("file.txt"))
in: java.util.Scanner = java.util.Scanner[delimiters=\p{javaWhitespace}+][position=0][match valid=false][need input=false][source closed=false][skipped=false][group separator=\,][decimal separator=\.][positive prefix=][negative prefix=\Q-\E][positive suffix=][negative suffix=][NaN string=\Q�\E][infinity string=\Q∞\E]

scala> var maps = Map[String, Int]() 
maps: scala.collection.immutable.Map[String,Int] = Map()

scala> var key: String = null
key: String = null

scala> while(in.hasNext()){
     |     key = in.next()
     |     maps += (key -> (maps.getOrElse(key, 0) + 1))
     | }

scala> maps.foreach(println)
(world,2)
(java,4)
(go,4)
(hadoop,3)
(spark,2)
(scala,6)
(erlang,1)
(C,3)
(python,3)
(C++,2)
(hello,2)
```
需要注意以下几点：
- Map 是抽象类，无法用 new 关键字来进行实例化
- 在定义 maps 变量时需要使用 var 关键字声明为可变变量
- 在对 key 进行计数时需要采用`+=`操作符，且需要用`->`指向key 所对应的原来的 value

#### 第4题 
重复前一个练习，这次用已排序的映射，以便单词可以按顺序打印出来。
代码如下：

```scala
import scala.collection.immutable.SortedMap

val in = new java.util.Scanner(new java.io.File("file.txt"))

var sortedMaps = SortedMap[String, Int]() 
var key: String = null
while(in.hasNext()){
    key = in.next()
    sortedMaps += (key -> (sortedMaps.getOrElse(key, 0) + 1))
}
sortedMaps.foreach(println)
```
测试结果如下：

```scala
scala> import scala.collection.immutable.SortedMap
import scala.collection.immutable.SortedMap

scala> val in = new java.util.Scanner(new java.io.File("file.txt"))
in: java.util.Scanner = java.util.Scanner[delimiters=\p{javaWhitespace}+][position=0][match valid=false][need input=false][source closed=false][skipped=false][group separator=\,][decimal separator=\.][positive prefix=][negative prefix=\Q-\E][positive suffix=][negative suffix=][NaN string=\Q�\E][infinity string=\Q∞\E]

scala> var sortedMaps = SortedMap[String, Int]() 
sortedMaps: scala.collection.immutable.SortedMap[String,Int] = Map()

scala> var key: String = null
key: String = null

scala> while(in.hasNext()){
     |     key = in.next()
     |     sortedMaps += (key -> (sortedMaps.getOrElse(key, 0) + 1))
     | }

scala> sortedMaps.foreach(println)
(C,3)
(C++,2)
(erlang,1)
(go,4)
(hadoop,3)
(hello,2)
(java,4)
(python,3)
(scala,6)
(spark,2)
(world,2)
```
需要注意的是，`SortedMap`的基本性质和` Map`相同。

#### 第5题 
重复前一个练习，这次用 `java.util.TreeMap`并使之适用于 Scala API。
代码如下：

```scala
import scala.collection.JavaConversions.mapAsScalaMap

val in = new java.util.Scanner(new java.io.File("file.txt"))
val treeMaps: scala.collection.mutable.Map[String, Int] = new java.util.TreeMap[String, Int] 
var key: String = null
while(in.hasNext()){
    key = in.next()
    treeMaps(key) = treeMaps.getOrElse(key, 0) + 1
}
treeMaps.foreach(println)
```
测试结果如下：

```scala
scala> val in = new java.util.Scanner(new java.io.File("file.txt"))
in: java.util.Scanner = java.util.Scanner[delimiters=\p{javaWhitespace}+][position=0][match valid=false][need input=false][source closed=false][skipped=false][group separator=\,][decimal separator=\.][positive prefix=][negative prefix=\Q-\E][positive suffix=][negative suffix=][NaN string=\Q�\E][infinity string=\Q∞\E]

scala> val treeMaps: scala.collection.mutable.Map[String, Int] = new java.util.TreeMap[String, Int] 
<console>:31: warning: object JavaConversions in package collection is deprecated (since 2.12.0): use JavaConverters
       val treeMaps: scala.collection.mutable.Map[String, Int] = new java.util.TreeMap[String, Int]
                                                                 ^
treeMaps: scala.collection.mutable.Map[String,Int] = Map()

scala> var key: String = null
key: String = null

scala> while(in.hasNext()){
     |     key = in.next()
     |     treeMaps(key) = treeMaps.getOrElse(key, 0) + 1
     | }

scala> treeMaps.foreach(println)
(C,3)
(C++,2)
(erlang,1)
(go,4)
(hadoop,3)
(hello,2)
(java,4)
(python,3)
(scala,6)
(spark,2)
(world,2)

```
#### 第6题 
定义一个链式哈希映射，将"Monday"映射到`java.util.Calendar.MONDAY`，依次类推加入其它日期。展示元素是以插入顺序被访问的。
代码如下：

```scala
import scala.collection.mutable.LinkedHashMap
import java.util.Calendar

val maps = new LinkedHashMap[String, Int]
maps += ("Monday" -> Calendar.MONDAY)
maps += ("Tuesday" -> Calendar.TUESDAY)
maps += ("Thursday" -> Calendar.THURSDAY)
maps += ("Wednesday" -> Calendar.WEDNESDAY)
maps += ("Friday" -> Calendar.FRIDAY)
maps += ("Saturday" -> Calendar.SATURDAY)
maps += ("Sunday" -> Calendar.SUNDAY)
maps foreach println
```

测试结果如下：

```scala
scala> import scala.collection.mutable.LinkedHashMap
import scala.collection.mutable.LinkedHashMap

scala> import java.util.Calendar
import java.util.Calendar

scala> val maps = new LinkedHashMap[String, Int]
maps: scala.collection.mutable.LinkedHashMap[String,Int] = Map()

scala> maps += ("Monday" -> Calendar.MONDAY)
res26: maps.type = Map(Monday -> 2)

scala> maps += ("Tuesday" -> Calendar.TUESDAY)
res27: maps.type = Map(Monday -> 2, Tuesday -> 3)

scala> maps += ("Thursday" -> Calendar.THURSDAY)
res28: maps.type = Map(Monday -> 2, Tuesday -> 3, Thursday -> 5)

scala> maps += ("Wednesday" -> Calendar.WEDNESDAY)
res29: maps.type = Map(Monday -> 2, Tuesday -> 3, Thursday -> 5, Wednesday -> 4)

scala> maps += ("Friday" -> Calendar.FRIDAY)
res30: maps.type = Map(Monday -> 2, Tuesday -> 3, Thursday -> 5, Wednesday -> 4, Friday -> 6)

scala> maps += ("Saturday" -> Calendar.SATURDAY)
res31: maps.type = Map(Monday -> 2, Tuesday -> 3, Thursday -> 5, Wednesday -> 4, Friday -> 6, Saturday -> 7)

scala> maps += ("Sunday" -> Calendar.SUNDAY)
res32: maps.type = Map(Monday -> 2, Tuesday -> 3, Thursday -> 5, Wednesday -> 4, Friday -> 6, Saturday -> 7, Sunday -> 1)

scala> maps foreach println
(Monday,2)
(Tuesday,3)
(Thursday,5)
(Wednesday,4)
(Friday,6)
(Saturday,7)
(Sunday,1)

```
#### 第7题 
打印出所有Java系统属性的表格，类似这样：

 属性名称 | 属性值 
 :-: | :-: 
 java.rutime.name | Java(TM) SE Runtime Environment 
 sun.boot.library.path | /home/apps/jdk1.6.0_21/jre/lib/i386
 java.vm.version | 17.0-b16
 java.vm.vendor | sun Microsystems Inc. 
 java.vendor.url | http://java.sun.com/
 path.separator | :
 java.vm.name | Java HotSpot(TM) Server VM
 你需要找到最长键的长度才能正确地打印出这张表格。
 
 代码如下：
 
```scala
import scala.collection.JavaConversions.propertiesAsScalaMap
val props: scala.collection.Map[String, String] = System.getProperties()
val keys = props.keySet //获得映射的键
val keyLength = for(i <- keys) yield i.length()// 获得所有键的长度
val maxKeyLength = keyLength.max //获得最长键的长度
for(key <- keys){
    print(key)
    print(" "*(maxKeyLength - key.length()))
    print("|")
    println(props(key))
}
```
部分测试结果如下：

```scala
scala> import scala.collection.JavaConversions.propertiesAsScalaMap
import scala.collection.JavaConversions.propertiesAsScalaMap

scala> val props: scala.collection.Map[String, String] = System.getProperties()
<console>:36: warning: object JavaConversions in package collection is deprecated (since 2.12.0): use JavaConverters
       val props: scala.collection.Map[String, String] = System.getProperties()
                                                                             ^
props: scala.collection.Map[String,String] =
Map(java.runtime.name -> Java(TM) SE Runtime Environment, sun.boot.library.path -> /Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home/jre/lib, java.vm.version -> 25.152-b16, gopherProxySet -> false, java.vm.vendor -> Oracle Corporation, java.vendor.url -> http://java.oracle.com/, path.separator -> :, java.vm.name -> Java HotSpot(TM) 64-Bit Server VM, file.encoding.pkg -> sun.io, user.country -> CN, sun.java.launcher -> SUN_STANDARD, sun.os.patch.level -> unknown, java.vm.specification.name -> Java Virtual Machine Specification, user.dir -> /Users/datacruiser/IdeaProjects/prog-scala-2nd-ed-code-examples, java.runtime.version -> 1.8.0_152-b16, java.awt.graphicsenv -> sun.awt.CGraphicsEnvironment, java.end...

scala> val keys = props.keySet //获得映射的键
keys: scala.collection.Set[String] = Set(java.runtime.name, sun.boot.library.path, java.vm.version, gopherProxySet, java.vm.vendor, java.vendor.url, path.separator, java.vm.name, file.encoding.pkg, user.country, sun.java.launcher, sun.os.patch.level, java.vm.specification.name, user.dir, java.runtime.version, java.awt.graphicsenv, java.endorsed.dirs, os.arch, java.io.tmpdir, line.separator, java.vm.specification.vendor, os.name, sun.jnu.encoding, java.library.path, java.specification.name, java.class.version, sun.management.compiler, os.version, scala.boot.class.path, user.home, user.timezone, scala.home, java.awt.printerjob, file.encoding, java.specification.version, scala.usejavacp, java.class.path, user.name, java.vm.specification.version, sun.java.command, ...

scala> val keyLength = for(i <- keys) yield i.length()// 获得所有键的长度
keyLength: scala.collection.Set[Int] = Set(10, 25, 14, 20, 29, 28, 21, 9, 13, 17, 12, 7, 18, 16, 11, 26, 23, 8, 19, 15)

scala> val maxKeyLength = keyLength.max //获得最长键的长度
maxKeyLength: Int = 29

scala> for(key <- keys){
     |     print(key)
     |     print(" "*(maxKeyLength - key.length()))
     |     print("|")
     |     println(props(key))
     | }
java.runtime.name            |Java(TM) SE Runtime Environment
sun.boot.library.path        |/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home/jre/lib
java.vm.version              |25.152-b16
gopherProxySet               |false
java.vm.vendor               |Oracle Corporation
java.vendor.url              |http://java.oracle.com/
path.separator               |:
java.vm.name                 |Java HotSpot(TM) 64-Bit Server VM
file.encoding.pkg            |sun.io
user.country                 |CN
sun.java.launcher            |SUN_STANDARD
sun.os.patch.level           |unknown
java.vm.specification.name   |Java Virtual Machine Specification
user.dir                     |/Users/datacruiser/IdeaProjects/prog-scala-2nd-ed-code-examples
java.runtime.version         |1.8.0_152-b16
java.awt.graphicsenv         |sun.awt.CGraphicsEnvironment
java.endorsed.dirs           |/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home/jre/lib/endorsed
os.arch                      |x86_64
java.io.tmpdir               |/var/folders/t0/csmkjx2s3cn0dgsd2t4zmf_w0000gn/T/
line.separator               |
...
```
#### 第8题 
编写一个函数` minmax(values: Array[Int])`，返回数组中最小值和最大值的对偶。
- 版本一，采用HashMap，代码如下：

```scala
def minmax(values: Array[Int]): HashMap[Int, Int] = {
    val map = new HashMap[Int, Int]
    val min = values.min
    val max = values.max
    map(min) = max
    map
}
```
测试结果如下：

```scala
scala> def minmax(values: Array[Int]): HashMap[Int, Int] = {
     |     val map = new HashMap[Int, Int]
     |     val min = values.min
     |     val max = values.max
     |     map(min) = max
     |     map
     | }
minmax: (values: Array[Int])scala.collection.mutable.HashMap[Int,Int]

scala> val a = Array(1 ,2, 3 ,4, 5, 6, 7)
a: Array[Int] = Array(1, 2, 3, 4, 5, 6, 7)

scala> minmax(a)
res39: scala.collection.mutable.HashMap[Int,Int] = Map(1 -> 7)
```
- 版本二，采用Map，代码如下：

```scala
def minmax(values: Array[Int]): Map[Int, Int] = {
    var map = Map[Int, Int]()
    val min = values.min
    val max = values.max
    map += (min -> max)
    map
}
```
测试结果如下：

```scala
scala> def minmax(values: Array[Int]): Map[Int, Int] = {
     |     var map = Map[Int, Int]()
     |     val min = values.min
     |     val max = values.max
     |     map += (min -> max)
     |     map
     | }
minmax: (values: Array[Int])scala.collection.immutable.Map[Int,Int]

scala> val ab = Array(1 ,2 ,3 , 4, 5, 7, 9)
ab: Array[Int] = Array(1, 2, 3, 4, 5, 7, 9)

scala> minmax(ab)
res42: scala.collection.immutable.Map[Int,Int] = Map(1 -> 9)
```
#### 第9题 
编写一个函数 `lteqgt(values: Array[Int], v: Int)`，返回数组中小于v、 等于 v和大于 v 的数量，要求三个值一起返回。
代码如下：

```scala
def lteqgt(values: Array[Int], v: Int): Tuple3[Int, Int, Int] = {
    val tuple = (values.count(_ < v), values.count(_ == v), values.count(_ > v))
    tuple
}
```

测试结果如下：

```scala
scala> def lteqgt(values: Array[Int], v: Int): Tuple3[Int, Int, Int] = {
     |     val tuple = (values.count(_ < v), values.count(_ == v), values.count(_ > v))
     |     tuple
     | }
lteqgt: (values: Array[Int], v: Int)(Int, Int, Int)

scala> val values = Array(-1, -2, -3, -4, 0 ,0, 5, 56, 7 ,12)
values: Array[Int] = Array(-1, -2, -3, -4, 0, 0, 5, 56, 7, 12)

scala> val v = 0
v: Int = 0

scala> lteqgt(values, v)
res40: (Int, Int, Int) = (4,2,4)
```
需要注意的是，这里用到了` GenTraversableOnce`当中的一个聚合函数` count`：

```scala
abstract def count(p: (A) ⇒ Boolean): Int
Counts the number of elements in the collection or iterator which satisfy a predicate.
p
the predicate used to test elements.
returns
the number of elements satisfying the predicate p.
```

#### 第10题 
当你将两个字符串拉链在一起，比如`“Hello”.zip("World")`，会是什么结果，想出一个讲得通的用例。
测试结果如下：

```scala
scala> "Hello".zip("World")
res43: scala.collection.immutable.IndexedSeq[(Char, Char)] = Vector((H,W), (e,o), (l,r), (l,l), (o,d))

scala> val string = "Hello".zip("World")
string: scala.collection.immutable.IndexedSeq[(Char, Char)] = Vector((H,W), (e,o), (l,r), (l,l), (o,d))

scala> string foreach println
(H,W)
(e,o)
(l,r)
(l,l)
(o,d)
```

查看 ScalaDoc，在`GenIterableLike`当中` zip`的文档如下：

```scala
abstract def zip[B](that: GenIterable[B]): GenIterable[(A, B)]
[use case]
Returns a general iterable collection formed from this general iterable collection and another iterable collection by combining corresponding elements in pairs. If one of the two collections is longer than the other, its remaining elements are ignored.

Note: might return different results for different runs, unless the underlying collection type is ordered.
B
the type of the second half of the returned pairs
that
The iterable providing the second half of each result pair
returns
a new general iterable collection containing pairs consisting of corresponding elements of this general iterable collection and that. The length of the returned collection is the minimum of the lengths of this general iterable collection and that.
 Full Signature

```
`zip`会对所有可遍历的集合进行拉链操作，而字符串本身是可遍历的，且是以字符为单位进行遍历，因此出现了上述运行结果。根据文档，返回集合的长度是以 A、B两者较小的长度为准，具体可以再看下下面这个例子:

```scala
scala> val string = "Hello".zip("Worldscala")
string: scala.collection.immutable.IndexedSeq[(Char, Char)] = Vector((H,W), (e,o), (l,r), (l,l), (o,d))

scala> string foreach println
(H,W)
(e,o)
(l,r)
(l,l)
(o,d)
```
这里"Worldscala"后面的"scala"被忽略了。