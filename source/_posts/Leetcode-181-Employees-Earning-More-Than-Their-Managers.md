---
title: Leetcode 181. Employees Earning More Than Their Managers
date: 2018-09-25 13:56:02
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 181. Employees Earning More Than Their Managers

原题目链接：[181. Employees Earning More Than Their Managers](https://leetcode.com/articles/employees-earning-more-than-their-managers/)


`Employee`表中保存所有的员工以及其直接经理的数据。每一名员工有一个Id列，也有一列保存经理的Id。
<pre>
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
</pre>
假设在给定的`Employee`表当中，写一条SQL查询语句，将那些比他经理收入高的员工找出来。对于上述的表格，Joe是唯一的一位收入比他经理还高的员工。
<pre>
+----------+
| Employee |
+----------+
| Joe      |
+----------+
</pre>


# Solution

## 方法一：采用`WHERE`语句[Accepted]

### Algorithm

考虑到这个表格有员工经理的信息，我们可能需要从这里获取信息两次。

```sql
SELECT *
FROM Employee AS a, Employee AS b
;
```

> 注意：关键字'AS'是可选的。

<table>
<thead>
<tr>
<th>Id</th>
<th>Name</th>
<th>Salary</th>
<th>ManagerId</th>
<th>Id</th>
<th>Name</th>
<th>Salary</th>
<th>ManagerId</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
</tr>
<tr>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
</tr>
<tr>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
</tr>
<tr>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
</tr>
<tr>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
</tr>
<tr>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
</tr>
<tr>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
</tr>
<tr>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
</tr>
<tr>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
</tr>
<tr>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
</tr>
<tr>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
</tr>
<tr>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
</tr>
<tr>
<td>1</td>
<td>Joe</td>
<td>70000</td>
<td>3</td>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
</tr>
<tr>
<td>2</td>
<td>Henry</td>
<td>80000</td>
<td>4</td>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
</tr>
<tr>
<td>3</td>
<td>Sam</td>
<td>60000</td>
<td></td>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
</tr>
<tr>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
<td>4</td>
<td>Max</td>
<td>90000</td>
<td></td>
</tr>
<tr>
<td>&gt; 前3列来自表a，后3列来自表b。</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>


从两个表格提数可以获得两个表格的笛卡尔积。在这种案例当中，输出会有 4*4 = 16条记录。但是，我们所感兴趣的是员工薪水高于他/她的直接经理的记录。因此，我们需要在一个`WHERE`语句当中加入两个条件。

相应的SQL代码如下：

```sql
SELECT *
FROM
    Employee AS a,
    Employee AS b
WHERE
    a.ManagerId = b.Id
        AND a.Salary > b.Salary
;
```

考虑我们所需要的仅仅是员工的姓名，因此我们稍微修改一下上述代码得到一个解决方案。

### MySQL

```sql
SELECT
     a.NAME AS Employee
FROM Employee AS a JOIN Employee AS b
     ON a.ManagerId = b.Id
     AND a.Salary > b.Salary
;
```

## 方法二：使用`JOIN`语句[Accepted]

### Algorithm

事实上，`JOIN`是将不同表格链接在一起更常用更高效地方式，并且我们可以通过`ON`来指定特定的条件。

### MySQL

```sql
SELECT 
	a.NAME AS Employee
FROM Employee AS a JOIN Employee AS b
	ON a.ManagerId = b.Id
	AND a.Salary > b.Salary
;
```




