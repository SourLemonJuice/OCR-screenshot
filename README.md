# OCR-screenshot

## 1.简介/使用

一个用来快速翻译屏幕上文字的小脚本

- 调用`spectacle`截图
- `tesseract`OCR识别，并发出带控件的通知
- 如果选择**复制**用`wl-copy(wl-clipboard)`复制
- 选择**翻译**用`Translate Shell`翻译，并通知(可以复制译文)

这也就是全部的依赖项了\
这是 archlinux 软件包名列表:

- spectacle
- tesseract
- wl-clipboard
- translate-shell

## 2.一些配置

### 2.1.Tesseract

```shell
# Tesseract 设置
# 语言
_Tesseract_Lang="eng+chi_sim"
# 配置文件:
# 消除中文空格
_Tesseract_Configs+="-c preserve_interword_spaces=1"
```

### 2.2.Translate Shell

```shell
# Translate Shell 设置 
# 语言
_Translate_Shell_Lang="zh"
```

## --.碎碎念

当我还在windows的时候`有道翻译`几乎一直都在后台的程序，虽然这东西丑爆了但截图翻译确实好用（网易是没有正经美术吗）\
当当当当，来到linux下遇到不能复制的gui显示了看不懂的英文就抓瞎啦，耶！（讽刺）

总之写了个小东西玩，平时用的估计也不多啦，都是高强度看网页\
而且这东西还不能接受`--/-`开头的输入，会被当成选项用然后通知就报错了，咕\
shell脚本好神奇，我一定要去学编程语言了，aaa
