---
title: Leetcode NO.176. Second Highest Salary
date: 2018-09-11 22:19:42
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 176. Second Highest Salary

原题目链接：[176. Second Highest Salary](https://leetcode.com/articles/second-highest-salary/)

写一条SQL查询语句从`Employee`表中找出第二高的薪资。

<pre>
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
</pre>
比如，在上面的Employee表当中，查询语句应该返回`200`作为第二高的薪资。如果没有第二高的薪资，则查询语句应该返回`null`。
<pre>
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
</pre>



# Solution

方法一：采用子查询和`LIMIT`语句[Accepted]

## Algorithm

将去重的薪资按照降序排列，然后利用`LIMIT`语句配合`OFFSET`语句获得第二高的薪资。


```sql
SELECT DISTINCT
    Salary AS SecondHighestSalary
FROM
    Employee
ORDER BY Salary DESC
LIMIT 1 OFFSET 1
```

不过非常遗憾，当表中仅有一条记录、并不存在第二高的薪资的时候，这个方案会被判为‘Wrong Answer’。为了克服这个问题，我们可以把这个当做一个临时表。

## MySQL

```sql
SELECT
    (SELECT DISTINCT
            Salary
        FROM
            Employee
        ORDER BY Salary DESC
        LIMIT 1 OFFSET 1) AS SecondHighestSalary
;
```

方法二：采用`IFNULL`和`LIMIT`语句[Accepted]

另外一种克服‘NULL’问题的方法是采用`IFNULL`函数。

## MySQL

```sql
SELECT
    IFNULL(
      (SELECT DISTINCT Salary
       FROM Employee
       ORDER BY Salary DESC
        LIMIT 1 OFFSET 1),
    NULL) AS SecondHighestSalary
```

方法三：采用子查询和`MAX`函数[Accepted]

## Algorithm

在排除了最大值以后的薪资记录里面挑选出最大值，具体可以看下面的查询语句。

## MySQL

```sql
SELECT 
	MAX(Salary) as SecondHighestSalary
 	FROM Employee 
 		WHERE Salary <
 			(SELECT MAX(Salary) 
 			FROM Employee)
```





