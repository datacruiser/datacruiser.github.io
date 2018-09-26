---
title: Leetcode 197. Rising Temperature
date: 2018-09-26 13:47:28
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 197. Rising Temperature

原题目链接：[197. Rising Temperature](https://leetcode.com/articles/rising-temperature/)


给定一个`Weather`表，写一条SQL查询语句找出所有比起前一天气温高的日期的Id。

<pre>
+---------+------------------+------------------+
| Id(INT) | RecordDate(DATE) | Temperature(INT) |
+---------+------------------+------------------+
|       1 |       2015-01-01 |               10 |
|       2 |       2015-01-02 |               25 |
|       3 |       2015-01-03 |               20 |
|       4 |       2015-01-04 |               30 |
+---------+------------------+------------------+
</pre>

举个例子，在运行完你的查询脚本之后，上述`Weather`表格应该返回下面的Id:
<pre>
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
</pre>



# Solution

方法：采用`JOIN`语句和`DATEDIFF()`函数[Accepted]

## Algorithm

MySQL采用`DATEDIFF`来比较两个日期类型的值。
因此，我们可以通过使用`DATEDIFF()`函数在将**weather**表与自身相连接的基础上获得所要求的结果。

## MySQL

```sql
SELECT
    weather.id AS 'Id'
FROM
    weather
        JOIN
    weather w ON DATEDIFF(weather.Recorddate, w.Recorddate) = 1
        AND weather.Temperature > w.Temperature
;
```

