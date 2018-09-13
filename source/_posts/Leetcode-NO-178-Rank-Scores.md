---
title: Leetcode NO.178. Rank Scores
date: 2018-09-12 21:57:15
categories: Leetcode
tags:
- Leetcode
- SQL
- 数据库
description: 没什么，最近刷了一遍Leetcode上面数据库的免费题目，将解决方法记录一下。
---
# 178. Rank Scores

原题目链接：[178. Rank Scores](https://leetcode.com/problems/rank-scores/description/)

这个题目没有官方提供的解法，本题主要参考以下链接的内容编写。

[SQL 笔记：Leetcode#178 Rank Scores](https://nifannn.github.io/2018/06/16/SQL-%E7%AC%94%E8%AE%B0-Leetcode-178-Rank-Scores/)

[LeetCode：Rank Scores - 按分数排名次](https://my.oschina.net/Tsybius2014/blog/493244)


写一条SQL查询语句进行分数的排名。如果两个分数相同，则应该具有相同的排名。在得分相同的排名之后，下一个排名的编号应该是下一个连续整数值。换句话说，在排名之间无“断点”。

<pre>
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
</pre>
比如，在上面的`Scores`表当中，你的查询应该产生如下报告（分数从高到低排序）：
<pre>
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
</pre>


# Solution

方法一：采用子查询、`JOIN`语句和`COUNT()`函数[Accepted]

## Algorithm

对于一个分数来说，它的排名就是去重后的`Scores`表中大于等于它的分数的数量。拿上面的表举例，表中有6个分数，3.50，3.65，4.00，3.85，4.00，3.65。去除重复记录，有4个分数，3.50，3.65，3.85，4.00。对于分数4.00，只有4.00 ≥ 4.00，排名为1。同样地，对于分数3.65，4.00 ≥ 3.65，3.85 ≥ 3.65，3.65 ≥ 3.65，有三个数大于等于它，所以排名为3。

## MySQL

第一步，找出去重后的所有分数：

```sql
SELECT DISTINCT Score FROM Scores;
```

第二步，假设不重复的分数组成的表为`t`，接下来可以全连接`t`和`Scores`，然后对于`Scores`表中的每一个分数，找出`t`中大于等于它的分数：

```sql
SELECT s.Score, t.Score FROM
(SELECT DISTINCT Score FROM Scores) AS t, Scores AS s
WHERE s.Score <= t.Score;
```

第三步，对`Scores`表中的每一个分数，统计`t`中大于等于它的分数的数量作为排名：

```sql
SELECT s.Score, COUNT(t.Score) AS Rank FROM
(SELECT DISTINCT Score FROM Scores) AS t, Scores AS s
WHERE s.Score <= t.Score
GROUP BY s.Id, s.Score;
```

第四步，根据分数降序排序：

```sql
SELECT s.Score, COUNT(t.Score) AS Rank FROM
(SELECT DISTINCT Score FROM Scores) AS t, Scores AS s
WHERE s.Score <= t.Score
GROUP BY s.Id, s.Score
ORDER BY s.Score DESC;
```


方法二：采用子查询和自定义变量[Accepted]

## Algorithm

利用自定义变量的“左值”特性，即你在给这个变量赋值的同时也可以使用这个变量。这样可以实现这样的一种排名方式：直接按分数高低对成员进行排列，名次从1开始依次递增，当两个人分数相同的时候，也要按照出现的先后顺序或者其它规律分成先后。排序语句如下：

## MySQL

```sql
SELECT Score, @Counter := @Counter + 1 AS Rank
FROM Scores, (SELECT @Counter := 0) AS C
ORDER BY Score DESC;
```

排序结果如下：

<pre>
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 2    |
| 3.85  | 3    |
| 3.65  | 4    |
| 3.65  | 5    |
| 3.50  | 6    |
+-------+------+
</pre>

依题意，分数相同的排名也需要相同，因此这里还要使用`DISTINCT`关键字进行去重，然后先排出`Score`的名次保存在一个临时结果集当中，再跨原表和这个临时结果集匹配出各个`Score`对应的名次，实现本思路的SQL语句如下：

```sql
SELECT A.Score, B.Rank
FROM Scores AS A, (
  SELECT Score, @Counter := @Counter + 1 AS Rank
  FROM (SELECT DISTINCT Score FROM Scores) AS DIS_S, (SELECT @Counter := 0) AS C
  ORDER BY Score DESC) AS B
WHERE A.Score = B.Score
ORDER BY A.Score DESC;
```





