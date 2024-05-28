# OCR-screenshot

## 1.简介与基本使用

一个用来快速翻译屏幕上文字的 bash 脚本

### 使用通知模式 (Notification)

- 调用`spectacle`截图
- `tesseract`OCR识别，并发出带控件的通知
- 如果选择**复制**用`wl-copy(wl-clipboard)`复制
- 选择**翻译**用`Translate Shell`翻译，并通知(可以复制译文)

绑定快捷键时可以直接选择 `.sh` 脚本文件\
当然 `Result_Mode` 还是需要被配置成 Notification 的

### 使用终端模式 (Terminal)

既然是截屏翻译，那在截屏之前显示个终端出来挡着是不是有点傻...\
但反正有这个模式嘛

基本就是用 `gum` 重新实现的通知模式，gum 这东西超棒的（虽然我测试时边框有点bug）

拥有更大的文字展示空间以及美观询问界面

可以用 `OCRscreenshot-Terminal.desktop` 作为快捷键的目标，或者能让它在终端里运行就可以\
注意记得更改 `Exec=` 条目的**绝对路径**，desktop 文件只能用绝对路径嘛

同样的 `Result_Mode` 需要被配置成 Terminal

## 依赖项目列表

这就是全部的依赖项了\
这是 Archlinux 软件包名列表:

- spectacle
- tesseract
- wl-clipboard (wayland)
- xclip (x11)
- translate-shell
- gum (terminal mode)
- less (terminal mode)

```text
spectacle tesseract wl-clipboard xclip translate-shell gum less
```

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

总之写了个小东西玩，平时用的估计也不多啦，都是高强度看网页\
而且这东西还不能接受`--/-`开头的输入，会被当成选项用然后通知就报错了，咕\
shell脚本好神奇，我一定要去学编程语言了，aaa

### --.TODO

- 至于内容误识别成选项（-- 开头）这种事嘛，要不换成高端一点的编译语言或者脚本语言
