# OCR-screenshot

## 1.简介与基本使用

一个用来快速翻译屏幕上文字的 bash 脚本

### 使用通知模式 (Notification)

- 调用`spectacle`截图
- `tesseract`OCR识别，并发出带控件的通知

可用控件有这些

- 复制: 则尽可能复制文本到剪贴板
- 在终端显示: 打开新的 konsole 并用 less 显示原文
- 翻译: 用`Translate Shell`翻译，并通知(可以复制译文)
  - 复制: 复制译文
  - 在终端显示: 打开新的 konsole 并用 less 显示译文

绑定快捷键时可以直接选择 `.sh` 脚本文件\
当然 `Result_Mode` 还是需要被配置成 Notification 的（默认）

### 使用终端模式 (Terminal)

既然是截屏翻译，那在截屏之前显示个终端出来挡着是不是有点傻...\
但反正有这个模式嘛

基本就是用 `less` 与 `gum` 重新实现的通知模式

拥有更大的文字展示空间以及美观询问界面

可以用 `OCRscreenshot-Terminal.desktop` 作为快捷键的目标，或者能让它在终端里运行就可以\
注意记得更改 `Exec=` 条目的**绝对路径**，desktop 文件只能用绝对路径嘛

同样的 `Result_Mode` 需要被配置成 Terminal

总之建议不要用，是个半遗留下来的东西

## 依赖项目列表

这就是全部的依赖项了\
这是 Archlinux 软件包名列表:

- spectacle
- tesseract
- wl-clipboard (wayland)
- xclip (x11)
- translate-shell
- less
- gum (terminal mode Only)

## 2.一些重要配置

### 2.1.Tesseract

```bash
# Tesseract 设置
# 语言
_Tesseract_Lang="eng+chi_sim"
# 配置文件:
# 消除中文空格
_Tesseract_Configs+="-c preserve_interword_spaces=1"
```

### 2.2.Translate Shell

```bash
# Translate Shell 设置
# 语言
_Translate_Shell_Lang="zh"
```

### 2.3.主程序设置

```bash
# 结果输出模式
Result_Mode="Notification"
```

## --.碎碎念

当我还在windows的时候`有道翻译`几乎一直都在后台的程序，虽然这东西丑爆了但截图翻译确实好用（网易是没有正经美术吗）\
当当当当，来到linux下遇到不能复制的gui显示了看不懂的英文就抓瞎啦，耶！（讽刺）

总之写了个小东西玩，平时用的也挺频繁的，虽说大多数时间都是高强度看网页233

~~shell脚本好神奇，我一定要去学编程语言了，aaa~~\
脚本语言呀，哈哈。我对他们总是有些奇怪的情感，好用但也不好用，没法做太认真的逻辑呢。\
但这些非准确性也让 shell 脚本成为了简单操纵编译语言的得力助手呀。万物都有两面性，在合适的时候选择合适的技术吧。

诶 python 吗？提它干吗，一个脚本语言还要安装依赖还能安出一堆毛病？\
233我是真的好想黑 py 的说。

## License

This is free and unencumbered software released into the public domain.
