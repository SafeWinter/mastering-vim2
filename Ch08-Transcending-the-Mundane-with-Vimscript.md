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



### 5.6 关于 Vim 脚本中的引号和注释

注意：示例中的单引号是通过重复录入单引号 `'` 实现的。虽然外围也可以改用双引号，写作 `"Well, we've got "`，但由于旧版 `Vimscript` 的注释也是用双引号 `"` 标识的，因此容易产生混淆，不建议这样更改；正因如此，某些 `Vim` 命令的同一行后不能跟一个注释语句，因为会被误判为没写完的字符串（例如 `echo` 命令）：

```bash
# 旧版
let g:dish = 123
echo g:dish "comment content
```

运行结果：

![](assets/8.3.png)

**图 8.3 实测旧版 Vimscript 中的 echo 命令与注释语句在同一行时报错**

而在新版 `Vim9script` 中，注释语句改用 `#` 标识，上述测试脚本可以写为：

```bash
# 新版
vim9script
g:dish = 123
echo g:dish #comment content
```

运行结果：

![](assets/8.4.png)

**图 8.4 实测新版 Vim9script 中的 echo 命令与新版注释语句在同一行时运行不报错**

显然我本地的 `PaperColor` 主题还不能正确解析这种情况，因此还是尽量不要这样写。



### 5.7 echo、echom 与 messages

`echo` 命令会将内容显示到状态栏，但该结果不会被记录，一旦删除将无法查看。

`echom` 或 `echomsg` 命令会将输出内容同步记录到当前会话的信息日志，并可通过 `:messages` + <kbd>Enter</kbd> 查看：

![](assets/8.5.png)

**图 8.5 实测 echo、echom 与 messages 命令的执行结果**

更多用法，详见 `:h message-history`。



### 5.8 条件语句

```bash
# 旧版
# if 的写法
let ingredient = 'egg'

if ingredient == 'egg' 
  echo 'spam omelet' 
elseif ingredient == 'lobster' 
  echo 'spam lobster thermidor' 
else 
  echo dish . ' and spam' 
endif 

# 三目运算符
echo 'spam ' . (ingredient == 'egg' ? 'omelet' : dish)

# 逻辑运算符 &&、||、!
let is_egg = 0
let is_lobster = 0
if (!is_egg && !is_lobster)
  echo ingredient . ' and spam'
endif
```

上述示例脚本对应的 `vim9script` 新版等效写法如下：

```bash
vim9script

const ingredient = 'egg'

if ingredient == 'egg' 
  echo 'spam omelet' 
elseif ingredient == 'lobster' 
  echo 'spam lobster thermidor' 
else 
  echo dish .. ' and spam' 
endif 

echo 'spam ' .. (ingredient == 'egg' ? 'omelet' : dish)

const is_egg = 0
const is_lobster = 0
if (!is_egg && !is_lobster)
  echo ingredient .. ' and spam'
endif
```

另外，专用于文本内容比较还有几个具体的写法（也是 `Vim` 脚本的推荐写法）：

|                     比较类型                      | 写法  |           示例           |
| :-----------------------------------------------: | :---: | :----------------------: |
|         **相等匹配**（大小写随系统设置）          | `==`  |  `'egg' == 'EGG'`（假）  |
|           明确忽略大小写的 **相等匹配**           | `==?` | `'egg' ==? 'EGG'`（真）  |
|           明确考虑大小写的 **相等匹配**           | `==#` | `'egg' ==# 'EGG'`（假）  |
|  检查与右侧模式是否 **匹配**（大小写随系统设置）  | `=~`  | `'egg' =~ 'e.\+'`（真）  |
|     检查与右侧模式是否 **匹配**（忽略大小写）     | `=~?` | `'egg' =~? 'E.\+'`（真） |
|     检查与右侧模式是否 **匹配**（考虑大小写）     | `=~#` | `'egg' =~# 'E.\+'`（假） |
| 检查与右侧模式是否 **不匹配**（大小写随系统设置） | `!~`  |  `'egg' !~ '.gg'`（假）  |
|    检查与右侧模式是否 **不匹配**（忽略大小写）    | `!~?` | `'egg' !~? 'E.\+'`（假） |
|    检查与右侧模式是否 **不匹配**（考虑大小写）    | `!~#` | `'egg' !~# 'E.\+'`（真） |



### 5.9 List 列表

`Vimscript` 中的列表概念与 `Python` 非常相似：

```bash
# 旧版
let ingredients = ['egg', 'bacon', 'sausage']
# 新版
var ingredients = ['egg', 'bacon', 'sausage']
```

列表的基本操作（增删查改）如下——



#### 5.9.1 查

列表元素则通过索引获取：

```bash
# 旧版
let egg = ingredients[0]      " get 1st element
let bacon = ingredients[1]    " get 2nd element
let sausage = ingredients[-1] " get last element

# 新版
const egg = ingredients[0]      # get 1st element
const bacon = ingredients[1]    # get 2nd element
const sausage = ingredients[-1] # get last element
```

获取子列表：

```bash
# 旧版
let slice = ingredients[1:]   " ['bacon', 'sausage']
let slice = ingredients[0:1]  " ['egg', 'bacon']
# 新版
var slice = ingredients[1 : ]
slice = ingredients[0 : 1]
```

除了查列表项的 **值**，还可以查列表项的 **索引**：

```bash
# 旧版
let i = index(ingredients, 'sausage') " 2
# 新版
var i = index(ingredients, 'sausage') # 2
```

以及查元素个数（`len()` 函数）：

```bash
# 旧版
echo 'There are ' . len(ingredients) . ' ingredients.'
# 新版
echo 'There are ' .. len(ingredients) .. ' ingredients.'
```

查某元素的重复次数（`count()` 函数）：

```bash
# 旧版
echo 'There are ' . count(ingredients, 'egg') . ' eggs.'
# 新版
echo 'There are ' .. count(ingredients, 'egg') .. ' eggs.'
```

查某列表是否为空（`empty()` 函数）：

```bash
# 旧版新版皆可
if empty(ingredients)
  echo 'There are no ingredients!'
endif
```



#### 5.9.2 增

在列表末尾新增一个元素：

```bash
# 旧版
call add(ingredients, 'lobster')
# 新版
add(ingredients, 'lobster')
```

在列表开头新增一个元素：

```bash
# 旧版
call insert(ingredients, 'tomato')
# 新版
insert(ingredients, 'tomato')
```

在指定位置插入一个元素：

```bash
# 旧版
call insert(ingredients, 'ham', 2)
# 新版
insert(ingredients, 'ham', 2)
```

若 `ingredients` 最初为 `['tomato', 'egg', 'bacon', 'sausage', 'lobster']`，插入 `'ham'` 后则变为 `['tomato', 'egg', 'ham', 'bacon', 'sausage', 'lobster']`。


> [!note]
>
> **注意**
>
> `add` 函数和 `insert` 函数都是直接在列表上进行修改，因此不是纯函数，且返回值均为更新后的列表。



#### 5.9.3 删

两种方式：`unlet` 语句和 `remove` 内置函数：

```bash
# 旧版
unlet ingredients[2]          " 删除第三个列表项
call remove(ingredients, -1)  " 删除最后一个列表项
unlet ingredients[:1]         " 删除多个元素，相当于 call remove(ingredients, 0, 1)

# 新版
unlet ingredients[2]
remove(ingredients, -1)  # 删除最后一个列表项，并返回被删元素
unlet ingredients[:1]    # 删除多个元素，相当于 remove(ingredients, 0, 1)
```



#### 5.9.4 改

常见的两种方式：`+` 运算符和 `extend()` 内置函数：

```bash
# 旧版
let fresh = ['egg', 'lobster']
let preserved = ['bacon', 'sausage']
let ingredients = fresh + preserved  " ['egg', 'lobster', 'bacon', 'sausage']
call extend(fresh, preserved)

# 新版
var fresh = ['egg', 'lobster']
var preserved = ['bacon', 'sausage']
ingredients = fresh + preserved
extend(fresh, preserved)
```

上述代码中，`extend` 函数文如其名，会扩展 `fresh` 的列表项，而 `preserved` 不变。

此外，`extend` 还可以接收第三个参数：`extend({expr1}, {expr2} [, {expr3}])`。它是一个索引值，用于指定 `{expr2}` 加到 `{expr1}` 中的具体位置。

除了改变列表项的个数，还可以改变列表项的顺序—— `sort()` 排序函数：

```bash
# 旧版
call sort(ingredients)

# 新版
sort(ingredients)
```

这是最简单的排序方式——按字母表升序排序。此外还支持不同区域文化排序和自定义排序，格式为 `sort({list} [, {how} [, {dict}]])`，详见 `:h sort()`。

更多关于 `list` 列表的用法，详见 `:h list`。



### 5.10 字典

新版 `Vim9script` 在字典的定义上省去了多余的反斜杠符：

```bash
# 旧版
let menu = { 
  \ 'egg': 'spam omelet', 
  \ 'bacon': 'bacon and spam', 
  \ 'sausage': 'spam with sausage' 
  \ }

# 新版
var menu = { 
  'egg': 'spam omelet', 
  'bacon': 'bacon and spam', 
  'sausage': 'spam with sausage' 
}
```

字典的基本操作（增删改查）也和列表有很多相似之处——

字典中某 `key` 键对应的 `value` 值通过方括号和 `.` 操作符访问：

```bash
# 旧版
let egg_dish = menu['egg']  " get an element
let egg_dish = menu.egg     " another way to access an element

# 新版
var egg_dish = menu['egg']  # get an element
egg_dish = menu.egg         # another way to access an element
```

值的修改或者键值对的新增都可以通过直接赋值实现：

```bash
# 旧版
let menu['lobster'] = 'lobster thermidor'
let menu.lobster = 'lobster thermidor'

# 新版
menu['lobster'] = 'lobster thermidor'
menu.lobster = 'lobster thermidor'
```

最终得到的 `menu` 如下：

```bash
{
  'bacon': 'bacon and spam', 
  'egg': 'spam omelet', 
  'sausage': 'spam with sausage', 
  'lobster': 'lobster thermidor'
}
```

键值对的删除也和列表类似，分为 `unlet` 语句删除和 `remove()` 函数删除；后者返回被删的字典 **值**：

```bash
# 旧版
unlet menu['lobster']
let lobster = remove(menu, 'lobster')
echo lobster  " lobster thermidor

# 新版
unlet menu['lobster']
const lobster = remove(menu, 'lobster')
echo lobster  # lobster thermidor
```

同理，字典也支持 `extend()` 函数进行扩展：

```bash
# 旧版
call extend(menu, {'lobster': 'lobster thermidor'})
# 新版
extend(menu, {'lobster': 'lobster thermidor'})
```

如果 `menu` 已存在 `lobster` 的键，则扩展的最终结果可以用第三个参数 `{expr3}` 来手动控制，其取值有三个：

- `"keep"`：保留 `menu` 原来的值；
- `"force"`：（默认情况）使用新的键值对替换原来的值；
- `"error"`：不允许出现重复的键，并给出报错信息。

此外，字典也支持 `len()` 函数和 `empty()` 函数，分别用于查看键值对的个数和非空判定：

```bash
# 新旧两版写法相同
if !empty(menu)
  echo 'There are ' . len(menu) . ' dishes in the menu.'
endif
```

此外 `len(menu)` 还可以写为方法形式：

```bash
# 旧版（不能有空格）
echo menu->len()

# 新版（可以有空格）
echo menu -> len()
```

字典还有个特有的函数 `has_key`，用于判定某个 `key` 键是否存在：

```bash
# 新旧两版写法相同
if has_key(menu, 'egg')
  echo 'An egg dish is called ' . menu['egg']
endif
```



### 5.11 循环

#### 5.11.1 for 循环

首先是 `for` 循环。可以作用于列表：

```bash
# 新旧两版写法一致（以新版为例）
for ingredient in ['egg', 'bacon', 'sausage']
  echo ingredient
endfor
```

作用于字典时分两种情况：

```bash
# 新旧两版写法一致（以新版为例）
const menu = {
  'egg': 'spam omelet',
  'bacon': 'bacon and spam',
  'sausage': 'spam with sausage'
}

# 遍历 key 键
for ingredient in keys(menu) 
  echo 'A dish with ' .. ingredient .. ' is called ' .. menu[ingredient] 
endfor 

# 遍历键值对
for [ingredient, dish] in items(menu) 
  echo 'A dish with ' .. ingredient .. ' is called ' .. dish 
endfor 
```

`for` 循环中可以使用 `break` 退出整个循环，也可以用 `continue` 中断当次循环、并继续下一次循环：

```bash
# break 示例
var ingredients = ['egg', 'bacon', 'sausage'] 

for ingredient in ingredients 
  if ingredient ==# 'bacon' 
    echo 'Found bacon! Breaking!' 
    break 
  endif 
  echo 'Looking at an ingredient ' .. ingredient .. ', no bacon yet.' 
endfor 
# 结果：
#  Looking at an ingredient egg, no bacon yet.
#  Found bacon! Breaking!

# continue 示例
ingredients = ['egg', 'bacon', 'sausage'] 

for ingredient in ingredients
  if ingredient ==# 'egg'
    echo 'Ignoring the egg...'
    continue
  endif
  echo 'Looking at an ingredient ' .. ingredient
endfor
# 结果：
#  Ignoring the egg...
#  Looking at an ingredient bacon
#  Looking at an ingredient sausage
```



#### 5.11.2 while 循环

新旧两版的 `while` 循环写法一样：

```bash
# 以新版为例
ingredients = ['egg', 'bacon', 'sausage']

while !empty(ingredients)
  echo remove(ingredients, 0)
endwhile
# 结果：
#  egg
#  bacon
#  sausage
```

`while` 循环也支持 `continue` 和 `break` 关键字，以 `break` 为例：

```bash
# break 示例
ingredients = ['egg', 'bacon', 'sausage']

while len(ingredients) > 0
  var ingredient = remove(ingredients, 0)
  if ingredient ==# 'bacon'
    echo 'Found the bacon, breaking!'
    break
  endif
  echo 'Looking at an ingredient ' .. ingredient
endwhile
# 结果：
#  Looking at an ingredient egg
#  Found the bacon, breaking!
```



### 5.12 函数

旧版使用 `function` 关键字，新版使用 `def`（类似 `Python`）：

```bash
# 旧版
function PrepareIngredient(ingredient) 
  echo a:ingredient . ' and spam' 
endfunction 

function PrepareIngredient2(ingredient)
  return a:ingredient . ' and spam'
endfunction

# 新版
def PrepareIngredient(ingredient: string) 
  echo ingredient .. ' and spam' 
enddef 

def PrepareIngredient2(ingredient: string): string
  return ingredient .. ' and spam'
enddef
```

函数的调用如下：

```bash
# 旧版
call PrepareIngredient('aaa')
echo PrepareIngredient2('bbb')

# 新版
PrepareIngredient('aaa')
echo PrepareIngredient2('bbb')
```

注意，`Vim` 要求用户定义的函数名必须以大写字母开头。







---

[^1]: `Vimscript` 是 `Vim8.x` 及以前版本的专属 `Vim` 脚本语言；`Vim9script` 由 `Vim` 之父 **Bram Moolenaar** 于 2022 年 6 月正式发布。自 2023 年 8 月 **Bram Moolenaar** 猝然离世（享年 62 岁）后，开源社区的 `Vim` 核心成员与爱好者们又纷纷组织起来，于 2024 年 1 月推出了改良版的 `Vim 9.1` 版，并对此前的 `Vim9script` 存在的诸多问题进行了全面修复，以此纪念这位 `Vim` 编辑器的缔造者、维护者以及终身领导者。
[^2]: 先别管 `has('win32')` 以及上面的 `var`、`let` 的含义，因为后面会具体介绍；这里先建立执行 `Vim` 脚本的直观感受

[^3]: 完整 PDF 版本我已免费上传到网盘：`https://pan.baidu.com/s/1kUzFlLSBBLx5rZVO_TFTZw?pwd=7dnv`，提取码：`7dnv`



