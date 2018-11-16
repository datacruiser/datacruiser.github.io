---
title: mac系统下python plt包绘图中文显示问题
date: 2018-11-16 14:49:17
categories: matplotlib
tags:
- Mac osX
- python
- matplotlib
- 中文字体
description: 最近在使用matplotlib库进行画图的时候遇到中文显示的问题，谷歌了几番做个记录，最终解决我问题的关键一步还是官方文档给出的，以后有什么问题还是先直接看官方文档最直接，效率最高，走得弯路最少！~
---


## Mac OSX plt 中文字体配置
- 下载 Mac ttf 中文字体
    - [unicode 字体下载](https://github.com/dolbydu/font/tree/master/unicode)
    - [MicroSoft YaHei.ttf](https://github.com/dolbydu/font/blob/master/unicode/Microsoft%20Yahei.ttf)
    - [SimHei.ttf](https://github.com/dolbydu/font/blob/master/unicode/SimHei.ttf)
- font book 安装字体
- 找到matplotlib 字体存放目录
    - ~/matplotlib/mpl-data/fonts/ttf
    - 将下载好的字体文件cp到对应目录并修改文件权限
        - ```chmod 664 *.ttf```


- 找到matplotlib格式配置文件
    - ```matplotlib.matplotlib_fname()```


    - 修改```matplotlibrc```配置文件
        - **font.family**: sans-serif
        - **font.sans-serif** : 增加 SimHei, MicroSoft YaHei 
        - **axes.unicode_minus**: False #作用就是解决负号'-'显示为方块的问题
        - 该配置文件是一份模板，相关参数的修改生效需要将前面的注释号 # 去除，另外，修改生效以后最后复制一份到mtplotlib的缓存文件夹，不然下次升级matplotlib时文件会被覆盖，Mac系统当中这个缓存文件夹可以通过以下命令获得
    - ```matplotlib.get_cachedir()```


- 代码配置
    - [Configuring the font family](https://matplotlib.org/gallery/text_labels_and_annotations/font_family_rc_sgskip.html?highlight=font)

```python
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['SimHei']
rcParams['font.sans-serif'] = ['MicroSoft YaHei']
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.plot([1, 2, 3], label='测试')

ax.legend()
plt.show()
```