# 第九章 下一步打算



> **本章概要**
>
> - 良好的编辑习惯介绍（摘自 **Bram Moolenaar** 的讲稿）
> - 将 `Vim` 的模式风格集成到其他 IDE、浏览器等场景的方法
> - 一些 `Vim` 社区和推荐读物

本章为全书最后一章，主要介绍了后续 `Vim` 学习的一些工具和资源。



## 1 文本高效编辑的七个习惯

文章出处：`https://moolenaar.net/habits.html` [^1]

要点整理如下：

1. **快速移动光标**

   - 大部分时间花在阅读、查找错误和定位上，而不是插入或修改文本。

   - 使用搜索命令（如 `/pattern`）和快捷键（如 `*`、`%`、`gd`）可以快速定位文本。

   - 通过设置 `incsearch` 和 `hlsearch` 选项，可以实时显示搜索结果并高亮匹配项。

2. **避免重复输入**

   - 使用替换命令（`:s`）和重复命令（`.`）来减少重复输入。

   - 利用 `Vim` 的自动补全功能（如 `CTRL-N`）来快速输入长单词或短语。

   - 使用宏（`qa` 和 `@a`）记录和重复复杂的编辑操作。

3. **及时纠正错误**

   - 使用缩写（`:abbr`）自动纠正常见拼写错误。

   - 利用语法高亮功能快速发现代码中的错误，如未闭合的括号或拼写错误。

   - 通过 `%` 命令检查括号匹配，确保代码结构正确。

4. **处理多个文件**

   - 使用标签文件（tags file）和 `:grep` 命令在多个文件中快速跳转和查找。

   - 利用 `Vim` 的多窗口功能同时编辑和比较多个文件。

   - 使用预览窗口查看函数声明或结构定义，而无需离开当前文件。

5. **与其他工具协作**

   - 编辑器应与其他工具（如编译器、邮件客户端）协同工作，以提高效率。

   - 使用外部程序（如 `wc`）处理文本，如统计字数。

   - `Vim` 正在努力与其他开发工具（如 `MS-Developer Studio`、`Mutt`）集成。

6. **处理结构化文本**

   - 对于结构化文本，可以编写宏或插件来自动化编辑任务。

   - 使用 `:make` 命令加速编辑-编译-修复的循环，并根据编译器调整 `errorformat` 选项。

   - 通过自定义宏和命令，快速处理特定类型的文件（如手册页）。

7. **养成习惯**

   - 学习新命令并将其变成习惯，但不必掌握所有命令。

   - 定期反思重复性任务，寻找自动化解决方案。

   - 通过不断练习，将常用命令内化为肌肉记忆，提高编辑效率。



## 2 三个作者推荐的本文编辑好习惯

1. 时常检查低效环节：如浏览大段文本很费时间。
2. 找到更快捷的方法：此时可以通过 `*` 键检索光标所在的单词、启用 `incsearch` 和 `hlsearch` 等选项提高效率。
3. 形成习惯：将常用的提效配置存入 `.vimrc` 文件。



## 3 Vim 模式风格的迁移

`Vim` 文本编辑的高效得益于不同 **模式** 间的高效协同。为此，也可以将这种风格迁移到其他日常场景中，例如：

1. 与 `Emacs` 集成：使用 `Evil`（`https://github.com/emacs-evil/evil`）
2. 与 `JetBrains` 旗下产品集成：使用 `IdeaVim` 扩展（`https://github.com/JetBrains/ideavim`）
3. 与 `Eclipse` 集成：使用 `Eclim` 扩展（`https://eclim.org/`）[^2] 或 `Vrapper` 扩展（`https://vrapper.sourceforge.net/home/`）



## 4 浏览器的 Vim 扩展

两款 `Chrome` 浏览器插件推荐：

- `Vimium`：老牌集成 `Vim` 操作的浏览器插件，同时支持 [Chrome](https://chrome.google.com/extensions/detail/dbepggeogbaibhgnhhndojpepiihcmeb)、[Edge](https://microsoftedge.microsoft.com/addons/detail/vimium/djmieaghokpkpjfbpelnlkfgfjapaopa)、[Firefox](https://addons.mozilla.org/en-GB/firefox/addon/vimium-ff/) 浏览器；
- `Vimium C`：国内开发者基于 `Vimium` 插件进行的二次开发，中文友好，功能更强（推荐）。

安装 `Vimium C` 扩展后，可在 `Chrome` 标签页输入大写的 `F`，快速定位的页面上的指定位置（风格类似 `EasyMotion` 插件）：

![](assets/9.1.png)

**图 9.1 Vimium C 扩展的快速导航功能实测效果截图**

输入问号键 `?` 即可快速弹出帮助窗口：

![](assets/9.2.png)

**图 9.2 Vimium C 扩展工具的快速帮助窗口，支持完善的中文提示**



## 5 在任意文本框启用 Vim 编辑的小工具

对 `Linux` 和 `MacOS` 系统：**vim-anywhere**（`https://github.com/cknadler/vim-anywhere`）

对 `Windows` 系统：**Text Editor Anywhere**（`https://www.portablefreeware.com/index.php?id=2188`）



## 6 尝试 Neovim

`Neovim` 其实是 `Vim` 的一个 `Fork` 分支。改用 `Neovim` 很大程度上是因为 `Vim` 的一些不足：

- 代码库维护历史已逾 30 年，向后兼容愈发困难；
- 要编写某些特定功能的插件难度很大（如支持异步操作，但后来 `Vim 8.x` 已提供原生异步支持）；
- `Vim` 插件开发需要精通 `Vimscript`，难度很大；
- 若要用于工作场景，大概率需要修改 `vimrc` 配置文件。

`Neovim` 的优点：

- 对 `Vim` 代码库进行大规模重构，并提供单一的风格指南、提高测试覆盖率；
- 取消对历史遗留系统的沉重支持；
- 配备最新的编辑器默认设置选项；
- 为插件和外部程序提供丰富的应用程序接口，包括 `Python` 和 `Lua` 插件支持等。

`Neovim` 代码库：`https://github.com/neovim/neovim`

`Neovim` 安装方法：`https://github.com/neovim/neovim/wiki/`

命令行快捷安装：

```bash
# 基于 Debian 的 Linux 发行版：
$ sudo apt install neovim
# neovim 需要 Python3 的相关支持
$ python3 -m pip install neovim
# 启动命令
$ nvim
```



## 7 Vim 读物与社区资源

最方便的参考资料当推 `Vim` 帮助文档（`:help usr_toc.txt`）。

其他社区资源：

- `Vim` 邮件列表：[vim-announce@vim.org](mailto:vim-announce@vim.org)
- `Vim` 用户支持邮件列表：[vim@vim.org](mailto:vim@vim.org)，相关存档信息详见：[https://groups.google.com/forum/#!forum/vim_use](https://groups.google.com/forum/#!forum/vim_use)
- `Vim` 开发者邮件列表：[vim-dev@vim.org](mailto:vim-dev@vim.org)，相关存档信息详见：[https://groups.google.com/forum/#!forum/vim_dev](https://groups.google.com/forum/#!forum/vim_dev)
- `Vim` IRC [^3] 频道：[https://webchat.freenode.net](https://webchat.freenode.net/)
- `Reddit` 上的 `Vim` 社区：[https://reddit.com/r/vim](https://reddit.com/r/vim)
- `Vim` 热点问题：[https://vi.stackexchange.com/](https://vi.stackexchange.com/)

其他学习资源：

- **Vim Tips Wiki**：[https://vim.wikia.com](https://vim.wikia.com/)
- **Vim screencasts**：[http://vimcasts.org](http://vimcasts.org/)
- **Learn Vimscript the Hard Way**：[http://learnvimscriptthehardway.stevelosh.com](http://learnvimscriptthehardway.stevelosh.com/)
- **Vim adventures**：[https://vim-adventures.com/](https://vim-adventures.com/)
- **Vim golf**：[https://www.vimgolf.com/](https://www.vimgolf.com/)
- 作者自己的网站 `Vim` 专栏：[https://www.rosipov.com/blog/categories/vim](https://www.rosipov.com/blog/categories/vim)





---

[^1]: **Bram Moolenaar** 是 `Vim` 的主要开发者，毕业于代尔夫特理工大学（technical university of Delft），主要从事软件开发工作。他也是 **ICCF Holland** 的创始人和财务主管，致力于帮助乌干达的孤儿。**Bram Moolenaar** 已于 2023 年 8 月 3 日去世，享年 62 岁，具体疾病细节并未公开。直到去世前一个月，他仍在为 `Vim` 编辑器提交代码，显示出他对开源事业的持续投入和热爱。
[^2]: 由于 `Eclipse` 日渐式微，`Eclim` 已于 2024 年 8 月 3 日停止维护。
[^3]: IRC 是 Internet Relay Chat 的缩写，是一种交换信息的协议。IRC 主要用于小组讨论。







