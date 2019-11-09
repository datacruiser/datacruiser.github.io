---
title: Leetcode-399.除法求值
date: 2019-10-29 10:41:03
categories:
- [LeetCode]
- [Leetcode TOP 100]
tags:
- 数据结构
- 算法
- C语言
- C++语言
- Java语言
- 并查集
- 图
- DFS
description: Leetcode刷题系列.
---

# 描述

给出方程式 `A / B = k`, 其中` A `和 `B` 均为代表字符串的变量， `k` 是一个浮点型数字。根据已知方程式求解问题，并返回计算结果。如果结果不存在，则返回 -1.0。

**示例 :**

```c
给定 a / b = 2.0, b / c = 3.0
问题: a / c = ?, b / a = ?, a / e = ?, a / a = ?, x / x = ? 
返回 [6.0, 0.5, -1.0, 1.0, -1.0 ]
```

输入为: `vector<pair<string, string>> equations, vector<double>& values, vector<pair<string, string>> queries`(方程式，方程式结果，问题方程式)， 其中` equations.size() == values.size()`，即方程式的长度与方程式结果长度相等（程式与结果一一对应），并且结果值均为正数。以上为方程式的描述。 返回`vector<double>`类型。

基于上述例子，输入如下：

```c
equations(方程式) = [ ["a", "b"], ["b", "c"] ],
values(方程式结果) = [2.0, 3.0],
queries(问题方程式) = [ ["a", "c"], ["b", "a"], ["a", "e"], ["a", "a"], ["x", "x"] ]. 
```
输入总是有效的。你可以假设除法运算中不会出现除数为0的情况，且不存在任何矛盾的结果。

来源：力扣（LeetCode）
链接：[399. Evaluate Division](https://leetcode-cn.com/problems/evaluate-division)

# 解题思路

这道题主要考察并查集和图这两种数据结构, 目前对这两种结构以及常用的算法掌握欠佳, 解题思路先空着, 等复习完这些基本算法, 理解了相关代码再进行补充.

下面暂时先放一些相关的示意图和各种语言的代码, 其中Java使用的是并查集, C++使用的是图. 

![并查集](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/%E5%B9%B6%E6%9F%A5%E9%9B%86.png)



![图](https://machinelearning-1255641038.cos.ap-chengdu.myqcloud.com/Datacruiser_Blog_Sources/LeetCode_Tencent50/%E5%9B%BE.png)


# 代码

## 解法一: Java语言

```java
class Solution {

    //child parent
    Map<String,String> parents=new HashMap<>();
    //child mutiply of parent
    Map<String,Double> values=new HashMap<>();

    public void add(String x){
        if(!parents.containsKey(x)){
            parents.put(x,x);
            values.put(x,1.0);
        }
    }
    public void union(String parent,String child, double value){

        add(parent);
        add(child);
        String p1=find(parent);
        String p2=find(child);
        if(p1==p2){
            return;
        }else{
            parents.put(p2,p1);
            values.put(p2,value*(values.get(parent)/values.get(child)));
        }
    }

    public String find(String x){
        while(parents.get(x)!=x){
            x=parents.get(x);
        }
        return x;
    }


    public double cal(String x){
       // System.out.println("cal x"+x);
        double v=values.get(x);
        while(parents.get(x)!=x){
            x=parents.get(x);
            v*=values.get(x);
        }
       
        return v;
    }
    public double[] calcEquation(List<List<String>> equations, double[] values, List<List<String>> queries) {

        //union 
        for(int i=0;i<equations.size();i++){
            //union parent child value
            union(equations.get(i).get(0),equations.get(i).get(1),values[i]);

        }

        //find 
        double[] ans=new double[queries.size()];
        for(int i=0;i<queries.size();i++){
            String c1=queries.get(i).get(0);
            String c2=queries.get(i).get(1);
        if(!parents.containsKey(c1)||!parents.containsKey(c2)){
                ans[i]=-1;
                continue;
            }
            if(c1.equals(c2)){
                ans[i]=1;
                continue;
            }
            String p1=find(c1);
            String p2=find(c2);
            if(!p1.equals(p2)){
                ans[i]=-1;
                continue;
            }
            ans[i]=cal(c2)/cal(c1);
        }

        return ans;
    }
}
```

## 解法二: C++语言



## 解法三: C语言

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
double DFS(int s, int e, int n, double ** dpf, int ** dpfok, int ** vis) {
	if(dpfok[s][e] == 1) {
        return  dpf[s][e];
    }
      
	double ans = -1.0;
        
		vis[s][e] = 1;
        vis[e][s] = 1;
		
		for (int i = 0; i < n; i++) {
            
			if (i != s && i != e && vis[e][i] == 0 && dpfok[s][i]) {
				double res = DFS(i,  e,  n,dpf,dpfok,vis);
				if(res == -1.0) continue;
			    ans = dpf[s][i] * res;
				break;				
			}
		}
		vis[s][e] = 0;
        vis[e][s] = 0;         
		return ans;
}
 
double* calcEquation(char *** equations, int equationsSize, int* equationsColSize, double* values, int valuesSize, char *** queries, int queriesSize, int* queriesColSize, int* returnSize){
     int str[1000] = {0};
	 char *pstr[1000] = {0};
    
    double **dpf = malloc(equationsSize * 2 * sizeof(double *));        
    int ** dpfok= malloc(equationsSize * 2 * sizeof(int *));
    int ** vis= malloc(equationsSize * 2 * sizeof(int *));
    
    for(int i = 0; i < equationsSize * 2;i++) {
        dpf[i] = malloc(equationsSize * 2 * sizeof(double)); 
        dpfok[i] = malloc(equationsSize * 2 * sizeof(int)); 
        vis[i] = malloc(equationsSize * 2 * sizeof(int));
        memset(dpf[i],0,equationsSize * 2 * sizeof(double));
        memset(dpfok[i],0,equationsSize * 2 * sizeof(int));
        memset(vis[i],0,equationsSize * 2 * sizeof(int));
    }
	 int pos = 0;
	 int dp[1000][2] = {0};
	 
	 double * res = (double *) malloc(sizeof(double) * queriesSize);
	 pstr[pos] = equations[0][0];
	 str[pos] = pos;
	 pos++;
	 
	 pstr[pos] = equations[0][1];
	 str[pos] = pos;
	 pos++;	 
	 
	 dpf[0][1] = values[0];
	 dpf[1][0] = 1.0/values[0];
	 
	 dpfok[0][1] = 1;
	 dpfok[1][0] = 1;	 
          
	 for (int i  = 1; i < equationsSize; i++) {
         int e[2] = {0};
		 
		 for (int j = 0; j < 2; j++) {
			int k;	
			for(k = 0; k < pos; k++) {
			 if(strcmp(equations[i][j],pstr[k]) == 0) {
				e[j] =  str[k];
				break; 
			 }
			}
			if (k == pos) {
				pstr[pos] = equations[i][j];
				str[pos] = pos;
				e[j] = pos;
				pos++;
			}
		 }
		 
	    dpf[e[0]][e[1]] = values[i];
	    dpf[e[1]][e[0]] = 1.0/values[i];
	    dpfok[e[0]][e[1]] = 1;
	    dpfok[e[1]][e[0]] = 1;
	 }
	 
	 for (int i  = 0; i < queriesSize; i++) {
		 int e[2] = {0};
		 for (int j = 0; j < 2; j++) { 
             int k;
		    for(k = 0; k < pos; k++) {
               
			 if(strcmp(queries[i][j],pstr[k]) == 0) {
				e[j] =  str[k];
				break; 
			 }
			} 
            dp[i][j] = e[j];
			if (k == pos) {
                dp[i][j] = -1;
			}			
			
		 }
	 }
	 // 将字符串转换为数组，上面都是c语言处理字符串额外做的工作，下面是代码逻辑
	  for (int i = 0; i < pos; i++) {
		  dpf[i][i] = 1.0;
		  dpfok[i][i] = 1;
	  }
	  
	  for (int i  = 0; i < queriesSize; i++) {

          if(dp[i][0] == -1 || dp[i][1] == -1) {
              res[i] = -1.0;
              continue;
          }
		  res[i] = DFS(dp[i][0],dp[i][1],pos,dpf,dpfok,vis);		  
	  }
	  *returnSize = queriesSize;
      return res;

}
```

# 参考

- [构造图，DFS，代码比较长，但是击败100%用户](https://leetcode-cn.com/problems/evaluate-division/solution/gou-zao-tu-dfsdai-ma-bi-jiao-chang-dan-shi-ji-bai-/)
- [纯C语言，DFS，完全是在解决C语言对字符串操作](https://leetcode-cn.com/problems/evaluate-division/solution/chun-cyu-yan-dfswan-quan-shi-zai-jie-jue-cyu-yan-d/)