---
title: Leetcode 184. Department Highest Salary
date: 2018-09-25 16:42:34
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 184. Department Highest Salary

原题目链接：[184. Department Highest Salary](https://leetcode.com/articles/department-highest-salary/)


`Employee`表有所有员工的信息。每一位员工有一个Id，salary，也有一列表示部门Id（DepartmentId）。

<pre>
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
</pre>

`Department`表包含公司的所有的部门。
<pre>
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
</pre>
写一条SQL查询语句找出每一个部门当中薪酬最高的员工。对于上面的表格，在IT部门当中Max的薪酬最高，Sales部门当中Henry的薪酬最高。
<pre>
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
</pre>


# Solution

方法：采用`JOIN`和`IN`语句[Accepted]

## Algorithm

考虑到**Employee**表包含*Salary*和*DepartmentId*信息，我们查询一个部门当中的最小薪资。

```sql
SELECT
    DepartmentId, MAX(Salary)
FROM
    Employee
GROUP BY DepartmentId;
```

> 注意：有可能多个员工拥有同样高的薪资，因此，在这个查询当中不要包含员工姓名信息是安全的。

<pre>
| DepartmentId | MAX(Salary) |
|--------------|-------------|
| 1            | 90000       |
| 2            | 80000       |
</pre>

然后我们可以将**Employee**表和**Department**表连接到一起，然后查询用`IN`表达式在临时表当中查询(DepartmentId,Salary)。

## MySQL

```sql
SELECT
    Department.name AS 'Department',
    Employee.name AS 'Employee',
    Salary
FROM
    Employee
        JOIN
    Department ON Employee.DepartmentId = Department.Id
WHERE
    (Employee.DepartmentId , Salary) IN
    (   SELECT
            DepartmentId, MAX(Salary)
        FROM
            Employee
        GROUP BY DepartmentId
    )
;
```



