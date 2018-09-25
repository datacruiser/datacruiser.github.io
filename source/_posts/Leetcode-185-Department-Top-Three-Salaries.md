---
title: Leetcode 185. Department Top Three Salaries
date: 2018-09-25 17:47:55
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 185. Department Top Three Salaries

原题目链接：[185. Department Top Three Salaries](https://leetcode.com/articles/department-top-three-salaries/)


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
写一条SQL查询语句找出每一个部门当中薪酬排名前三的员工。对于上面的表格，SQL查询语句返回的结果如下：
<pre>
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
</pre>


# Solution

方法：采用子查询`JOIN`语句[Accepted]

## Algorithm

在公司当中排名前三的薪酬，意味着在这个公司当中不超过三个薪酬比当前薪酬高的员工了。
```sql
select e1.Name as 'Employee', e1.Salary
from Employee e1
where 3 >
(
    select count(distinct e2.Salary)
    from Employee e2
    where e2.Salary > e1.Salary
)
;
```

在这段代码当中，我们累加大于e1.Salary的薪酬个数。因此对于样本数据它的输出如下：

<pre>
| Employee | Salary |
|----------|--------|
| Henry    | 80000  |
| Max      | 90000  |
| Randy    | 85000  |
</pre>

然后，我们需要将**Employee**表和**Department**表相链接得到部门信息。

## MySQL

```sql
SELECT
    d.Name AS 'Department', e1.Name AS 'Employee', e1.Salary
FROM
    Employee e1
        JOIN
    Department d ON e1.DepartmentId = d.Id
WHERE
    3 > (SELECT
            COUNT(DISTINCT e2.Salary)
        FROM
            Employee e2
        WHERE
            e2.Salary > e1.Salary
                AND e1.DepartmentId = e2.DepartmentId
        )
;
```

结果如下：

<pre>
| Department | Employee | Salary |
|------------|----------|--------|
| IT         | Joe      | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
</pre>
