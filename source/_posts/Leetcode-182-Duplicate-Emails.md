---
title: Leetcode 182. Duplicate Emails
date: 2018-09-25 15:03:23
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 182. Duplicate Emails

原题目链接：[182. Duplicate Emails](https://leetcode.com/articles/duplicate-emails/)


写一条SQL查询语句找出在`Person`表中所有的重复邮箱。
<pre>
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
</pre>
举个例子，对于上述表格，你的查询语句返回以下数据：
<pre>
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
</pre>
**注意**：所有的邮箱地址用小写表示。


# Solution

## 方法一：采用`GROUP BY`语句和临时表[Accepted]

### Algorithm

重复邮箱是指超过一次即为重复。为了计算每一个邮箱出现的次数，我们可以采用以下的代码。

```sql
SELECT Email, COUNT(Email) as num
FROM Person
GROUP BY Email;
```

结果如下：

<pre>
| Email   | num |
|---------|-----|
| a@b.com | 2   |
| c@d.com | 1   |
</pre>

然后将这个作为一个临时表，我们可以得到以下的解法。

### MySQL

```sql
SELECT Email FROM
(
	SELECT Email, COUNT(Email) as num
	FROM Person
	GROUP BY Email
) AS statistic
WHERE num > 1
;
```

## 方法二：采用`GROUP BY`和`HAVING`条件[Accepted]

### Algorithm

另外一个更加常用的方法是在`GROUP BY`语句后面加一个`HAVING`语句来增加条件，更加简洁，更加高效。

因此我们可以将代码改写如下：

### MySQL

```sql
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(Email) > 1
;
```


