#!/bin/bash

# 使用 tesseract 识别屏幕截图上的文字

# spectacle 矩形模式
_Capture_Mode="--region"

# Tesseract 设置
# 语言
_Tesseract_Lang="eng+chi_sim"
# 配置文件:
# 消除中文空格
_Tesseract_Configs+="-c preserve_interword_spaces=1"

# Translate Shell 设置 
# 语言
_Translate_Shell_Lang="zh"

{
    # 启动截图，输出至标准输出 [--后台 --无通知 --自定义输出路径到标准输出]
    spectacle "$_Capture_Mode" --background --nonotify --output "/proc/self/fd/1"
    # 输出图像
} | {
    tesseract stdin stdout -l "$_Tesseract_Lang" --oem 3 --psm 6 ${_Tesseract_Configs[@]}
    # 输出解析后的文字
} | {
    _OUT_TEXT="$(cat)"
    # 发出通知
    echo "OCR: $_OUT_TEXT"
    _NOTIFY_ACTION=$(notify-send --app-name OCR --action Copy=复制 --action Translate=翻译 "$_OUT_TEXT")
    echo "notify action is: $_NOTIFY_ACTION"
    # 实现控件功能
    case "$_NOTIFY_ACTION" in
    Copy)
        wl-copy "$_OUT_TEXT"
        echo "wl-copy: $_OUT_TEXT"
        ;;
    Translate)
        _TRANS_OUT=$(trans -b -t "$_Translate_Shell_Lang" "$_OUT_TEXT")
        echo "translate out: $_TRANS_OUT"
        notify-send --app-name OCR_translate "$_TRANS_OUT"
        ;;
    esac
}
# done
exit 0
