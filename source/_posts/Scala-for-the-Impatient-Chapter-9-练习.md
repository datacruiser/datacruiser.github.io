---
title: Scala for the Impatient Chapter 9 练习
date: 2019-04-29 13:26:45
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第九章练习。
---
#### 第1题 


编写一小段 Scala 代码，将某个文件中的行倒转顺序（将最后一行作为第一行，以此类推）

首先创建文件 File.txt:

```txt
hello
world
test
Scala
Hadoop
Big Date
Java
```

根据题意编码如下：

```scala
package excercises.chapter9

import java.io.{File, PrintWriter}
import scala.io.{BufferedSource, Source}

object ReverseLines extends App {
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "File.txt"
  val reverseFileName: String = "ReverseFile.txt"

  val source: BufferedSource = Source.fromFile(path + "/" + fileName, "UTF-8")

  lazy val reSource: BufferedSource = Source.fromFile(path + "/" + reverseFileName, "UTF-8")
  lazy val pw: PrintWriter = new PrintWriter(path + "/" + reverseFileName)

//  val reversedLinesTest: Array[String] = source.getLines.toArray.reverse
//  println(fileName + "文件内容如下：")
//  reversedLinesTest.foreach (line => println(line))
//  reversedLinesTest.foreach (line => pw.write(line + "\n"))
//  pw.close()

  val linesIterator: Iterator[String] = source.getLines()
  val linesRecord: Array[String] = linesIterator.toArray
  val reversedLines: Array[String] = linesRecord.reverse

  reversedLines.foreach (line => pw.write(line + "\n"))
  pw.close()

  println(fileName + "文件内容如下：")
  linesRecord.foreach (line => println(line))

  println(reverseFileName + "文件内容如下：")
  reSource.getLines.foreach (line => println(line))

  reSource.close()
  source.close()
}
```


运行结果如下：


```scala
[info] Running excercises.chapter9.ReverseLines 
File.txt文件内容如下：
hello
world
test
Scala
Hadoop
Big Date
Java
ReverseFile.txt文件内容如下：
Java
Big Date
Hadoop
Scala
test
world
hello
[success] Total time: 2 s, completed Apr 29, 2019 4:02:13 PM
```
这里面有几个坑，首先，迭代器只能够被遍历一次，因此为了保存数据的中间结果，以便于后续对比，下面三行代码：

```scala
val linesIterator: Iterator[String] = source.getLines()
val linesRecord: Array[String] = linesIterator.toArray
val reversedLines: Array[String] = linesRecord.reverse
```

不宜写成一行：

```scala
val reversedLinesTest: Array[String] = source.getLines.toArray.reverse
```

这样可以保存行序倒转后的文本，但是在用`source.getlines`去遍历的时候已经为空。

#### 第2题

编写 Scala 程序，从一个带有制表符的文件读取内容，将每个制表符替换成一组空格，使得制表符隔开的 n 列仍然保持纵向对齐，并将结果写入同一个文件。

根据题意编写代码如下：


```scala
package excercises.chapter9
import java.io.{File, PrintWriter}
import scala.io.{BufferedSource, Source}

object TabToSpace extends App {
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "TabSpace.txt"
  val source: BufferedSource = Source.fromFile(path + "/" + fileName, "UTF-8")
  val linesIterator: Iterator[String] = source.getLines()
  lazy val tabIterator: Iterator[String] = Source.fromFile(path + "/" + fileName, "UTF-8").getLines()
  lazy val pw: PrintWriter = new PrintWriter(path + "/" + fileName)
  val linesRecord: Array[String] = linesIterator.toArray

  println(fileName + "文件内容如下：")
  linesRecord.foreach (line => println(line))

  linesRecord.foreach (line => pw.write(line.replaceAll("\t", " ") + "\n"))
  pw.close()

  println("替换后" + fileName + "文件内容如下：")
  tabIterator.foreach (line => println(line))
  source.close()
}
```

测试结果如下：

```scala
[info] Running excercises.chapter9.TabToSpace 
TabSpace.txt文件内容如下：
a	b	c	d	e	f	g	h
i	j	k	l	m	n	o	p
q	r	s	t	u	v	w	x
y	z
A	B	D	D	E	F	G	H
I	J	K	L	M	N	O	P
Q	R	S	T	U	V	W	X
Y	Z
替换后TabSpace.txt文件内容如下：
a b c d e f g h
i j k l m n o p
q r s t u v w x
y z
A B D D E F G H
I J K L M N O P
Q R S T U V W X
Y Z
[success] Total time: 2 s, completed Apr 29, 2019 6:39:53 PM
```

比较坑的一点是有些 IDE 对于 tab 键并不在文本中记录为 tab 字符，需要进行设置，另外，在 vim 当中可以如下设置显示 tab 字符。

```
:set list TAB
```


#### 第3题

编写一小段 Scala 代码，从一个文件读取内容并把所有字符数大于12的单词打印到控制台。如果你能够用单行代码完成会有奖励。

首先编写 CheckString.txt文件内容如下：

```scala
aefwefweghgwge
ghwoeghwegwe
gwohegowehgowehtiwhtwht
gwohgowehtheoqthgnan
laohaq gwtweohghwy
howhgewongnyey
ghee
goengyta;
lgeneyt[nslagqn
nongeo
gneriewgny
jgwoehwtnyh
hgowenckanekganwyqyq
klgeny
```

然后编写代码如下：

```scala
package excercises.chapter9

import java.io.File
import scala.io.Source

object CheckString extends App {
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "CheckString.txt"
  println(fileName + "文件中长度大于12的字符串为：")
  Source.fromFile(path + "/" + fileName, "UTF-8").mkString.split("\\s+").foreach( str => if(str.length() > 12) println(str))
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter9.CheckString 
CheckString.txt文件中长度大于12的字符串为：
aefwefweghgwge
gwohegowehgowehtiwhtwht
gwohgowehtheoqthgnan
howhgewongnyey
lgeneyt[nslagqn
hgowenckanekganwyqyq
[success] Total time: 6 s, completed Apr 30, 2019 11:38:49 PM
```


#### 第4题

编写 Scala 程序，从包含浮点数的文本文件读取内容，打印出文件中所有浮点数之和、平均值、最大值和最小值。

根据题意，编码如下：

```scala
package excercises.chapter9

import java.io.File

object ReadFloatNumber extends App {
  val floatPattern ="[-+]?[0-9]*\\.?[0-9]+".r //浮点数正则匹配模式
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "FloatNumber.txt"
//  def parseDouble(s: String) = {s.toDouble}
//  def paresDoubleArr(strArr: Array[String]) = {
//    strArr foreach println
//    val numberArr = new ArrayBuffer[Double](strArr.length)
//    numberArr foreach println
//    for(i <- 0 until strArr.length){
//      numberArr(i) = parseDouble(strArr(i))
//    }
//    numberArr.toArray
//  }

  val fileStr = io.Source.fromFile(path + "/" + fileName).mkString
  val strArray = floatPattern.findAllIn(fileStr).toArray
  val len = strArray.length
  println("文本中浮点数个数: " + len)
  strArray foreach println
  val numberArray = for(s <- strArray) yield s.toDouble //将String 的字符串转化为 Double 的字符串，以便于后面的函数调用
  println("文本中浮点数总和：" + numberArray.sum)
  println("文本中浮点数的平均值: " + numberArray.sum / len)
  println("文本中浮点数的最大值: " + numberArray.max)
  println("文本中浮点数的最小值: " + numberArray.min)
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter9.ReadFloatNumber 
文本中浮点数个数: 11
+15.5
17.0
1888.18
-15.0
-1
-15.9
1989898
15
111
11
144
文本中浮点数总和：1992067.78
文本中浮点数的平均值: 181097.07090909092
文本中浮点数的最大值: 1989898.0
文本中浮点数的最小值: -15.9
[success] Total time: 2 s, completed May 2, 2019 8:40:38 AM
```

需要特别指出的一点是，在代码的26行，新建的一个变量`numberArray`用来存储` Double`类型的数组，这样可以在后面方便地调用` sum`、`max`以及` min`等函数。	

#### 第5题

编写 Scala 程序，向文件中写入2的 n 次方及其倒数，指数 n 从0到20。对齐各列：


原数 | 倒数 
:-: | :-: 
1 | 1 
2 | 0.5
4 | 0.25
... | ...


根据题意编码如下：

```scala
package excercises.chapter9

import java.io.{File, PrintWriter}

object IndexWriter extends App {
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val indexWriter = new PrintWriter(path + "/" + "Index.txt")
  for(n <- 0 to 20){
    val index = BigDecimal(2).pow(n)
    indexWriter.write(index.toString())
    indexWriter.write("\t\t\t\t")
    indexWriter.write((1 / index).toString())
    indexWriter.write("\n")
  }
  indexWriter.close()
}
```

最后，`Index.txt`文件的内容如下：

```scala
1				1
2				0.5
4				0.25
8				0.125
16				0.0625
32				0.03125
64				0.015625
128				0.0078125
256				0.00390625
512				0.001953125
1024				0.0009765625
2048				0.00048828125
4096				0.000244140625
8192				0.0001220703125
16384				0.00006103515625
32768				0.000030517578125
65536				0.0000152587890625
131072				0.00000762939453125
262144				0.000003814697265625
524288				0.0000019073486328125
1048576				9.5367431640625E-7

```

#### 第6题

编写正则表达式，匹配 Java 或 C++程度代码中类似"like this, maybe with \" or \\"这样的带引号的字符串。编写 Scala 程序将某个源文件中所有类似的字符串打印出来。

根据题意编码如下：

```scala
package excercises.chapter9

import java.io.File

object RegExp extends App {
  val pattern ="""\\\"""".r
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "Regexp.txt"
  val fileStr = io.Source.fromFile(path + "/" + fileName).mkString
//  fileStr foreach println
  pattern.findAllIn(fileStr).foreach(println)
}
```

其中，`Regexp.txt`文件的内容如下：

```scala
wewerwerthwhrtwnb
"like this, maybe with \"
\\"
```



测试运行结果如下：

```scala
[info] Running excercises.chapter9.RegExp 
\"
\"
[success] Total time: 3 s, completed May 2, 2019 2:59:13 PM
```

#### 第7题

编写 Scala 程序，从文本文件读取内容，并打印出所有非浮点数的词法单元。要求使用正则表达式。

根据题意编码如下：

```scala
package excercises.chapter9

import java.io.File

object NonFloat extends App {
  val nonFloatPattern = """[^((\d+\.){0,1}\d+)^\s+]+""".r //非浮点数正则匹配模式
  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "FloatNumber.txt"
  //  def parseDouble(s: String) = {s.toDouble}
  //  def paresDoubleArr(strArr: Array[String]) = {
  //    strArr foreach println
  //    val numberArr = new ArrayBuffer[Double](strArr.length)
  //    numberArr foreach println
  //    for(i <- 0 until strArr.length){
  //      numberArr(i) = parseDouble(strArr(i))
  //    }
  //    numberArr.toArray
  //  }

  val fileStr = io.Source.fromFile(path + "/" + fileName).mkString
  val strArray = nonFloatPattern.findAllIn(fileStr).toArray
  strArray foreach println

}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter9.NonFloat 
scala
Java
-
-
-
Hadoop
[success] Total time: 4 s, completed May 2, 2019 10:44:31 PM
```

#### 第8题

编写 Scala 程序，打印出某个网页中所有 img 标签的 src 属性。使用正则表达式和分组。

根据题意编码如下：

```scala
package excercises.chapter9

object WebPrinter extends App {
  val html = io.Source.fromURL("http://www.google.com", "UTF-8").mkString

  val srcPattern = """(?is)<\s*img[^>]*src\s*=\s*['"\s]*([^'"]+)['"\s]*[^>]*>""".r

  for(srcPattern(s) <- srcPattern findAllIn html) println(s)

}
```

运行结果如下：

```scala
info] Running excercises.chapter9.WebPrinter 
/images/branding/googlelogo/1x/googlelogo_white_background_color_272x92dp.png
[success] Total time: 5 s, completed May 2, 2019 10:53:52 PM
```

#### 第9题

编写 Scala 程序，盘点给定目录机器子目录中总共有多个以.class为扩展名的文件。

借助9.7节提供的遍历目录的代码段，编码如下：


```scala
package excercises.chapter9

import java.io.File

object ClassFileCount extends App {
  val path = "."
  val dir = new File(path)
  def subdirs(dir:File):Iterator[File] = {
    val children = dir.listFiles().filter(_.getName.endsWith("class"))
    children.toIterator ++ dir.listFiles().filter(_.isDirectory).toIterator.flatMap(subdirs _)
  }
  println("本项目根目录项目一共有：" + subdirs(dir).length + "个以 class 结尾的文件。")
}
```
运行结果如下：

```scala
[info] Running excercises.chapter9.ClassFileCount 
本项目根目录项目一共有：157个以 class 结尾的文件。
[success] Total time: 27 s, completed May 2, 2019 11:16:26 PM

```

#### 第10题

扩展那个可序列化的 Person 类，让它能够以一个集合保存某个人的朋友信息。构造出一些 Person 对象，让他们中的一些人成为朋友，然后将 Array[Person]保存到文件。将这个数组从文件中重新读出来，检验朋友关系是否完好。

根据题意，编码如下：

```scala
package excercises.chapter9

import scala.collection.mutable.ArrayBuffer

object SerializablePerson extends App {
  @SerialVersionUID(42L) class Person(val name: String) extends Serializable {
    private val friends = new ArrayBuffer[Person]
    def addFriend(p: Person) {friends += p}
    def isFriend(p: Person) = friends.contains(p)
  }

  val Paul = new Person("Paul")
  val Pierre = new Person("Pierre")
  val Simon = new Person("Simon")

  Paul.addFriend(Pierre)
  Pierre.addFriend(Paul)
  Simon.addFriend(Paul)
  Simon.addFriend(Pierre)

  val persons = Array(Paul, Pierre, Simon)

  import java.io._

  val dir = new File("src/main/scala/excercises/chapter9")
  val path: String = dir.getAbsolutePath()
  val fileName: String = "test.obj"
  val out = new ObjectOutputStream(new FileOutputStream(path + "/" + fileName))
  out.writeObject(persons)
  out.close()

  val in = new ObjectInputStream(new FileInputStream(path + "/" + fileName))
  val test = in.readObject().asInstanceOf[Array[Person]]
  assert(test(2).isFriend(test(0)) == true)
}
```

测试结果如下：

```scala
[info] Running excercises.chapter9.SerializablePerson 
[success] Total time: 2 s, completed May 3, 2019 3:29:40 PM
```

需要说明的是，被反序列化出来的 test 对象其实是一个 Array[Person]的以 Person 对象的数组。本段代码最后采用 assert()函数测试反序列化出来的内容是否与序列化之前的内容是否一致。

