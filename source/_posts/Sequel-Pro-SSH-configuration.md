---
title: Mac下Sequel Pro连接远程MySQL服务器的SSH配置 
date: 2018-01-14 16:00:02
categories: 数据库
tags: 
- MySQL
- Sequel Pro
- SSH配置
- private key
description: [openSSH对于私钥文件是有权限要求的，通常只有文件拥有者采用读写权限，比如0600，权限不符合要求的私钥文件会被openSSH忽略。]
---
终于去新公司报道了，首当其冲是熟悉公司业务，需要写SQL语句从数据库当中提取业务数据，再用**excel**做成业务指标报表。在这里就遇到一个选用哪个sql gui客户端的问题，本文主要记录下在**Mac**系统下用**Sequel Pro**连接**remote MySQL server**的**SSH**配置的问题。
# Sequel Pro下载

直接去官网，链接如下：

[sequelpro下载地址](https://www.sequelpro.com/)
# Sequel Pro安装

**Sequel Pro**是**Mac**系统下的原生的免费软件，在**Mac**系统下直接解压安装包然后将程序拖到**应用程序**即可，目前最新版本是**V1.1.2**，要求**Mac 10.6**以上版本系统。正是由于它是原生的，后面遇到了一个坑……

安装完毕以后初次打开新建连接界面如下：
![SequelPro新建连接界面](http://p1rl2jm2z.bkt.clouddn.com/Sequel%20Pro%202018-01-14%2016-20-52.png)
# SSH配置

终于要开始踩坑了，由于我原来是用**Navicat for MySQL**来连接公司的数据库的，自然而然会想到将相关参数复制过来就可以了，但是发现连接失败，看了下提示，主要原因如下：

* 因为**Sequel Pro**是**Mac**原生的，所以系统内的`~/.ssh/config`文件的配置也会影响到**SSH**连接的设置，官网对此的描述如下：

> **DOES SEQUEL PRO SUPPORT PRIVATE KEY AUTHENTICATION?**


> "Yes. If you have a private key in ~/.ssh/id_dsa or ~/.ssh/id_rsa, Sequel Pro will automatically use it -- just like the command line ssh program. In fact, Sequel Pro uses the ssh program that comes with Mac OS. As a side effect, all settings in ~/.ssh/configalso apply to Sequel Pro. This can lead to problems if you already have port forwarding set up in your config file.”


* 原来在设置[github](https://github.com)**SSH**登陆的时候配置过`~/.ssh/config`文件，当时的配置如下:

``` 
Host *
AddKeysToAgent yes
UseKeychain yes
IdentityFile ~/.ssh/id_rsa
```
问题就出在这里，导致每次验证的时候调用了原来为登陆[github](https://github.com)而准备的**private key**。


整改步骤如下：
## 配置文件修改

将不同的远程服务器指定不同的私钥文件，区分不同服务器进行单独设置，修改后配置文件如下：


```
//下面是github登陆的SSH配置
Host github.com
	HostName github.com
	User git
	AddKeysToAgent yes
	UseKeychain yes
	PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa

//下面是连接MySQL服务器的SSH配置，为了保密已经将公司服务器信息隐去
Host exampleHost
    HostName 255.255.255.255 
    User root
    port 22
    AddKeysToAgent yes
    UseKeychain yes
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/privateKey

```

## 私钥文件权限修改

这里被坑了一下的时候原来同事传给我的私钥文件权限是`0644`，在进行**SSH**登陆的时候**openSSH**的提示如下：

> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0644 for '**URL of the private key**' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.

于是按照要求用`chomd`没了将私钥文件的权限修改为`0600`，然后就能过顺利连接。

# Sequel Pro SSH 连接建立

这个时候还是回到最初的连接建立窗口，在**SSH**标签栏下一次填入相应的参数。这里需要注意的是**MySQL Host**和**SSH Host**两个有可能相同，有可能不同，具体向您的数据库管理员询问。



