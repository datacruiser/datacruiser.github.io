---
title: Leetcode NO.180. Consecutive Numbers
date: 2018-09-14 22:52:19
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 180. Consecutive Numbers 

原题目链接：[180. Consecutive Numbers s](https://leetcode.com/articles/consecutive-numbers/)


写一条SQL查询所有连续出现至少3次的数字。

<pre>
+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
</pre>
比如，在上面的`Logs`表当中，`1`是唯一的连续出现至少3次的数字。
<pre>
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
</pre>


# Solution

方法一：采用`DISTINCT`和`WHERE`语句[Accepted]

## Algorithm

连续出现则意味着**Num**的**Id**相互挨在一起。因为题目是要求至少连续出现3次的数字，我们可以用3个`Logs`表的别名，然后检查3个连续的数字是否相同。

相应的SQL代码如下：

```sql
SELECT *
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;
```

结果如下：
<table>
<thead>
<tr>
<th>Id</th>
<th>Num</th>
<th>Id</th>
<th>Num</th>
<th>Id</th>
<th>Num</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>1</td>
<td>2</td>
<td>1</td>
<td>3</td>
<td>1</td>
</tr>
<tr>
<td>&gt;Note: The first two columns are from l1, then the next two are from l2, and the last two are from l3.</td>
<td></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

注意上面表中的三组数据分别来自l1，l2和l3。

然后，我们可以从上面三组数据当中选择任意的一组*Num*作为目标数据。我们还需要增加一个`DISTINCT`关键字，因为如果一个数字出现超过3次这里会重复该数字。


## MySQL

```sql
SELECT DISTINCT
    l1.Num AS ConsecutiveNums
FROM
    Logs l1,
    Logs l2,
    Logs l3
WHERE
    l1.Id = l2.Id - 1
    AND l2.Id = l3.Id - 1
    AND l1.Num = l2.Num
    AND l2.Num = l3.Num
;
```







