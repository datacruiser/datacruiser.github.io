---
title: Leetcode-139. 单词拆分
date: 2019-10-23 19:47:20
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- 字符串
- 动态规划
- Java语言
description: Leetcode刷题系列.
---

# 描述

给定一个非空字符串 `s` 和一个包含非空单词列表的字典 `wordDict`，判定 `s` 是否可以被空格拆分为一个或多个在字典中出现的单词。

**说明：**

- 拆分时可以重复使用字典中的单词。
- 你可以假设字典中没有重复的单词。

**示例 1：**

```c
输入: s = "leetcode", wordDict = ["leet", "code"]
输出: true
解释: 返回 true 因为 "leetcode" 可以被拆分成 "leet code"。
```

**示例 2：**

```c
输入: s = "applepenapple", wordDict = ["apple", "pen"]
输出: true
解释: 返回 true 因为 "applepenapple" 可以被拆分成 "apple pen apple"。
     注意你可以重复使用字典中的单词。
```

**示例 3：**

```c
输入: s = "catsandog", wordDict = ["cats", "dog", "sand", "and", "cat"]
输出: false
```

来源：力扣（LeetCode）
链接：[139. Word Break](https://leetcode-cn.com/problems/word-break)

# 解题思路

先来一个暴力解法，暴力解法也有几种不同的思路，下面介绍第一种暴力解法的思路是这样的：我们检查`wordDict`当中的每一个单词是否可以作为字符串的前缀，如果可以，那么将这个在`wordDict`当中存在的单词在字符串当中去掉，对于字符串的剩余部分回归调用递归函数，如果某一次的函数调用发现整个字符串都已经被拆分完毕且都在字典中出现过，那么返回`true`，否则返回`false`。

以示例2进行一下说明。

首先看看`apple`和`pen`是不是可以作为字符串的前缀, 发现`apple`可以作为前缀, 然后将字符串更新为`penapple`, 再递归调用, 这次发现`pen`可以作为更新后的前缀, 再次将字符串更新为`apple`, 再次递归调用, 这次又可以匹配上，最后返回`true`。

具体代码见解法一。

在面对以下输入时会超时：

```c
"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaab"
["a","aa","aaa","aaaa","aaaaa","aaaaaa","aaaaaaa","aaaaaaaa","aaaaaaaaa","aaaaaaaaaa"]
```

作为算法菜鸟，从最简单的算法开始。

下面再介绍另外一种回溯的暴力解法。思路也比较简单粗暴，就是用`wordDict`字典当中的单词去穷尽生成所有可能的字符串，期间如果出现了目标字符串`s`，就返回`true`。

具体代码见解法二。

参考[这里的题解](https://leetcode-cn.com/problems/word-break/solution/xiang-xi-tong-su-de-si-lu-fen-xi-duo-jie-fa-by--32/)，解法二还可以有一些小优化，比如从递归出口就从头开始判断每个字符是否相等，可以在递归函数当中加入下面一段代码：

```java
//判断此时对应的字符是否全部相等
for (int i = 0; i < temp.length(); i++) 
{
    if (s.charAt(i) != temp.charAt(i)) 
    {
        return false;
    }
}
```

或者判断下`s`中的各个字符是否在`wordDict`当中出现……

但是，这些都治标不治本，无法改变算法本身在时间复杂度上面的缺陷，虽然代码的写法简洁，思路异常清晰，但是存在大量的重复计算，核心的优化点是以空间换时间，使用记忆数组`memo`来保存所有已经计算过的结果，再下次遇到的时候，直接从缓存当中取，而不是再次计算一遍。

顺便说一句，这种使用记忆数组`memo`的递归写法，和动态规划使用`dp`数组的迭代方法，是解题的两大神器。

这里，我们将记忆数组`memo[i]`定义为范围为[i,n]的子字符串是否可以拆分，如果可以拆分，赋值为`true`，如果不可以，赋值为`false`。记忆数组避免了对相同的字符串调用多次递归函数，当访问已经访问过的后缀字符串的时候，直接返回记忆数组当中的值，而不需要继续调用函数。

借助记忆化，本质是将有许多冗余的子问题的递归调用树进行剪枝，以空间换时间，极大减小了时间复杂度。

具体代码见解法三。

最后再来说说动态规划的解法。

通常涉及子数组或者子字符串且求极值的题，基本就是动态规划了。

动态规划的难点在于，如何定义合适的`dp`数组，然后找出状态转移方程。

对于本题，我们定义一个一维`dp`数组，其中`dp[i]`表示范围[0,i)内的子字符串是否可以被拆分，注意这里 `dp` 数组的长度比`s`串的长度大1，是因为我们要 c处理空串的情况，我们初始化 `dp[0]` 为` true`，然后开始遍历。

注意这里我们需要三个 `for` 循环来遍历，因为此时已经没有递归函数了，所以我们必须要遍历所有的子串，我们用`k`把 [0, i) 范围内的子串分为了两部分，[0, k) 和 [k, i)，其中范围 [0, k) 就是 `dp[k]`，范围 [k, i) 就是 `subString(s, k, i)`，其中`subString`函数定义如下（虽然不一定会用到）：

```c
//subString 子函数
char * subString(char * s, int startIndex, int endIndex)
{
/*
  s: 需要截取的字符串头指针变量
  startIndex: 截取起始索引
  endIndex: 截取终止索引
 */
    assert(endIndex >= startIndex);
    assert(s != NULL);

    int length = endIndex - startIndex;

    char *tmp = (char *)malloc(1001*sizeof(char));

    strncpy(tmp, s + startIndex, length);

    tmp[length] = '\0';

    return tmp;
}
```

其中 `dp[k]` 是之前的状态，我们已经算出来了，可以直接取，只需要在字典中查找 `subString(s, k, i)`是否存在了，如果二者均为 `true`，将 `dp[i]` 赋为` true`，并且` break` 掉，此时就不需要再用`k`去分 [0, i) 范围了，因为 [0, i) 范围已经可以拆分了。另外，我们会提前判断`dp[k]`是否为`true`，如果不为`true`，则`continue`，去寻找下一个合适的`k`。

最终我们返回 `dp` 数组的最后一个值，就是整个数组是否可以拆分的布尔值了。

以题目中的例子来分析下：

a

ap p

app pp p

appl ppl pl l

**apple**

applep pplep plep lep ep p

applepe pplepe plepe lepe epe pe e

applepen pplepen plepen lepen epen **pen**

applepena pplenpena plenpena lenpena enpena npena pena ena na a

applenpenap pplenpenap plenpenap lenpenap enpenap npenap penap enap nap ap p

applenpenapp pplenpenapp plenpenapp lenpenapp enpenapp npenapp penapp enapp napp app pp p

applenpenappl pplenpenappl plenpenappl lenpenappl enpenappl npenappl penappl enappl nappl appl ppl pl l

applepenapple pplenpenapple plenpenapple lenpenapple enpenapple npenapple penapple enapple napple **apple**

T F F F F T F F T F F F F T


# 代码

## 解法一

```java
class Solution 
{
    public boolean wordBreak(String s, List<String> wordDict) 
    {
        //为了查找方便，将数组转化为哈希集合，Java真是方便……
        return wordBreakSolver(s, new HashSet(wordDict), 0);
    
    }
    
    public boolean wordBreakSolver(String s, Set<String> wordDict, int start) 
    {
        //字符串s已经被拆分完毕
        if(start == s.length()) 
        {
            return true;
        }
        
        //遍历字典并拆分字符串
        for (int end = start + 1; end <= s.length(); end++) 
        {
            //判断字符串前缀是否已在字典当中并递归调用
            if(wordDict.contains(s.substring(start, end)) && wordBreakSolver(s, wordDict, end)) 
            {
                return true;
            }
        }
        
        return false;
    }
}
```

## 解法二

```java
class Solution 
{
    public boolean wordBreak(String s, List<String> wordDict) 
    {
        return wordBreakSolver(s, wordDict, "");
    }
    
    //temp 是当前生成的字符串
    public boolean wordBreakSolver(String s, List<String> wordDict, String temp) 
    {
        //如果此时生成的字符串长度够了，就判断和目标字符日是否相等
        if(temp.length() == s.length())
        {
            if(temp.equals(s))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        //长度超了，就返回 false
        if(temp.length() > s.length())
        {
            return false;
        }
        //考虑每个单词
        for(int i = 0; i < wordDict.size(); i++)
        {
            if(wordBreakSolver(s, wordDict,temp + wordDict.get(i)))
            {
                return true;
            }
        }
        return false;
    }
}
```

## 解法三

```java
class Solution 
{
    public boolean wordBreak(String s, List<String> wordDict) 
    {
        //为了查找方便，将数组转化为哈希集合，Java真是方便……
        return wordBreakSolver(s, new HashSet(wordDict), 0, new Boolean[s.length()]);
    
    }
    
    public boolean wordBreakSolver(String s, Set<String> wordDict, int start, Boolean[] memo) 
    {
        //字符串s已经被拆分完毕
        if (start == s.length()) 
        {
            return true;
        }
        
        //
        if (memo[start] != null)
        {
            return memo[start];
        }
        
        
        //遍历字典并拆分字符串
        for (int end = start + 1; end <= s.length(); end++) 
        {
            //判断字符串前缀是否已在字典当中并递归调用
            if (wordDict.contains(s.substring(start, end)) && wordBreakSolver(s, wordDict, end, memo)) 
            {
                memo[start] = true;
                return memo[start];
            }
        }
        
        memo[start] = false;
        return memo[start];
    }
}
```

## 解法四

```c
bool wordBreak(char *s, char **wordDict, int wordDictSize)
{
    if (s == NULL)
    {
        return false;
    }
    
    int len = strlen(s);
    
    bool dp[len + 1];
    memset(dp, false, (len + 1) * sizeof(bool));
    
    dp[0] = true;
    
    for (int i = 1; i <= len; i++)
    {
        
        for (int k = i - 1; k >= 0; k--)
        {
            if (dp[i] == true)
            {
                break;
            }
            
            if (dp[k] == false)
            {
                continue;
            }
            
            for (int j = 0; j < wordDictSize; j++)
            {
                if (strlen(wordDict[j]) != i - k)
                {
                    continue;
                }
                
                if (strncmp(s + k, wordDict[j], i - k) == 0)
                {
                    dp[i] = true;
                    break;
                }
            }
        }
    }
    
    return dp[len];
}
```


# 参考

- [[LeetCode] 139. Word Break 拆分词句](https://www.cnblogs.com/grandyang/p/4257740.html)
- [这里的题解](https://leetcode-cn.com/problems/word-break/solution/xiang-xi-tong-su-de-si-lu-fen-xi-duo-jie-fa-by--32/)
- Leetcode官方题解
- [0 ms C Solution](https://leetcode.com/problems/word-break/discuss/140996/0-ms-C-solution)


