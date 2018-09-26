---
title: Leetcode 196. Delete Duplicate Emails
date: 2018-09-26 11:30:07
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 196. Delete Duplicate Emails

原题目链接：[196. Delete Duplicate Emails](https://leetcode.com/articles/delete-duplicate-emails/)


写一条SQL查询语句**删除**所有`Person`表中所有邮箱重复的实体，只根据**Id**排序保留最小的唯一邮箱记录。

<pre>
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
</pre>

举个例子，在运行完你的查询脚本之后，上述`Person`表格应该有下面所示的行信息：
<pre>
+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
</pre>

**注意：**

你的输出是执行完脚本以后的整个`Person`表格。采用`delete`语句。



# Solution

方法：采用`DELETE`和`WHERE`语句[Accepted]

## Algorithm

以*Email*为条件将`Person`与自己相链接，我们可以得到以下代码：


```sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email
;
```

然后我们需要找出与其它记录拥有相同邮箱地址的更大的id，因此我们可以在`WHERE`语句当中增加一个条件如下。

```sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
;
```

事实上，我们已经找到需要删除的记录了，我们可以将这些语句放在一条`DELETE`语句后面。

## MySQL

```sql
DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
```

