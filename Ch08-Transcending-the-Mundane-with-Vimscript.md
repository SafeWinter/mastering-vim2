# 第八章 让您的 Vim 技艺脱胎换骨——Vimscript 初探



> **本章概要**
>
> - `Vimscript` 的基本语法
> - `Vimscript` 编程风格指南
> - 从零打造一个 `Vim` 插件的全过程演示

本章源码：`https://github.com/PacktPublishing/Mastering-Vim-Second-Edition/tree/main/Chapter08`

这一章可谓全书的精华，不失为 `Vim9script` 脚本的绝佳入门材料。作者在前一版的基础上，对旧版 `Vim` 脚本 [^1] 进行了全面修订，前面章节中埋下的很多伏笔在本章都能找到答案。为了近距离感受 `Vimscript` 的强大，作者在本章最后还从零开始打造了一款实用的 `Vim` 插件，让看似零散的脚本语法在实战应用中得到整合，旨在进一步让读者们的 `Vim` 水平有一个质的飞跃。

本章虽知识点密集，但也仅仅是 `Vim` 脚本的冰山一角；想要真正掌握它还需要后期大量深入研读相关文档，并配合相当程度的实战项目训练才行。

---



## 1 为何选择 Vimscript

`Vimscript` 实际上是一种图灵完备的脚本语言，这意味着它具备 **解决任何可计算问题** 的能力。虽然其主要用途是扩展 `Vim` 编辑器，但这一语言特性使其在理论上能够实现一系列复杂的逻辑和算法。



## 2 Vimscript 的运行方式

`Vimscript` 由一系列 `Vim` 命令构成，既可以在命令模式下执行每条 `Vim` 命令，也可以用 `:source` 命令来运行包含 `Vimscript` 的某个文件（通常以 `.vim` 作扩展名）：

```bash
:source <vimscript_filename>
# 或者
:so %
```

这里的 `%` 表示 **当前打开的文件**。实战过程中，如果要立即生效当前 `.vimrc` 文件的配置内容，还可以写作：

```bash
:w | so %
```

注意：务必先保存再运行，否则新内容无法生效。

> [!tip]
>
> **最佳实践**
>
> 用 `:so %` 运行较长的 `Vim` 脚本；用 `Vim` 命令模式来调试脚本。



### 2.1 实测首个 Vim 脚本的执行

新建并打开一个示例文件 `01_variables.vim`，输入以下内容（先按旧版 `Vimscript` 的写法演示）：

```bash
let g:ingredient = 'egg'

echo 'Scene: A cafe. A man and his wife enter.'
echo 'Man: Well, what''ve  you got?'
echo g:ingredient
echo '- said the waitress'
```

运行 `:w | so %` + <kbd>Enter</kbd>：

![](assets/8.1.png)

**图 8.1 实测 :w | so % 命令的执行结果**



## 3 脚本在命令模式下的自动续行

在命令模式下，如果输入函数定义或流程控制运算符（如 `if`、`while`、`for` 等），输入回车后 `Vim` 会继续留在命令模式下，实现 “自动续行”：[^2]

![](assets/8.2.png)

**图 8.2 实测 if 语句在 Vim 命令模式下的 “自动续行” 效果**

上述命令还可以用管道符 `|` 串联成一行：`if has('win32') | echo 'this is windows' | else | echo 'this is probably linux' | endif`。



## 4 关于新版 Vimscript 9

`Vim9` 引入了 `Vimscript 9`，也叫 `Vim9script`，其核心变更包括——

- 性能大幅提升：新版执行速度将带来 10 到 100 倍的提升；
- 注释使用 `#`，取代此前的 `"`；
- 变量声明使用 `var`；
- 用 `def` 定义函数；
- 可以显式声明 `true` 和 `false` 逻辑值；
- 支持用空格提升可读性；
- 新语法特性需要手动开启：要么在脚本文件首行添加 `vim9script`，要么在某个命令前加 `vim9cmd`；

作者建议，`Vim9script` 最好作为 `Vimscript` 的有益补充；但如果对性能有要求，则推荐使用 `Vim9script`，甚至可以用它重写 `.vimrc` 文件（唯一不足的是无法向下兼容）。



## 5 语法速览

经典教材推荐：[《Learn Vimscript the Hard Way》](https://learnvimscriptthehardway.stevelosh.com/)（作者：Steve Losh）[^3]。

### 5.1 变量赋值

```bash
# 旧版
let dish = 'spam omelet'
# 新版（还可以用 const、final）
var dish = 'spam omelet'
```

声明布尔型变量：

```bash
# 旧版（用 1 或 0 表示布尔值）
let has_spam = 1
has_spam = 0
# 新版（支持显式声明）
var has_spam = true
has_spam = false
```



### 5.2 关于变量作用域

通过添加前缀来设置变量的作用域，例如：

```bash
let g:dish = 'spam omelet'
let w:has_spam = 1
```

常见的变量作用域如下（旧版）：

- `g`：表示 `global`，即全局作用域（默认作用域，但函数内声明除外）；
- `v`：表示 `vim-variables`，由 `Vim` 定义的全局作用域；
- `l`：表示 `local scope`，局部作用域（也是函数内声明的默认作用域）；
- `b`：表示 `buffer`，即当前缓冲区；
- `w`：`current window`，即当前窗口作用域；
- `t`：`current tab`，即当前标签作用域；
- `s`：表示 `script`，即脚本级作用域，其变量只在被 `:source` 命令调用的脚本文件内可见；
- `a`：表示 `function argument`，即函数参数作用域。

新版调整：

- 默认作用域改为 `s` 级作用域；
- 不再使用 `a:` 前缀来声明函数参数作用域变量；函数参数作用域改为局部作用域（`l:`）的一部分。



### 5.3 Vim 配置项的赋值

例如声明 `ignorecase` 选项的值：

```bash
# 旧版
let &ignorecase = 0
# 新版
&ignorecase = 0
```



### 5.4 Vim 寄存器的赋值

例如修改寄存器 `a"` 的值：

```bash
# 旧版
let @a = 'spam spam spam'
# 新版
@a = 'spam spam spam'
```



### 5.5 字符串的连接

旧版使用 `.` 操作符，新版改为 `..`：

```bash
# 旧版
let g:dish = 'spam omelet'
let g:statement = 'Well, we''ve got ' . g:dish

# 新版
g:dish = 'spam omelet'
var statement = 'Well, we''ve got ' .. g:dish
```



> [!tip]
>
> **DIY 实战：关于 Vim 脚本中的引号和注释**
>
> 注意：示例中的单引号是通过重复录入单引号 `'` 实现的。虽然外围也可以改用双引号，写作 `"Well, we've got "`，但由于旧版 `Vimscript` 的注释也是用双引号 `"` 标识的，因此容易产生混淆，不建议这样更改；正因如此，某些 `Vim` 命令的同一行后不能跟一个注释语句，因为会被误判为没写完的字符串（例如 `echo` 命令）：
>
> ```bash
> # 旧版
> let g:dish = 123
> echo g:dish "comment content
> ```
>
> 运行结果：
>
> ![](assets/8.3.png)
>
> **图 8.3 实测旧版 Vimscript 中的 echo 命令与注释语句在同一行时报错**
>
> 而在新版 `Vim9script` 中，注释语句改用 `#` 标识，上述测试脚本可以写为：
>
> ```bash
> # 新版
> vim9script
> g:dish = 123
> echo g:dish #comment content
> ```
>
> 运行结果：
>
> ![](assets/8.4.png)
>
> **图 8.4 实测新版 Vim9script 中的 echo 命令与新版注释语句在同一行时运行不报错**
>
> 显然我本地的 `PaperColor` 主题还不能正确解析这种情况，因此还是尽量不要这样写。







---

[^1]: `Vimscript` 是 `Vim8.x` 及以前版本的专属 `Vim` 脚本语言；`Vim9script` 由 `Vim` 之父 **Bram Moolenaar** 于 2022 年 6 月正式发布。自 2023 年 8 月 **Bram Moolenaar** 猝然离世（享年 62 岁）后，开源社区的 `Vim` 核心成员与爱好者们又纷纷组织起来，于 2024 年 1 月推出了改良版的 `Vim 9.1` 版，并对此前的 `Vim9script` 存在的诸多问题进行了全面修复，以此纪念这位 `Vim` 编辑器的缔造者、维护者以及终身领导者。
[^2]: 先别管 `has('win32')` 以及上面的 `var`、`let` 的含义，因为后面会具体介绍；这里先建立执行 `Vim` 脚本的直观感受

[^3]: 完整 PDF 版本我已免费上传到网盘：`https://pan.baidu.com/s/1kUzFlLSBBLx5rZVO_TFTZw?pwd=7dnv`，提取码：`7dnv`




