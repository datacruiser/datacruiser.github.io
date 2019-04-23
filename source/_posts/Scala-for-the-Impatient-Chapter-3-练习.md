---
title: Scala for the Impatient Chapter 3 练习
date: 2019-04-20 23:11:48
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第三章练习。
---

#### 1 编写一段代码，将 a 设置为一个 n 个随机整数的数组，要求随机数介于0（包含）和 n（不包含）之间。

代码如下：

```scala
def createArray(n: Int): Array[Int] = {
val arr=new Array[Int](n)
val rand=new Random()
for(element <- arr)
yield rand.nextInt(n)
}
```
测试结果如下：

```scala
scala> def createArray(n: Int): Array[Int] = {
     | val arr=new Array[Int](n)
     | val rand=new Random()
     | for(element <- arr)
     | yield rand.nextInt(n)
     | }
createArray: (n: Int)Array[Int]

scala> createArray(10)
res57: Array[Int] = Array(1, 3, 7, 9, 5, 9, 9, 1, 5, 6)
```

#### 2 编写一个循环，将整数数组中相邻的元素置换。例如，`Array(1, 2, 3, 4, 5)`置换后变为`Array(2, 1, 4, 3, 5)`。


代码如下：

```scala
def swap(arr: Array[Int]) = {
	for(i <- 0 until (arr.length - 1, 2)){
		val t = arr(i)
		arr(i) = arr(i + 1)
		arr(i + 1) = t
	}
}
```

测试结果如下：

```scala
scala> def swap(arr: Array[Int]) = {
     |   for(i <- 0 until (arr.length - 1, 2)){
     |           val t = arr(i)
     |           arr(i) = arr(i + 1)
     |           arr(i + 1) = t
     |   }
     | }
swap: (arr: Array[Int])Unit

scala> val ts = Array(1,2, 3, 4 ,5 ,6)
ts: Array[Int] = Array(1, 2, 3, 4, 5, 6)

scala> ts
res62: Array[Int] = Array(1, 2, 3, 4, 5, 6)

scala> swap(ts)

scala> ts
res64: Array[Int] = Array(2, 1, 4, 3, 6, 5)
```
#### 3 重复前一个练习，不过这一次生成一个新的值交换过的数组。用 for/yield。

实现代码如下：

```scala
def swapYield(arr:Array[Int]) = {
	for(i <- 0 until arr.length) yield {
		if(i < (arr.length - 1) && i % 2 == 0) arr(i+1)
		else if(i <= (arr.length - 1) && i % 2 == 1) arr(i-1)
		else if(i == (arr.length - 1) && i % 2 == 0) arr(i)
	}
}
```
这里面有个坑，对于数组内元素个数的奇偶性需要做一个判断，以避免最后元素的处理发生错误。

测试结果如下：

```scala
scala> def swapYield(arr: Array[Int]) = {
     |   for(i <- 0 until arr.length) yield {
     |           if(i < (arr.length - 1) && i % 2 == 0) arr(i+1)
     |           else if(i <= (arr.length - 1) && i % 2 == 1) arr(i-1)
     |           else if(i == (arr.length - 1) && i % 2 == 0) arr(i)
     |   }
     | }
swapYield: (arr: Array[Int])scala.collection.immutable.IndexedSeq[AnyVal]

scala> e
res83: Array[Int] = Array(1, 2, 3, 4, 5, 6, 7, 8)

scala> a
res84: Array[Int] = Array(2, 3, 5, 7, 111)

scala> swapYield(a)
res85: scala.collection.immutable.IndexedSeq[AnyVal] = Vector(3, 2, 7, 5, 111)

scala> swapYield(e)
res86: scala.collection.immutable.IndexedSeq[AnyVal] = Vector(2, 1, 4, 3, 6, 5, 8, 7)
```
#### 4 给定一个整数数组，产出一个新的数组，包含原数组中的所有正值，以原有顺序排列，之后的元素是所有0或负值，以原有顺序排列。

代码如下：

```scala
def signArr(arr: Array[Int]): Array[Int] = {
    val buff = new ArrayBuffer[Int]()
    buff ++= (for(ele <- arr if ele > 0) yield ele)
    buff ++= (for(ele <- arr if ele == 0) yield ele)
    buff ++= (for(ele <- arr if ele < 0) yield ele)
    buff.toArray
}
```

测试结果如下：

```scala
scala> def signArr(arr: Array[Int]): Array[Int] = {
     |     val buff = new ArrayBuffer[Int]()
     |     buff ++= (for(ele <- arr if ele > 0) yield ele)
     |     buff ++= (for(ele <- arr if ele == 0) yield ele)
     |     buff ++= (for(ele <- arr if ele < 0) yield ele)
     |     buff.toArray
     | }
signArr: (arr: Array[Int])Array[Int]

scala> val t = Array(3,5,6,-10,0,9,10,12,13,-100)
t: Array[Int] = Array(3, 5, 6, -10, 0, 9, 10, 12, 13, -100)

scala> signArr(t)
res87: Array[Int] = Array(3, 5, 6, 9, 10, 12, 13, 0, -10, -100)
```
#### 5 如何计算 Array[Double]的平均值？
计算平均值可以分两步，首先使用` sum`函数进行求和，然后将求和的值除以` Array.length`，代码如下：

```scala
def arrAvg(arr: Array[Double]): Double = {
arr.sum / arr.length
}
```
测试结果如下：

```scala
scala> def arrAvg(arr: Array[Double]): Double = {
     | arr.sum / arr.length
     | }
arrAvg: (arr: Array[Double])Double

scala> val arr = Array(10.0, 100, 20, 15, 25)
arr: Array[Double] = Array(10.0, 100.0, 20.0, 15.0, 25.0)

scala> arrAvg(arr)
res90: Double = 34.0
```
#### 6 如果重新组织 Array[Int]的元素将它们以反序排列？对于 ArrayBuffer[Int]你又会怎么做呢？
对于 Array 的反转可以将 Array 头尾的元素互换，对于 ArrayBuffer 的反转，查询了ScalaDoc，可以直接调用` reverse`函数。

```scala
abstract def reverse: Repr
Returns new general sequence with elements in reversed order.

Note: will not terminate for infinite-sized collections.
returns
A new general sequence with all elements of this general sequence in reversed order.
```
实现代码如下：
```scala
// Array的反转
def revertArr(arr:Array[Int]) = {
	for(i <- 0 until (arr. length / 2)) {
		val t = arr(i)
		arr(i) = arr(arr.length-1-i)
		arr(arr.length-1-i) = t
	}
}

// ArrayBuffer的反转，直接调用reverse函数
import scala.collection.mutable.ArrayBuffer
def revertBuf(arr:ArrayBuffer[Int]) = {
	arr.reverse
}
```

测试结果如下：

```scala
scala> def revertArr(arr:Array[Int]) = {
     |   for(i <- 0 until (arr. length / 2)) {
     |           val t = arr(i)
     |           arr(i) = arr(arr.length-1-i)
     |           arr(arr.length-1-i) = t
     |   }
     | }
revertArr: (arr: Array[Int])Unit

scala> import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.ArrayBuffer

scala> def revertBuf(arr:ArrayBuffer[Int]) = {
     |   arr.reverse
     | }
revertBuf: (arr: scala.collection.mutable.ArrayBuffer[Int])scala.collection.mutable.ArrayBuffer[Int]

scala> a
res91: Array[Int] = Array(2, 3, 5, 7, 111)

scala> revertArr(a)

scala> a
res95: Array[Int] = Array(111, 7, 5, 3, 2)

scala> val ab = new ArrayBuffer[Int]()
ab: scala.collection.mutable.ArrayBuffer[Int] = ArrayBuffer()

scala> ab ++= a
res99: ab.type = ArrayBuffer(111, 7, 5, 3, 2)

scala> ab
res100: scala.collection.mutable.ArrayBuffer[Int] = ArrayBuffer(111, 7, 5, 3, 2)

scala> revertBuf(ab)
res101: scala.collection.mutable.ArrayBuffer[Int] = ArrayBuffer(2, 3, 5, 7, 111)
```

#### 7 编写一段代码，产生数组中的所有值，去掉重复项。（提示：查看 Scaladoc）

查看 Scaladoc，发现有一个去重函数` distinct`：

```scala
def distinct: Array[T]
Builds a new sequence from this sequence without any duplicate elements.

Note: will not terminate for infinite-sized collections.
returns
A new sequence which contains the first occurrence of every element of this sequence.
Definition Classes
SeqLike → GenSeqLike
```
然后编写代码如下：

```scala
def removeDuplicate(arr: Array[Int]): Array[Int] = {
    val b = new ArrayBuffer[Int]()
    b ++= arr.distinct
    b.toArray
}
```
测试结果如下：

```scala
scala> def removeDuplicate(arr: Array[Int]): Array[Int] = {
     |     val b = new ArrayBuffer[Int]()
     |     b ++= arr.distinct
     |     b.toArray
     | }
removeDuplicate: (arr: Array[Int])Array[Int]

scala> val rd = Array(1, 1, 2, 2, 3 , 4, 5, 7, 10,11,10)
rd: Array[Int] = Array(1, 1, 2, 2, 3, 4, 5, 7, 10, 11, 10)

scala> removeDuplicate(rd)
res102: Array[Int] = Array(1, 2, 3, 4, 5, 7, 10, 11)
```

不过从 ScalaDoc 来看，`distinct`函数是支持泛型的，但是我们写的` removeDuplicate`只支持` Int`类型，后面还需要改进。

#### 8 重新编写3.4节结尾的示例。收集负值元素的下标，反序，去掉最后一个下标，然后对每一个下标调用` a.remove(i)`。比较这样做的效率和3.4节中另外两种方法的效率。

代码如下：

```scala
def removeRevLast(arr: Array[Int]): Array[Int] = {
    val indexes = for (i <- 0 until arr.length if arr(i) < 0) yield i //收集所有负值元素的下标
    val dropIndexes = indexes.reverse.dropRight(1) //反序并将最后一个下标去除
    val tmp = arr.toBuffer //调用 toBuff定义一个 ArrayBuffer并拷贝原数组
    for (index <- dropIndexes)
        tmp.remove(index) //对每一个需要被删除的下标删除元素
    tmp.toArray //返回处理后的数组
}
```
测试结果如下：

```scala
scala> def removeRevLast(arr: Array[Int]): Array[Int] = {
     |     val indexes = for (i <- 0 until arr.length if arr(i) < 0) yield i //收集所有负值元素的下标
     |     val dropIndexes = indexes.reverse.dropRight(1) //反序并将最后一个下标去除
     |     val tmp = arr.toBuffer //调用 toBuff定义一个 ArrayBuffer并拷贝原数组
     |     for (index <- dropIndexes)
     |         tmp.remove(index) //对每一个需要被删除的下标删除元素
     |     tmp.toArray //返回处理后的数组
     | }
removeRevLast: (arr: Array[Int])Array[Int]

scala> val rrl = Array(-1, -2, -3, 3, 2, 1,23)
rrl: Array[Int] = Array(-1, -2, -3, 3, 2, 1, 23)

scala> removeRevLast(rrl)
res103: Array[Int] = Array(-1, 3, 2, 1, 23)
```
#### 9 创建一个用` java.TimeZone.getAvailableIDs`返回的时区集合，判断条件是他们在美洲。去掉"America/" 前缀并排序。

代码如下：

```scala
val americaTimeZone = java.util.TimeZone.getAvailableIDs
val filteredTimeZone = java.util.TimeZone.getAvailableIDs.filter(_.take("America/".length)=="America/")
val sortedTimeZone = filteredTimeZone.map(_.drop("America/".length)).sorted
```
测试结果如下：

```scala
scala> val americaTimeZone = java.util.TimeZone.getAvailableIDs
americaTimeZone: Array[String] = Array(Africa/Abidjan, Africa/Accra, Africa/Addis_Ababa, Africa/Algiers, Africa/Asmara, Africa/Asmera, Africa/Bamako, Africa/Bangui, Africa/Banjul, Africa/Bissau, Africa/Blantyre, Africa/Brazzaville, Africa/Bujumbura, Africa/Cairo, Africa/Casablanca, Africa/Ceuta, Africa/Conakry, Africa/Dakar, Africa/Dar_es_Salaam, Africa/Djibouti, Africa/Douala, Africa/El_Aaiun, Africa/Freetown, Africa/Gaborone, Africa/Harare, Africa/Johannesburg, Africa/Juba, Africa/Kampala, Africa/Khartoum, Africa/Kigali, Africa/Kinshasa, Africa/Lagos, Africa/Libreville, Africa/Lome, Africa/Luanda, Africa/Lubumbashi, Africa/Lusaka, Africa/Malabo, Africa/Maputo, Africa/Maseru, Africa/Mbabane, Africa/Mogadishu, Africa/Monrovia, Africa/Nairobi, Africa/Ndjamena, A...

scala> val filteredTimeZone = java.util.TimeZone.getAvailableIDs.filter(_.take("America/".length)=="America/")
filteredTimeZone: Array[String] = Array(America/Adak, America/Anchorage, America/Anguilla, America/Antigua, America/Araguaina, America/Argentina/Buenos_Aires, America/Argentina/Catamarca, America/Argentina/ComodRivadavia, America/Argentina/Cordoba, America/Argentina/Jujuy, America/Argentina/La_Rioja, America/Argentina/Mendoza, America/Argentina/Rio_Gallegos, America/Argentina/Salta, America/Argentina/San_Juan, America/Argentina/San_Luis, America/Argentina/Tucuman, America/Argentina/Ushuaia, America/Aruba, America/Asuncion, America/Atikokan, America/Atka, America/Bahia, America/Bahia_Banderas, America/Barbados, America/Belem, America/Belize, America/Blanc-Sablon, America/Boa_Vista, America/Bogota, America/Boise, America/Buenos_Aires, America/Cambridge_Bay, Ameri...

scala> val sortedTimeZone = filteredTimeZone.map(_.drop("America/".length)).sorted
sortedTimeZone: Array[String] = Array(Adak, Anchorage, Anguilla, Antigua, Araguaina, Argentina/Buenos_Aires, Argentina/Catamarca, Argentina/ComodRivadavia, Argentina/Cordoba, Argentina/Jujuy, Argentina/La_Rioja, Argentina/Mendoza, Argentina/Rio_Gallegos, Argentina/Salta, Argentina/San_Juan, Argentina/San_Luis, Argentina/Tucuman, Argentina/Ushuaia, Aruba, Asuncion, Atikokan, Atka, Bahia, Bahia_Banderas, Barbados, Belem, Belize, Blanc-Sablon, Boa_Vista, Bogota, Boise, Buenos_Aires, Cambridge_Bay, Campo_Grande, Cancun, Caracas, Catamarca, Cayenne, Cayman, Chicago, Chihuahua, Coral_Harbour, Cordoba, Costa_Rica, Creston, Cuiaba, Curacao, Danmarkshavn, Dawson, Dawson_Creek, Denver, Detroit, Dominica, Edmonton, Eirunepe, El_Salvador, Ensenada, Fort_Nelson, Fort_Wayne,...
```
#### 10 引入` java.awt.datatransfer._`并构建一个类型为` SystemFlavorMap`类型的对象，然后以DataFlavor.imageFlavor为参数调用getNativesForFlavor方法，以Scala缓冲保存返回值。 (为什么用这样一个晦涩难懂的类？因为在Java标准库中很难找到使用java.util.List的代码) 
```scala
scala> val flavors = SystemFlavorMap.getDefaultFlavorMap().asInstancesOf[SystemFlavorMap]
<console>:14: error: value asInstancesOf is not a member of java.awt.datatransfer.FlavorMap
       val flavors = SystemFlavorMap.getDefaultFlavorMap().asInstancesOf[SystemFlavorMap]
                                                           ^
//说明一下，整条语句无法执行，提示java.awt.datatransfer.FlavorMap当中没有 asInstancesOf这个成员，翻阅了 javaDoc，确实没有这个方法，这个方法是在 Scala 的抽象类 Any 当中，代码如下：

final def asInstanceOf[T0]: T0
Cast the receiver object to be of type T0.

Note that the success of a cast at runtime is modulo Scala's erasure semantics. Therefore the expression 1.asInstanceOf[String] will throw a ClassCastException at runtime, while the expression List(1).asInstanceOf[List[String]] will not. In the latter example, because the type argument is erased as part of compilation it is not possible to check whether the contents of the list are of the requested type.
returns
the receiver object.
Exceptions thrown
ClassCastException if the receiver object is not an instance of the erasure of type T0.
//然后，将对象的创建和asInstanceOf方法调用分两步执行就可以了

scala> val flavors = SystemFlavorMap.getDefaultFlavorMap()
flavors: java.awt.datatransfer.FlavorMap = java.awt.datatransfer.SystemFlavorMap@30364216

scala> val systemflavors = flavors.asInstanceOf[SystemFlavorMap]
systemflavors: java.awt.datatransfer.SystemFlavorMap = java.awt.datatransfer.SystemFlavorMap@30364216

scala> println(systemflavors.getNativesForFlavor(DataFlavor.imageFlavor).toArray.toBuffer.mkString(","))
PNG,JFIF,TIFF

scala> systemflavors.getNativesForFlavor(DataFlavor.imageFlavor).toArray
res2: Array[Object] = Array(PNG, JFIF, TIFF)

scala> systemflavors.getNativesForFlavor(DataFlavor.imageFlavor).toArray.mkString(",")
res3: String = PNG,JFIF,TIFF

scala> systemflavors.getNativesForFlavor(DataFlavor.imageFlavor).toBuffer
<console>:16: error: value toBuffer is not a member of java.util.List[String]
       systemflavors.getNativesForFlavor(DataFlavor.imageFlavor).toBuffer
                                                                 ^
```
需要说明两点，首先，创建对象和类型转换需要分两步完成，另外，`java.util.List[String]`当中没有` toBuffer`方法，只有`toArray`方法，根据题意以` Scala`缓存保存返回值，则需要先调用` toArray`，然后再调用` toBuffer`。

