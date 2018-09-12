---
title: Leetcode No.177. Nth Highest Salary
date: 2018-09-12 17:30:19
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 177. Nth Highest Salary

原题目链接：[177. Nth Highest Salary](https://leetcode.com/problems/nth-highest-salary/description/)

写一条SQL查询语句从`Employee`表中找出第 $N^{th}$高的薪资。

<pre>
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
</pre>
比如，在上面的Employee表当中，当$n = 2$时第 $N^{th}$高的薪资查询语句应该返回`200`。如果没有第 $N^{th}$的薪资，则查询语句应该返回`null`。
<pre>
+-------------------------+
| getNthHighestSalary(2)  |
+-------------------------+
| 200                     |
+-------------------------+
</pre>


# Solution

方法一：采用自定义函数和`LIMIT`语句[Accepted]

## Algorithm

自定义函数`getNthHighestSalary()`,传入一个整型参数`N`，然后利用`LIMIT`语句配合`OFFSET`语句获得第 $N^{th}$高的薪资，注意如果没有的话，同样需要借助`IFNULL()`函数来判断是否为空。

## MySQL


```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
	DECLARE x int;
	SET M = N - 1;
	SET x = (SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT M, 1);
	return IFNULL(x,NULL);
END
```

需要注意的是，求第 $N^{th}$高的薪资实际上只需要`LIMIT`$n-1$个就可以了，另外也可以使用`IF-ELSE`结构代替`IFNULL()`函数。

```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
	DECLARE x int;
	SET M = N - 1;
	SET x = (SELECT DISTINCT Salary FROM Employee ORDER BY Salary DESC LIMIT M, 1);
	IF ISNULL(x)
		THEN
		RETURN NULL;
	ELSE
		RETURN x;
	END IF;
END
```
