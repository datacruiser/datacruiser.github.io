---
title: Leetcode 262. Trips and Users
date: 2018-09-27 09:25:17
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 262. Trips and Users

原题目链接：[262. Trips and Users](https://leetcode.com/problems/trips-and-users/description/)

这个题目没有官方提供的解法，本题主要参考原题的讨论部分以及以下链接的内容进行编写。

[LeetCode 262. Trips and Users](https://www.jianshu.com/p/262ddb1cd40e)

[Trips and Users解题思路](http://www.voidcn.com/article/p-wylttqwc-sy.html)


`Trips`表有所有出租车的行程数据。每一趟行程都有一个独一无二的Id，然后Client_Id和Driver_Id是`Users`表中User_Id的外键。Status是一个枚举（ENUM）类型数据，主要有以下几种数据：


- completed
- cancelled_by_driver
- cancelled_by_client


<pre>
+----+-----------+-----------+---------+--------------------+----------+
| Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
+----+-----------+-----------+---------+--------------------+----------+
| 1  |     1     |    10     |    1    |     completed      |2013-10-01|
| 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
| 3  |     3     |    12     |    6    |     completed      |2013-10-01|
| 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
| 5  |     1     |    10     |    1    |     completed      |2013-10-02|
| 6  |     2     |    11     |    6    |     completed      |2013-10-02|
| 7  |     3     |    12     |    6    |     completed      |2013-10-02|
| 8  |     2     |    12     |    12   |     completed      |2013-10-03|
| 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
| 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
+----+-----------+-----------+---------+--------------------+----------+
</pre>
`Users`表有所有的用户数据。每一个用户有一个独一无二的Users_Id，然后Role也是一个枚举类型，主要有以下几种数据：

- client
- driver
- partner

<pre>
+----------+--------+--------+
| Users_Id | Banned |  Role  |
+----------+--------+--------+
|    1     |   No   | client |
|    2     |   Yes  | client |
|    3     |   No   | client |
|    4     |   No   | client |
|    10    |   No   | driver |
|    11    |   No   | driver |
|    12    |   No   | driver |
|    13    |   No   | driver |
+----------+--------+--------+
</pre>

写一个SQL查询语句找出在2013年10月1日到3日之间由开放用户要求的订单取消率。对于上述的表格，你的SQL语句应该返回以下数据，其中订单取消率圆整到两位小数点。

<pre>
+------------+-------------------+
|     Day    | Cancellation Rate |
+------------+-------------------+
| 2013-10-01 |       0.33        |
| 2013-10-02 |       0.00        |
| 2013-10-03 |       0.50        |
+------------+-------------------+
</pre>


# Solution

方法：综合采用子查询，`CASE WHEN`、`WHERE`、`BETWEEN`、`GROUP BY`、`JOIN`语句以及`COUNT()`、`SUM()`、`ROUND`函数[Accepted]

## Algorithm

对于被取消的概率，我们需要计算两个数据：1，每天开放用户的总请求数；2，每天开放用户的被取消的请求数，然后相除就可以得到这个结果。

首先一定要每天的数据使用GROUP BY进行分组，对于分组好的数据分别用count(*)计算总请求数，SUM()函数与CASE/WHEN语句计算被取消的请求数。

下面是一个版本的写法：

## MySQL

```sql
SELECT 
    request_at AS Day, 
    round(
        sum(
            CASE WHEN   -- 这里临时生成了一个字段，由status字段决定 若是完成字段值为0 反之为1  也就是是否被取消
                status="completed" THEN 0 
                ELSE 1 
            END )       -- 对这个字段使用sum函数即可求得被取消了的个数
            /count(*),  2)      -- 除以总个数后四舍五入2位即为被取消的概率
        AS "Cancellation Rate"
FROM  
    (SELECT * FROM Trips WHERE client_id NOT IN     -- 这里要把被 BAN 的乘客过滤掉
        (SELECT users_id FROM Users WHERE banned = "yes" AND role = "client")   -- 找出被BAN的乘客 
   AND request_at  BETWEEN "2013-10-01" AND "2013-10-03"    -- 限定日期
    ) AS t
GROUP BY request_at -- 对日期分组
ORDER BY request_at;

```

也可以进行一些优化，通过内链筛选条件去掉一些被禁止的乘客，比起先查下被禁止乘客集合再使用NOT IN进行筛选要来得快。优化以后的版本如下：

```sql
SELECT 
    request_at AS Day, 
    round(
        sum(
            CASE WHEN   -- 这里临时生成了一个字段，由status字段决定 若是完成字段值为0 反之为1  也就是是否被取消
                status="completed" THEN 0 
                ELSE 1 
            END )       -- 对这个字段使用sum函数即可求得被取消了的个数
            /count(*),  2)      -- 除以总个数后四舍五入2位即为被取消的概率
        AS "Cancellation Rate"
FROM  
    Trips t INNER JOIN Users u ON t.Client_Id = u.Users_Id and u.Banned='No'    -- 限定为非ban用户
WHERE request_at  BETWEEN "2013-10-01" AND "2013-10-03"    -- 限定日期
GROUP BY request_at -- 对日期分组
ORDER BY request_at;
```





