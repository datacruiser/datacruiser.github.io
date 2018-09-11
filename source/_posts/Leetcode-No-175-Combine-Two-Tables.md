---
title: Leetcode No.175.Combine Two Tables
date: 2018-09-11 16:00:49
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 175. Combine Two Tables

原题目链接：[175. Combine Two Tables](https://leetcode.com/articles/combine-two-tables/)

表: `Person`

<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId 是这个表的主键。
</pre>
表: `Address`


<pre>
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId 是这个表的主键。
</pre>


写一条SQL查询语句，为每一个在Person表中的人提供以下信息，不考虑是否每一个人都有对于的地址：

<pre>
FirstName, LastName, City, State
</pre>

# Solution

方法：采用`OUTER JOIN`[Accepted]

## Algorithm

因为Address表中的PersonId诗Person表的外键，我们可以JOIN 两张表获得每个人的地址信息。

考虑到并不是所有人都有对于的地址信息，我们应该采用`OUTER JOIN`,而不是`INNER JOIN`。

## MySQL

```sql
select FirstName, LastName, City, State
from Person left join Address
on Person.PersonId = Address.PersonId
;
```



