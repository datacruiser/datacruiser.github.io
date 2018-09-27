---
title: Leetcode 595. Big Countries
date: 2018-09-27 11:08:18
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 595. Big Countries

原题目链接：[595. Big Countries](https://leetcode.com/articles/big-countries/)


有一个叫做`World`的表格。

<pre>
+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
</pre>

大国家的定义是面积大于300万平方公里或者人口超过2500万。

写一条SQL查询语句输出打国家的name, population和area。

比如，根据上述表格，我们应该输出：


<pre>
+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+
</pre>



# Solution

## 方法一：采用`WHERE`和`OR`语句[Accepted]

### Intuition

在SQL语句当中采用`WHERE`语句来过滤记录并得到目标国家列表。

### Algorithm

根据定义，大国家需要满足以下两个条件当中的一条：

- 国土面积超过300万平方公里；
- 人口超过2500万。

对于第一个条件，我们可以用以下代码得到这一类型的大国家。


```sql
SELECT name, population, area FROM world WHERE area > 3000000
```

另外，我们可以用以下代码得到人口超过2500万的大国家。

```sql
SELECT name, population, area FROM world WHERE population > 25000000
```

正如大部分人脑海当中所呈现的，我们可以使用`OR`将两个解决方案联合到一起。

## MySQL

```sql
SELECT
    name, population, area
FROM
    world
WHERE
    area > 3000000 OR population > 25000000
;    p1.Email = p2.Email AND p1.Id > p2.Id
```

## 方法二：采用`WHERE`语句和`UNION`语句[Accepted]

### Algorithm

整体的方法其实和方法一差不多。但是我们采用`UNION`来代替`OR`。

### MySQL
```sql
SELECT
    name, population, area
FROM
    world
WHERE
    area > 3000000

UNION

SELECT
    name, population, area
FROM
    world
WHERE
    population > 25000000
;
```

> 注意：这个方案会比方法一运行起来稍微快那么一丢丢，但是差别不太大。



