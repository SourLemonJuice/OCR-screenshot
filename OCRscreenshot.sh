#!/bin/bash

# 使用 tesseract 识别屏幕截图上的文字

# spectacle 矩形模式
_Capture_Mode="--region"

_Tesseract_Lang="eng+chi_sim"
# 消除中文空格
_Tesseract_Configs+="-c preserve_interword_spaces=1"

# 哈，一只stdin小火车
# 对了，这样写的话在每个管道符号前一旦报错就会停止，这是bash的逻辑
{
    # 启动截图，输出至标准输出 [--后台 --无通知 --自定义输出路径]
    spectacle "$_Capture_Mode" --background --nonotify --output "/proc/self/fd/1"
    # 输出图像
} | {
    tesseract stdin stdout -l "$_Tesseract_Lang" --oem 3 --psm 6 ${_Tesseract_Configs[@]}
    # 输出解析后的文字
} | {
    # 发出通知
    notify-send --app-name OCR --action Copy=复制 "$(cat)"
    # 输出用户选择的控件编号
} | {
    # 实现控件功能
    case "$(cat)" in
    Copy)
        wl-copy "$(cat)"
    ;;
    esac
}
# done
exit 0
