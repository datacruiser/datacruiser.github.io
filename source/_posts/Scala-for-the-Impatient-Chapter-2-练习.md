---
title: Scala for the Impatient Chapter 2 练习
date: 2019-04-20 19:52:02
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第二章练习。
---

#### 1 一个数字如果为正数，则它的` signum`为1；如果是负数，则` signum`为-1；如果是0，则` signum`为0。编写一个函数来计算这个值。
函数判断逻辑编写如下：
```scala
def signum(num: Int): Int = {
if (num > 0)
1
else if (num < 0)
-1
else
0
}
```
测试结果如下：

```scala
scala> def signum(num: Int): Int = {
     | if (num > 0)
     | 1
     | else if (num < 0)
     | -1
     | else
     | 0
     | }
signum: (num: Int)Int

scala> si
signum   sin   sinh

scala> signum(-1000)
res15: Int = -1

scala> signum(100)
res16: Int = 1

scala> signum(0)
res17: Int = 0
```
翻阅`ScalaDoc`，其实已经有`signum`函数的API了。

```scala
Signs
Extract the sign of a value. Results are -1, 0 or 1. Note that these are not pure forwarders to the java versions. In particular, the return type of java.lang.Long.signum is Int, but here it is widened to Long so that each overloaded variant will return the same numeric type it is passed.
def signum(x: Double): Double
def signum(x: Float): Float
def signum(x: Long): Long
def signum(x: Int): Int
```
#### 2 一个空的块表达式`{}`的值是什么？类型是什么？
用 REPL 的结果来回答这个问题：

```scala
scala> val test = {}
test: Unit = ()
```
显而易见，值依然是`{}`，类型是` Unit`。

#### 3 指出在 `Scala`中何种情况下赋值语句` x = y = 1`是合法的。（提示：给 x 找一个合适的类型定义）

由于在scala中的赋值语句是Unit类型，所以只要x为Unit类型就可以了。测试如下：


```scala
scala> var x = 10
x: Int = 10

scala> var x = {}
x: Unit = ()

scala> var y = 0
y: Int = 0

scala> x = y = 0
x: Unit = ()
```
#### 4 针对下列`Java`循环编写一个` Scala`版本：

```java
for (int i = 10; i >= 0; i--) System.out.println(i);
```

代码如下：

```scala
import scala.language.postfixOps
for(i <- 0 to 10 reverse)
print(i + "\t")
```
测试结果如下：

```scala
scala> for(i <- 0 to 10 reverse)
     | print(i + "\t")
<console>:33: warning: postfix operator reverse should be enabled
by making the implicit value scala.language.postfixOps visible.
This can be achieved by adding the import clause 'import scala.language.postfixOps'
or by setting the compiler option -language:postfixOps.
See the Scaladoc for value scala.language.postfixOps for a discussion
why the feature should be explicitly enabled.
       for(i <- 0 to 10 reverse)
                        ^
10      9       8       7       6       5       4       3       2       1       0

scala> import scala.language.postfixOps
import scala.language.postfixOps

scala> for(i <- 0 to 10 reverse)
     | print(i + "\t")
10      9       8       7       6       5       4       3       2       1       0   
```

#### 5 编写一个过程` countdown(n: Int)`，打印从$n$到0的数字。

过程代码如下：
```scala
def countdown(n: Int){
for(i <- 0 to n reverse) 
print(i + "\t")
}
```
测试结果如下：

```scala
scala> def countdown(n: Int){
     | for(i <- 0 to n reverse) 
     | print(i + "\t")
     | }
countdown: (n: Int)Unit

scala> countdown(10)
10      9       8       7       6       5       4       3       2       1       0       
scala> countdown(100)
100     99      98      97      96      95      94      93      92      91      90      89      88      87      86      85      84      83      82      81      80      79      78      77      76      7574      73      72      71      70      69      68      67      66      65      64      63      62      61      60      59      58      57      56      55      54      53      52      51      50      4948      47      46      45      44      43      42      41      40      39      38      37      36      35      34      33      32      31      30      29      28      27      26      25      24      2322      21      20      19      18      17      16      15      14      13      12      11      10      9       8       7       6       5       4       3       2       1       0       
```

#### 6 编写一个` for`循环，计算字符串中所有字母的 Unicode 代码的乘积。举例来说，"Hello"中所有字符的乘积为9415087488L。


函数代码如下：

```scala
def stringMultify(s: String): BigInt = {
var multify: BigInt = 1
for(ch <- s) 
multify *= ch
multify
}
```
为了能够确保在计算长字符串时数据不会发生溢出，将函数返回的类型定义为`BigInt`。测试结果如下：


```scala
scala> def stringMultify(s: String): BigInt = {
     | var multify: BigInt = 1
     | for(ch <- s) 
     | multify *= ch
     | multify
     | }
stringMultify: (s: String)scala.math.BigInt

scala> stringMultify("Hello")
res27: scala.math.BigInt = 9415087488

scala> stringMultify("String")
res28: scala.math.BigInt = 1305750322800

scala> stringMultify("I love Scala!")
res29: scala.math.BigInt = 2942844963640450600697856

```

#### 7 同样是解决前一个练习的问题，但这次不使用循环。（提示：在 `Scaladoc `中查看 `StringOps`）

查看` StringOps`，里面有一个`foreach`方法，将以上函数修改如下：

```scala
def stringMultify_foreach(s: String): BigInt = {
var multify: BigInt = 1
s.foreach(multify *=_)
multify
}
```

测试结果如下：

```scala
scala> def stringMultify_foreach(s: String): BigInt = {
     | var multify: BigInt = 1
     | s.foreach(multify *=_)
     | multify
     | }
stringMultify_foreach: (s: String)scala.math.BigInt

scala> stringMultify_foreach("Hello,world")
res30: scala.math.BigInt = 6737140174266257817600

scala> stringMultify_foreach("Hello")
res31: scala.math.BigInt = 9415087488
```

#### 8 编写一个函数`product(s: String)`，计算前面练习中提到的乘积。
前面编写的两个函数也可以解答本题。

#### 9 把前一个练习的函数改成递归函数。
递归函数代码如下：

```scala
def stringMultify_recurr(s: String): BigInt = {

if(s.length==1)

s.charAt(0).toLong

else

s.charAt(0)*stringMultify_recurr(s.drop(1))

}
```

测试结果如下：

```scala
scala> def stringMultify_recurr(s: String): BigInt = {
     | 
     | if(s.length==1)
     | 
     | s.charAt(0).toLong
     | 
     | else
     | 
     | s.charAt(0)*stringMultify_recurr(s.drop(1))
     | 
     | }
stringMultify_recurr: (s: String)scala.math.BigInt

scala> stringMultify_recurr("Hello")
res32: scala.math.BigInt = 9415087488

scala> stringMultify_recurr("I love Scala")
res33: scala.math.BigInt = 89177120110316684869632

```

#### 10 编写函数计算$x^n$，其中$n$是整数，使用如下的递归定义：
- $x^n=y^2$，如果$n$是正偶数的话，这里的$y=x^{n/2}$
- $x^n=x*x^{n-1}$，如果$n$是正奇数的话
- $x^0=1$
- $x^n=1/x^{-n}$，如果$n$是负数的话

不得使用`return`语句。

程序代码如下：
```scala
def xn(x: Double, n: Int): Double = {

if (n == 0)

1

else if (n < 0)

1 / xn(x, -n)

else if (n % 2 == 0)

xn(x, n / 2) * xn(x, n / 2)

else

x * xn(x, n - 1)

}
```

测试结果如下：

```scala
scala> def xn(x: Double, n: Int): Double = {
     | 
     | if (n == 0)
     | 
     | 1
     | 
     | else if (n < 0)
     | 
     | 1 / xn(x, -n)
     | 
     | else if (n % 2 == 0)
     | 
     | xn(x, n / 2) * xn(x, n / 2)
     | 
     | else
     | 
     | x * xn(x, n - 1)
     | 
     | }
xn: (x: Double, n: Int)Double

scala> xn(2, 3)
res42: Double = 8.0

scala> xn(2, 0)
res43: Double = 1.0

scala> xn(2, -4)
res46: Double = 0.0625
```