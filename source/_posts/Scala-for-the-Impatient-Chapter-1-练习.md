---
title: Scala for the Impatient Chapter 1 练习
date: 2019-04-20 12:15:54
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala
---


#### 1 在 Scala REPL 中键入3.，然后按 Tab 键。有哪些方法可以被应用？
```scala
scala> 3.
!=   +   <<   >=    abs         compareTo     getClass     isNaN           isValidChar    isWhole     round        to               toDegrees     toInt           toShort   underlying   
%    -   <=   >>    byteValue   doubleValue   intValue     isNegInfinity   isValidInt     longValue   self         toBinaryString   toDouble      toLong          unary_+   until        
&    /   ==   >>>   ceil        floatValue    isInfinite   isPosInfinity   isValidLong    max         shortValue   toByte           toFloat       toOctalString   unary_-   |            
*    <   >    ^     compare     floor         isInfinity   isValidByte     isValidShort   min         signum       toChar           toHexString   toRadians       unary_~                 
```
#### 2 在 Scala REPL 中，计算3的平方根，然后再对该值求平方。现在，这个结果与3相差多少？（提示：res 变量是你的朋友）
```scala
scala> import scala.math._
import scala.math._

scala> sqrt(3)
res0: Double = 1.7320508075688772

scala> res0 * res0
res2: Double = 2.9999999999999996

scala> 3 - res2
res3: Double = 4.440892098500626E-16
```
#### 3 res 变量是 val 还是 var？
```scala
scala> res2 = 10
<console>:15: error: reassignment to val
       res2 = 10
            ^
```
显然，根据提示，显然 res 变量是 val 变量。
#### 4 Scala 允许你用数字去乘字符串--去 REPL 中试一下`“crazy” * 3`。这个操作做什么?在Scaladoc如何找到这个操作？
```scala
scala> "crazy" * 3
res4: String = crazycrazycrazy
```
这个操作将会将`crazy`重复3次，然后连接起来形成一个新的字符串。
这个操作在`StringOps`类当中。
![StringOps](https://i.imgur.com/xG5Ibpo.png)
#### 5 10 max 2的含义是什么？max 方法定义在哪个类当中？
```scala
scala> 10 max 2
res5: Int = 10
```
这段表达式的含义是比较两个参数，求最大值的方法。这个方法定义在`Int`的文档当中。
#### 6 用 BigInt 计算2的1024次方。
```scala
scala> BigInt(2).pow(1024)
res6: scala.math.BigInt = 179769313486231590772930519078902473361797697894230657273430081157732675805500963132708477322407536021120113879871393357658789768814416622492847430639474124377767893424865485276302219601246094119453082952085005768838150682342462881473913110540827237163350510684586298239947245938479716304835356329624224137216
```
#### 7 为了在使用`probablePrime(100, Random)`获取随机素数时不在 `probablePrime` 和 `Random` 之前使用任何限定符，你需要引入什么？
首先，`Random`在`scala.util`当中，所以需要引入` scala.util`；其次，`probablePrime`在`scala.math.BigInt`当中，所以需要引入`scala.math.BigInt`。代码如下：
```scala
scala> import scala.util._
import scala.util._

scala> import scala.math.BigInt._
import scala.math.BigInt._

scala> probablePrime(100, Random)
res9: scala.math.BigInt = 847489671473680176573889558451
```

#### 8 创建随机文件的方式之一是生成一个随机的` BigInt`，然后将它转换成三十六进制，输出类似"qsnvbevtomcjo06kul"这样的字符串。查阅 Scaladoc，找到在Scala中实现该逻辑的办法。

```scala
scala> val x: BigInt = probablePrime(100, Random)
x: scala.math.BigInt = 947500734886409682992040442693

scala> x.toString(30)
res10: String = 2lfjsf9m1f7bhi294iigd

```
首先，通过` probablePrime(100,Random)`获得一个随机数，然后通过调用 `toString()`方法进行进制转换。

#### 9 在 Scala 中如何获取字符串的首字符和尾字符。

```scala
scala> val string: String = "Hello, World"
string: String = Hello, World

scala> string.head
res11: Char = H

scala> string.last
res13: Char = d
```
#### 10 take、drop、takeRight 和dropRight这些字符串函数式做什么用的？和 substring 相比，他们的优点和缺点都有哪些？

```scala
abstract def take(n: Int): Repr
Selects first n elements.

Note: might return different results for different runs, unless the underlying collection type is ordered.
n
the number of elements to take from this general collection.
returns
a general collection consisting only of the first n elements of this general collection, or else the whole general collection, if it has less than n elements. If n is negative, returns an empty general collection.

abstract def drop(n: Int): Repr
Selects all elements except first n ones.

Note: might return different results for different runs, unless the underlying collection type is ordered.
n
the number of elements to drop from this general collection.
returns
a general collection consisting of all elements of this general collection except the first n ones, or else the empty general collection, if this general collection has less than n elements. If n is negative, don't drop any elements.

def takeRight(n: Int): Repr
Selects last n elements.
n
the number of elements to take
returns
a sequence consisting only of the last n elements of this sequence, or else the whole sequence, if it has less than n elements.
Definition Classes
IndexedSeqOptimized → IterableLike

def dropRight(n: Int): Repr
Selects all elements except last n ones.
n
The number of elements to take
returns
a sequence consisting of all elements of this sequence except the last n ones, or else the empty sequence, if this sequence has less than n elements.
Definition Classes
IndexedSeqOptimized → IterableLike

def substring(start: Int, end: Int): String
Returns a new String made up of a subsequence of this sequence, beginning at the start index (inclusive) and extending to the end index (exclusive).

target.substring(start, end) is equivalent to target.slice(start, end).mkString
start
The beginning index, inclusive.
end
The ending index, exclusive.
returns
The new String.
Exceptions thrown
StringIndexOutOfBoundsException If either index is out of bounds, or if start > end.
```
查询API即可知道，`take`是从字符串首开始获取字符串，`drop`是从字符串首开始去除字符串。 `takeRight`和`dropRight`是从字符串尾开始操作。 这四个方法都是单方向的。 如果我想要字符串中间的子字符串，那么需要同时调用`drop`和`dropRight`，或者使用`substring`。显然，`substring`是双向的。