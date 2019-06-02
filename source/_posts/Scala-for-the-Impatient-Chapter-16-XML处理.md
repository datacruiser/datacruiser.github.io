---
title: Scala for the Impatient Chapter 16 XML处理
date: 2019-05-30 09:21:04
categories: Scala
tags:
- 函数式编程
- 大数据
- Scala for the Impatient
description: 《Scala for the Impatient》第十六章练习。
---
#### 第1题 


\<fred/>(0)得到什么？\<fred/>(0)(0)呢？为什么？


```scala
package excercises.chapter16

//import scala.xml._

object Ex01 extends App {
  val xml = <fred/>
  println(xml(0))
  println(xml(0)(0))
}
```

测试运行结果如下：


```scala
[info] Running excercises.chapter16.Ex01 
<fred/>
<fred/>
[success] Total time: 26 s, completed May 31, 2019 11:42:04 AM
```



#### 第2题

如下代码的值是什么？

\<ul>

\<li>Opening Bracket: [\</li>

\<li>Closing Bracket: ]\</li>

\<li>Opening Brace: {\</li>

\<li>Closing Brace: }\</li>

\</ul>

你如何修复它？

以上代码将会报错，在XML语法当中，当大括号作为字面量时需要用'} }' （中间其实不需要空格，为了避免hexo编译错误，下同）来表示'}'，用'{ {'表示'}'。修复后的代码如下：


```scala
package excercises.chapter16

object Ex02 extends App {
  val xml = <ul>
              <li>Opening bracket: [</li>
              <li>Closing bracket: ]</li>
              <li>Opening brace: { {</li>
              <li>Closing brace: } }</li>
              </ul>

  println(xml)

}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter16.Ex02 
<ul>
  <li>Opening bracket: [</li>
  <li>Closing bracket: ]</li>
  <li>Opening brace: {</li>
  <li>Closing brace: }</li>
  </ul>
[success] Total time: 4 s, completed May 31, 2019 2:01:41 PM
```


#### 第3题

对比

\<li>Fred\</li> match { case \<li>{Text(t)}\</li> => t }

和

\<li>{"Fred"}\</li> match { case \<li>{Text(t)}\</li> => t }

为什么他们的行为不同？

两者的结果如下：

```scala
scala> val xml_atom = <li>Fred</li> match { case <li>{Text(t)}</li> => t }
xml_atom: String = Fred

scala> val xml_text = <li>{"Fred"}</li> match { case <li>{Text(t)}</li> => t }
scala.MatchError: <li>Fred</li> (of class scala.xml.Elem)
```

这是因为内嵌的字符串并不会被转成Text节点，而是会被转成Atom[String]节点，这和普通的Text节点还是有区别的，区别在于Text是Atom[String]的子类，并且在你事后打算以Text节点的模式对它进行匹配时会失败。在这种情况下，你需要插入Text节点，而不是字符串。如果将代码修改如下就不会报错了。

```scala
package excercises.chapter16

import scala.xml._

object Ex03 extends App {
  val xml_atom = <li>Fred</li> match { case <li>{Text(t)}</li> => t }
  val xml_text = <li>{Text("Fred")}</li> match { case <li>{Text(t)}</li> => t }

  println(xml_atom)
  println(xml_text)

}
```

运行结果如下：

```scala
[info] Running excercises.chapter16.Ex03 
Fred
Fred
[success] Total time: 4 s, completed May 31, 2019 3:25:42 PM
```


#### 第4题

读取一个XHTML文件并打印所有不带alt属性的img元素。

Ex04.xml文件内容如下：

```xml
<html>
    <head>
        <title>第一个网页</title>
    </head>
    <body>
        <p>
            <img alt="12"></img>
            <img src="1"></img>
            <img src="3"></img>
        </p>
    </body>
</html>
```


Scala代码如下：

```scala
package excercises.chapter16

import java.io.File

import scala.xml.XML

object Ex04 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val root = XML.load(path + "/" + "Ex04.xml")
  val image = (root \\ "img").filter { _ \ "@alt" isEmpty }

  image foreach println
}
```
测试输出如下：

```scala
[info] Running excercises.chapter16.Ex04 
<img src="1"/>
<img src="3"/>
[success] Total time: 2 s, completed May 31, 2019 4:56:29 PM
```


#### 第5题

打印XHTML文件中所有图像的名称，即打印所有位于img元素内的src属性值。

依然使用上面那个xml文件，编码如下：

```scala
package excercises.chapter16

import java.io.File

import scala.xml.XML

object Ex05 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val root = XML.load(path + "/" + "Ex04.xml")
  (root \\ "img").foreach{
    n => {
      println(n \ "@src")
    }
  }
}
```


测试结果如下：

```scala
[info] Running excercises.chapter16.Ex05 
1
3
[success] Total time: 2 s, completed May 31, 2019 5:21:21 PM
```



#### 第6题

读取XHTML文件并打印一个包含了文件中给出的所有超链接及其url的表格。即，打印所有a元素的child文本和href属性。

Ex06.xml文件内容如下：

```xml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title>Xhtml Valid Page</title>
    </head>
    <body>
        <p>
            <a href="https://www.google.com">Google</a>
        </p>
        <p>
            <a href="https://github.com">Github</a>
        </p>
        <p>
            <a href="https://www.tmall.com">Tmall</a>
        </p>
    </body>
</html>
```

Scala代码如下：

```scala
package excercises.chapter16

import java.io.File

import scala.xml._

object Ex06 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val root = XML.load(path + "/" + "Ex06.xml")

  //val links = (root \\ "a") map { (x: Node) => (x.attribute("href").getOrElse("").toString, x.text) } filter {_._1.startsWith("https")}
  //println(links.mkString("\n"))

  var tr = <li></li>
  (root \\ "a").foreach{
    n => {
      tr = tr.copy(child = tr.child ++ <tr>{n}</tr>)
      println(n \\ "@href")
    }
  }
}

```


运行结果如下：

```scala
[info] Running excercises.chapter16.Ex06 
https://www.google.com
https://github.com
https://www.tmall.com
[success] Total time: 69 s, completed May 31, 2019 7:03:48 PM
```

运行时间较慢，需要耗费1分多钟。


#### 第7题

编写一个函数，带一个类型为Map[String,String]的参数，返回一个dl元素，其中针对映射中每个键对应有一个dt，每个值对应有一个dd，例如：


Map(“A”->”1”,”B”->”2”)
应产出

\<dl>\<dt>A\</dt>\<dd>l\</dd>\<dt>B\</dt>\<dd>2\</dd>\</dl>



根据题意编码如下：

```scala
package excercises.chapter15
package excercises.chapter16

import scala.xml.Elem

object Ex07 extends App {
  def mapToDl(m: Map[String, String]): Elem = {
    <dl>{ for ((k,v) <- m) yield <dt>{k}</dt><dd>{v}</dd> }</dl>
  }

  val m = Map("A" -> "1", "B" -> "2")

  println(mapToDl(m))
}
```

测试运行结果如下：

```scala
[info] Running excercises.chapter16.Ex07 
<dl><dt>A</dt><dd>1</dd><dt>B</dt><dd>2</dd></dl>
[success] Total time: 2 s, completed May 31, 2019 7:14:10 PM
```


#### 第8题

编写一个函数，接受dl元素，将它转成Map[String,String]。该函数应该是前一个练习中的
反向处理，前提是所有dt后代都是唯一的。



根据题意编码如下：

```scala
package excercises.chapter16

import scala.xml.{Elem, Text}

object Ex08 extends App {
  def dlToMpa(dl: Elem): Map[String, String] = {
    val keys, values = scala.collection.mutable.ArrayBuffer[String]()

    dl.child.foreach(
      n => n match {
        case <dt>{Text(t)}</dt> => keys.append(t)
        case <dd>{Text(t)}</dd> => values.append(t)
      }
    )

    keys.zip(values).toMap
  }

  val html = <dl><dt>A</dt><dd>1</dd><dt>B</dt><dd>2</dd></dl>
  println(dlToMpa(html))

}
```

测试运行结果如下：


```scala
[info] Running excercises.chapter16.Ex08 
Map(A -> 1, B -> 2)
[success] Total time: 3 s, completed May 31, 2019 7:36:55 PM

```

#### 第9题

对一个XHTML文档进行变换，对所有不带alt属性的img元素添加一个alt=”TODO”属性，其他内容完全不变。

Ex09.xml文件内容如下：

```xml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title>Xhtml Valid Page</title>
    </head>
    <body>
        <p>
            <img src="http://datacruiser.io" />
        </p>
        <p>
            <img src="http://zhihu.com" alt="imagex" />
        </p>
    </body>

</html>
```
核心代码如下：


```scala
package excercises.chapter16

import java.io.File
import scala.xml.transform.{RuleTransformer,RewriteRule}
import scala.xml.{Attribute,XML,Node,Elem,Null}

object Ex09 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val root = XML.load(path + "/" + "Ex09.xml")

  val rule = new RewriteRule {
    override def transform(n: Node) = n match {
      case img @ <img/> if img \ "@alt" isEmpty =>
        img.asInstanceOf[Elem] % Attribute(null, "alt", "TODO", Null)
      case _ => n
    }
  }

  val transformed = new RuleTransformer(rule).transform(root)

  println(transformed)
  
}

```

运行结果如下：

```scala
[info] Running excercises.chapter16.Ex09 
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Xhtml Valid Page</title></head><body>
        <p>
            <img alt="TODO" src="http://datacruiser.io"/>
        </p>
        <p>
            <img alt="imagex" src="http://zhihu.com"/>
        </p>
    </body></html>
[success] Total time: 65 s, completed May 31, 2019 7:56:46 PM
```



#### 第10题

编写一个函数，读取XHTML文档，执行前一个练习中的变换，并保存结果。确保保留了DTD以及所有CDATA内容。

非函数版本的代码如下：	

```scala
package excercises.chapter16

import java.io.File

import scala.xml.dtd.DocType
import scala.xml.parsing.ConstructingParser
import scala.xml.transform.{RewriteRule, RuleTransformer}
import scala.xml.{Attribute, Elem, Node, Null, XML}

object Ex10 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val doc = ConstructingParser.fromFile(new File(path + "/" + "Ex09.xml"),true).document
  val a = doc.docElem

  val rule = new RewriteRule {
    override def transform(n: Node) = n match {
      case img @ <img/> if img \ "@alt" isEmpty =>
        img.asInstanceOf[Elem] % Attribute(null, "alt", "TODO", Null)
      case _ => n
    }
  }

  val transformed = new RuleTransformer(rule).transform(a)

  XML.save(path + "/" + "Ex10.xml", transformed(0), "UTF-8", false, DocType("html", doc.dtd.externalID, Nil))

}
```

修改为函数版本如下：

```scala
package excercises.chapter16

import java.io.File

import scala.xml.dtd.DocType
import scala.xml.parsing.ConstructingParser
import scala.xml.transform.{RewriteRule, RuleTransformer}
import scala.xml.{Attribute, Document, Elem, Node, Null, XML}

object Ex10 extends App {
  val dir = new File("src/main/scala/excercises/chapter16")
  val path: String = dir.getAbsolutePath()
  val doc = ConstructingParser.fromFile(new File(path + "/" + "Ex09.xml"),true).document
 

  val rule = new RewriteRule {
    override def transform(n: Node) = n match {
      case img @ <img/> if img \ "@alt" isEmpty =>
        img.asInstanceOf[Elem] % Attribute(null, "alt", "TODO", Null)
      case _ => n
    }
  }


  def imgTodo(doc: Document): Unit = {
    val a = doc.docElem
    val transformer = new RuleTransformer(rule).transform(a)
    XML.save(path + "/" + "Ex10.xml", transformed(0), "UTF-8", false, DocType("html", doc.dtd.externalID, Nil))

  }
  
 imgTodo(doc)


}
```
