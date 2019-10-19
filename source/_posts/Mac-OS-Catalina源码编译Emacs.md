---
title: Mac OS Catalina源码编译Emacs
date: 2019-10-19 22:57:22
categories:
- [工具]
tags:
- emacs
- MacOS
- 编译
description: Mac OS 下面从源码编译Emacs。
---

原来一直在用`Macdown`或者`MWeb`在写博客，但是在公式多了以后渲染会有些慢，并且从工作流的角度也需要在`term`和软件本身之间进行不断地切换. 比如, 需要在命令行环境下面用`hexo new`生成文章, 然后进行编辑, 编辑完成以后再回到命令行环境去提交. 总之, 还是有着诸多不便. 

对于`emacs`一直有所耳闻, 原来在台式机上面的`Ubuntu16.04 `上面也安装配置过, 但是从来没有跨越一步到每天去用的地步. 直到有一天偶然的机会, `emacs`又进入了我的视野. 装上以后拿了一个可用的配置, 发现用了写`markdown`文件是再好不过了, 简洁的界面, 借助[hexo](https://github.com/kuanyui/hexo.el)可以直接使用`M-x`命令调用`hexo-new`命令创建文章, 编辑的话, 因为原来对于`vim`略有了解, 也正好有相关开箱即用的插件可以完美实现`vim`的编辑功能, 而提交就更加简单了, `magit`插件功能异常强大, 大大提高工作流效率. 

不过悲剧的是, 在将系统从`Mojave`升级到`Catalina`之后, 就出现各种闪退的问题, 试了好多个版本和方法以及不同地配置, 问题依旧, 于是只能使出杀手锏: 直接从源码编译, 也许不一定能够解决问题，但是也是增加一些经验。

下面就把整个编译过程和遇到的一些坑介绍一下。 

# 前期准备工作

## Xcode 命令行工具安装

```bash
xcode-select --install
```

## 相关配置包的安装

```bash
brew install autoconf automake texinfo gnutls pkg-config libxml2 --debug --verbose
```

# 源码下载

```bash
git clone https://github.com/emacs-mirror/emacs.git
```

这里需要注意的是，源码还是挺大的，将近1个G，那么如果提供在命令行环境下的源码拉取速度就至关重要。

由于众所周知的原因，使用代理应该是必然的，另外git本身是走`ssh`协议的，如果只是就`https`设置了代理，那么需要注意拉取代码时所使用的协议，应该使用你有设置过代理的协议。

# 源码编译

## 环境变量配置

我在一开始安装的时候，总是遇到这样的问题：

```c
xml.c:23:10: fatal error: 'libxml/tree.h' file not found
#include <libxml/tree.h>
         ^
1 error generated.
make[1]: *** [xml.o] Error 1
make: *** [src] Error 2
```

即便在`brew install libxml2`以后，后来才发现在编译之前需要对`PKG_CONFIG_PATH`进行一些配置，具体如下：

```bash
export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
```

## 编译

正确配置以后编译还是比较简单的，主要有以下两步：

```bash
cd ./emacs && ./autogen.sh
./configure && make && make install
```


# 安装

编译完成以后在命令行运行

```bash
open -R nextstep/Emacs.app
```

可以将`Emacs.app`移动你想移动去的地方，比如`/Applications`


编译后以后的版本信息为：

```bash
GNU Emacs 27.0.50
Copyright (C) 2019 Free Software Foundation, Inc.
GNU Emacs comes with ABSOLUTELY NO WARRANTY.
You may redistribute copies of GNU Emacs
under the terms of the GNU General Public License.
For more information about these matters, see the file named COPYING.
```

比起目前稳定版本`26.3`略有超前，使用到现在未有出现过新的闪退，希望一切平稳～
