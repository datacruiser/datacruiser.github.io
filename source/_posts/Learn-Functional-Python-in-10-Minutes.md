---
title: Learn Functional Python in 10 Minutes
date: 2018-08-18 23:10:47
categories: 函数式编程
tags: 
- python
- 翻译
- 函数式编程
- 入门
description: 一篇基于python的函数式编程入门文章。
---

最近在学习`python`，对**函数式编程**特别感兴趣，当然，这并不是`python`的专利，不过最近确实看到一遍文章正好以`python`为例来讲解**函数式编程**，特把它翻译过来与大家分享。

## 原文链接如下：

- [Learn Functional Python in 10 Minutes](https://hackernoon.com/learn-functional-python-in-10-minutes-to-2d1651dece6f)

在这篇文章当中，你将会学习什么是**函数式编程**以及如果用`python`进行实现。你也会学习列表领域能力以及其它形式的领悟能力。

## 函数式编程
在命令式的编程范式当中，你通过告诉计算机一系列需要执行的任务并在计算机执行以后以完成你的目的。当执行任务的时候，状态可能会发生改变。比如，假设你原先将A赋值为5，然后你改变A的数值。你会有很多变量，并且变量内部的值也会发生改变。

**在一个函数式编程范式当中，你并不告诉计算机要干什么，而是告诉它是干什么的。**什么是一个数字的最大公因子，什么是从1到N的乘积，等等。

正因为如此，变量不能变化。当时设置好了一个变量，它将永远保持那样的方式（注意下，在纯粹的函数式编程语言当中通常不称之为变量）。因此，在函数式编程范式当中，函数不会有*副作用*。函数的副作用是指函数修改了一些函数作用范围外的东西。让我来看一个典型`python`的例子：

```python
a = 3
def som_func():
	global a
	a = 5
some_func()
print(a)
```
这段代码的输出是5.在函数式编程范式当中，改变变量的值是不容许的事情，同样影响在函数作用域之外的变量也是不被容许的。函数唯一可以做的事情是做一些计算然后以结果的形式返回。

现在你可能会想：“无变量，无副作用？为什么这样是好的呢？”这是个非常好的问题，非常少的默认人多这个。

如果一个函数用同样的参数调用两次，应该确保返回同样的结果。如果你学习了[*数学函数*](https://medium.com/brandons-computer-science-notes/a-primer-on-functions-9a51c1e9de80)，你会了解这种机制的好处。这个叫做[*参考透明（referengtial transparency）*](https://medium.com/brandons-computer-science-notes/a-primer-on-functions-9a51c1e9de80)，因为函数没有副作用，如果你构建一个用来计算的程序，你可以提供程序的运算速度。如果程序知道func(2)等于3，我们可以将这个结果保存到一个表格当中。当我们已经知道函数运行结果的时候，这样可以防止重新运行同样的函数。

典型的，在函数式编程当中，我们不使用循环。我们采用递归。递归是一个数学上的概念，通常，它意味着“自己调用自己”。在一个递归的函数当中，函数重复地以子函数的形式调用自己。这里有一个非常的`python`编写的递归函数的例子：

```python
def factorial_recursive(n):
    # Base case: 1! = 1
    if n == 1:
        return 1

    # Recursive case: n! = n * (n-1)!
    else:
        return n * factorial_recursive(n-1)
```

一些编程语言也非常**懒惰**。这意味着他们不计算或者干其它任何事情直到最后一秒。如果你写一些代码用来计算`2 + 2`，一个函数式的程序将只有当你实际需要使用这个结果的时候才会去进行计算。我们将很快来解释`python`的懒惰性。

## Map
要理解map，让我们首先看看什么是可迭代的。可迭代的就是任何你可以迭代的东西（翻译起来好拗口……）。典型的有列表（list）和数组（array），不过`python`有很多不同可迭代的类型。你甚至可以通过实现一些神奇的方法创建自己的可迭代的对象。一个神奇的方法像一个可以让你的对象更加**Pythonic**的API。你需要实现两个神奇方法来使得一个对象是可迭代的：

```python
class Counter:
    def __init__(self, low, high):
        # set class attributes inside the magic method __init__
        # for "inistalise"
        self.current = low
        self.high = high

    def __iter__(self):
        # first magic method to make this object iterable
        return self
    
    def __next__(self):
        # second magic method
        if self.current > self.high:
            raise StopIteration
        else:
            self.current += 1
            return self.current - 1
```

第一个神奇方法，“\_\_iter\_\_”或者dunder iter（双下划线开头的iter）返回可迭代的对象，这个经常在循环的开头使用。Dunder下一个返回下一个对象。

让我们进入一个快捷终端会话来验证一下：

```python
for c in Counter(3, 8):
	print(c)
```
这段代码将会打印：

```python
3
4
5
6
7
8
```

在`python`里面，一个迭代器是指只有\_\_iter\_\_方法的对象。这意味着你可以访问这个对象的位置，但是不能迭代遍历这个对象。一些对象会有\_\_next\_\_方法而没有\_\_iter\_\_方法，比如sets（将会在文章后面的内容中讲到）。对于本文，我们假设我们所接触到的每个对象都是一个可迭代的对象。

到目前为止，我们知道一个可迭代的对象是怎么样的，让我们回到map函数。map函数允许我们将一个函数作用于一个可迭代对象当中没一个元素。通常我们要将一个函数作用于列表中的每一个元素，并且我们知道对于大部分可迭代对象都是可能的。Map函数有两个输入，一个是需要作用的函数，另外一个是可迭代的对象。

```python
map(function, iterable)
```

让我们假设我们有一个包含以下数字的列表：

```python
[1, 2, 3, 4, 5]
```

然后我们需要将每一个数字进行平方处理，我们可以编写代码如下：

```python
x = [1, 2, 3, 5, 5]
def square(num):
	return num * num

print(list(map(square, x)))

```

`python`当中的函数式函数是懒惰的。加入我们没有包括“list()”函数，map将返回保存对应迭代对象的定义类型数据，而不是list本身。我们需要显式地告诉`python`将这些转换为list为我们所用。

如果突然从非懒惰模式切换到懒惰模式会有点怪异，如果你更多地以函数式进行思考最终会习惯这种懒惰模式。

现在可以很好的很好地写一个常规的“square(num)”函数，但是看起来离正常工作还差一点，我们必须定义完整的函数仅仅为了在 map用一次？当然，我们可以通过lambda表达式在map当中定义函数。

## Lambda 表达式

一个lambda表达式是一个单行函数。举个例子，这个lambda表达式将对它的输入进行平方操作：

```python
square = lambda x: x * x
```

现在让我们运行一下：

```python
>>> square(3)
9 
```

我听到你内心肯定在问。“Brandon，哪里是参数？这是怎么一回事？这看起来一定都不像一个函数？”

确实，这看起来有些迷惑人，不过可以解释。来让我们给变量“square”赋一些值。这部分如下：

```python
lambda x:
```

告诉`python`这是一个lambda函数，并且输入被称作x。任何在冒号之后的都是你要对输入进行操作的内容，并且将这部分操作的内容自动返回。

因此，为了简化我们的平方程序到一行代码，我们可以这样做：

```python
x = [1, 2, 3, 4, 5]
print(list(map(lambda num: num * num, x)))
```

因此，在一个lambda表达式当中，所有的参数在左边，然后你要对这些参数进行的操作在右边。这看起来有点复杂，谁也无法否认。事实是那样子编码以致于仅让其他函数式程序员阅读已经成为一种确定的让人满足的事情。并且，将一个函数简化到一行看起来也特别酷。

## Reduce

Reduce函数将一个可迭代的对象转变成一个元素。通常你将一个计算作用于一个列表然后将它**reduce**到一个数字。Reduce看起来是这个样子的：

```python
reduce(function, list)
```

我们可以（并且经常如此）使用lambda表达式作为函数。

一个列表的阶乘是将任意一个单一的数字相乘。为了达到这样的目的，你将编码如下：

```python
product = 1
x = [1, 2, 3, 4]
for num in x:
	product = product * num
```

但是通过reduce我们可以这样写：

```python
from functools import reduce

product = reduce((lambda x, y: x * y), [1, 2, 3, 4])
```

得到同样的阶乘结果。代码更加简洁，加入函数式编程的知识代码更为有序。

## Filter

filter函数传入一个迭代对象作为参数并将这个迭代对象当中所有那些你不要的东西滤去。

通常，filter传入一个函数和一个列表。将这个函数作用于列表当中的任意一个元素加入函数返回True，不做任何事情。加入返回False，将这个元素从列表当中删除。

语法看起来这样：

```python
filter(function, list)
```

让我们看一个简单的例子，不使用filter我们这样编码：

```python
x = range(-5, 5)
new_list = []

for num in x:
	if num < 0:
		new_list.append(num)
```

通过filter，编码是这样的：

```python
x = range(-5, 5)
all_less_than_zero = list(filter(lambda num: num < 0, x))
```

## 高阶函数

高阶函数可以传入函数作为参数并返回函数。一个简单的例子看起来是这样的：

```python
def summation(nums):
	return sum(nums)
	
def action(func, numbers):
	return func(numbers)
	
print(action(summations, [1, 2, 3]))

# Output is 6
```

或者一个更简单关于二次定义的例子，“返回函数”，如下所示：

```python
def rtnBrandon():
	return "brandon"
	
def rtnJohn():
	return "john"
	
def rtnPerson():
	age = int(input("What's your age?"))
	
	if age == 21:
		return rtnBrandon()
	else:
		return rtnJohn()
```

你早先应该知道我提到函数式编程语言没有变量是怎么说的吗？确实，高阶函数可以将这个事情变得更为简单。你不需要储存一个变量如果你所要做的是将数据通过函数的通道进行传递。

`Python`中的所有函数都是第一类对象。第一类对象定义为具有1项或者多项以下特征：

- 运行时（runtime）创建

- 将变量或者元素赋值在一个数据结构当中

- 作为一个参数传递给一个函数

- 作为函数的结果返回

因此，所有`Python`中的函数都是第一类且可以作为高阶函数使用。

## 部分应用

部分应用（又叫做闭包）更为复杂，但是超级酷。你可以调用一个函数，但不提供它所需要的全部参数。让我们通过一个例子看看这个过程。我们要创建一个函数需要传入两个参数，一个base和一个exponet，然后返回base的exponent次方。如下所示：

```python
def power(base, exponent):
	return base ** exponent
```

现在我们想要有一个专用的平方函数，通过使用power函数得到一个数字的平方：

```python
def square(base):
	return power(base, 2)
```

这个可以工作，但是如果需要3次方的函数呢？或者一个需要进行4次方运算的函数呢？我们能够一直那样子写吗？当然，你是可以的。但是程序员都是懒惰的。如果你一遍又一遍地重复一件事情，这就意味着有一个更快的方式加速速度而不用去做重复的事情。我们可以采用部分应用的方式。让我看一个采用部分应用的square函数的例子：

```python
from functools import partial

square = partial(power, exponent = 2)
print(square(2))

# output is 4
```

这样是不是很酷！我们可以通过告诉`Python`第二个参数是什么，只用一个参数调用需要两个参数的函数。

我们也可以使用一个循环，来产生一个乘方函数来实现从3次到1000次的计算。

```python
from functools import partial

powers = []
for x in range(2, 1001):
	powers.append(partial(power, exponent = x))
	
print(powers[0](3))
# output is 9
```

## 函数式编程并不是Pythonic

你可能已经注意到了，我们想要在函数式编程当中做的大部分事情都会围绕着列表。除了reduce函数和部分应用，所有其他我们看到的函数都会产生列表。**Guido**（`Python`的发明者）不喜欢`Python`当中的函数式编程的成分，因为`Python`已经有自己的生成列表的方式。

假如你在`Python`的命令行环境当中输入“import this”，你会得到如下提示：

```python
>>> import this

The Zen of Python, by Tim Peters
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren’t special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one — and preferably only one — obvious way to do it.
Although that way may not be obvious at first unless you’re Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it’s a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea — let’s do more of those!
```

这就是**Python之禅**。这是关于任何要成为Pythonic的诗。我们想要关联的部分如下：

> There should be one-and preferably only one - obivous way to do it.

在`Python`当中，map & reduce可以做list comprehension（后面讨论）同样的事情。这个打破了**Python之禅**的一条规则，于是这部分的函数式编程看起来不是那么的‘pythonic’。

另外一个需要讨论的点是Lambda。在`Python`当中，一个lambda函数是一个常规的函数。Lambda是语法糖。以下两者实际上是等价的：

```python
foo = lambda a: 2

def foo(a):
	return 2
```

理论上，一个常规的函数可以干任何lambda函数能做的事情，但是反过来却不行。一个lambda函数并不能干一个常规函数可以做的任何事情。

这就是一个小争论关于为什么函数式编程不能很好地匹配整个`Python`生态系统。你应该注意到我早先提到的list comprehensions，现在我们将着重讨论它。

## List comprehensions

早些时候，我提到任何map或者filter能够做的事情，你都可以用list comprehension来实现。这部分内容我们将好好学习一下list comprehension。

一个list comprehension是`Python`产生列表的一种方式，语法如下：举例如下：

```python
[function for item in iterable]
```

然后然我对一个列表当中的每一个数字进行平方操作，举例如下：

```python
print([x * x for x in [1, 2, 3, 4]])
```

ok, 现在我们能够看到我们如何将一个函数作用于一个列表当中的每一个元素。如果是应用filter我们会怎么做呢？看下面这段之前出现过的代码：

```python
x = range(-5, 5)

all_less_than_zero = list(filter(lambda num: num < 0, x))
print(all_less_than_zero)
```

我们可以转换成list comprehension：

```python
x = range(-5, 5)

all_less_than_zero = [num for num in x if num < 0]
```

List comprehensions支持这样的if表达式。你不再需要将上百万个函数作用于一些东西然后得到你所想要的。事实上，假如你试着做一些改变让列表看起来更加清晰和简单，那么使用list comprehension是一个不错的选择。

那么如果你想要平方所有列表中小于0的数呢？采用lambda，map和filter你会这么写：

```python
x = range(-5, 5)

all_less_than_zero = list(map(lambda num: num * num, list(filter(lambda num: num < 0, x))))
```

那样看起来相当冗长并且有些复杂。如果用list comprehension只需要这样：

```python
x = range(-5, 5)

all_less_than_zero = [num * num for num in x if num < 0]

```

list comprehension只是对于列表的处理有好处。Map和filter可以在任何可迭代对象上面工作，但是那有如何呢？我们也可以用任何comprehension来处理其它所遇到的可迭代对象。

## Ohter comprehensions


你可以针对任何可迭代对象的comprehension

可以通过使用comprehension产生任何可迭代对象。从Python 2.7开始，你甚至可以产生一个词典（hashmap）。

```python
# Taken from page 70 chapter 3 of Fluent Python by Luciano Ramalho

DIAL_CODES = [
    (86, 'China'),
    (91, 'India'),
    (1, 'United States'),
    (62, 'Indonesia'),
    (55, 'Brazil'),
    (92, 'Pakistan'),
    (880, 'Bangladesh'),
    (234, 'Nigeria'),
    (7, 'Russia'),
    (81, 'Japan'),
    ]

>>> country_code = {country: code for code, country in DIAL_CODES}
>>> country_code
{'Brazil': 55, 'Indonesia': 62, 'Pakistan': 92, 'Russia': 7, 'China': 86, 'United States': 1, 'Japan': 81, 'India': 91, 'Nigeria': 234, 'Bangladesh': 880}
>>> {code: country.upper() for country, code in country_code.items() if code < 66}
{1: 'UNITED STATES', 7: 'RUSSIA', 62: 'INDONESIA', 55: 'BRAZIL'}
```

假如这是一个可迭代对象，那他就可以被产生。让我们最后看一个关于集合（sets）的例子。如果你不懂什么是一个集合，你可以看我的[另外一篇文章](https://medium.com/brandons-computer-science-notes/a-primer-on-functions-9a51c1e9de80)。TLDR是：

- 集合是元素的列表，且在这个列表当中没有重复出现两次的元素

- 集合当中的排序无关紧要

```python
# take from page 87, chapter 3 of Fluent Python by Luciano Ramalho

>>> from unicodedata import name
>>> {chr(i) for i in range(32, 256) if 'SIGN' in name(chr(i), '')}
{'×', '¥', '°', '£', '©', '#', '¬', '%', 'µ', '>', '¤', '±', '¶', '§', '<', '=', '®', '$', '÷', '¢', '+'}
```

你应该已经发现集合具有和词典一样的花括号。`Python`确实非常智能。它会根据你是否提供额外的值来判断你编写的是dictionary comprehension还是set comprehension。如果你要了解comprehension更多，可以看一下这个[可视化导则](http://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/)。如果你想要了解comprehension和生成器更多，可以看[这篇文章](https://medium.freecodecamp.org/python-list-comprehensions-vs-generator-expressions-cef70ccb49db)。

## 结论

函数式编程是优雅而纯洁的。函数式代码可以非常简洁，也可能会非常复杂。一些`Python`核心程序员不喜欢函数式编程范式。你应该用你想用的，用解决工作所适合的最好的工具。




 
