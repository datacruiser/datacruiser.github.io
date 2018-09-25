---
title: Leetcode 183. Customers Who Never Order
date: 2018-09-25 15:50:57
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 183. Customers Who Never Order

原题目链接：[183. Customers Who Never Order](https://leetcode.com/articles/customers-who-never-order/)


假设一个网站包含两张表，`Customers`顾客表和`Orders`订单表。写一条SQL查询语句找出所有从来没有下过单的客户。

Table: `Customers`
<pre>
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
</pre>

Table: `Orders`

<pre>
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
</pre>
将以上表格作为例子，返回以下数据：
<pre>
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
</pre>


# Solution

方法：采用子查询和`NOT IN`语句[Accepted]

## Algorithm

反过来，如果我们有一个下过订单的客户列表，那么了解谁从来没有下过订单将很容易。我们可以采用下面的代码获得这一的列表。

```sql
SELECT customerid FROM orders;
```

然后，我们可以使用`NOT IN`来查询不在这个列表当中的客户。

## MySQL

```sql
SELECT customers.name AS Customers
FROM customers
WHERE customers.id not in 
(
	SELECT customerid FROM orders
);
```


