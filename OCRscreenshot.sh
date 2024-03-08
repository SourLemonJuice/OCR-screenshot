#!/bin/bash
# OCRscreenshot.sh

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

function OCRscreenshot_getText
{
    # 启动截图，输出至标准输出 [--后台 --无通知 --自定义输出路径到标准输出]
    spectacle "$_Capture_Mode" --background --nonotify --output "/proc/self/fd/1" |
    # 调用 tesseract
    tesseract stdin stdout -l "$_Tesseract_Lang" --oem 3 --psm 6 ${_Tesseract_Configs[@]} |
    # 输出解析后的文字到标准输出
    cat
}

function OCRscreenshot_main
{
    OCRscreenshot_getText |
    {
        # 从管道中获取文字
        local _OUT_TEXT="$(cat)"
        echo "OCR: $_OUT_TEXT"
        # 发出通知
        local OCR_Notify_Action=$(notify-send --app-name OCR --action ocr_Copy=复制 --action ocr_Translate=翻译 "$_OUT_TEXT")
        echo "notify action is: '$OCR_Notify_Action'"
        # 实现
        case "$OCR_Notify_Action" in
        ocr_Copy)
            wl-copy "$_OUT_TEXT"
            echo "wl-copy: $_OUT_TEXT"
            ;;
        ocr_Translate)
            # 获取翻译结果
            local _TRANS_OUT=$(trans -b -t "$_Translate_Shell_Lang" "$_OUT_TEXT")
            echo "translate out: $_TRANS_OUT"
            # 发送通知
            local OCR_trans_Notify_Action=$(notify-send --app-name OCR_translate --action trans_Copy=复制 "$_TRANS_OUT")
            echo "OCR.trans action is: $OCR_trans_Notify_Action"
            # 实现通知操作
            case "$OCR_trans_Notify_Action" in
            trans_Copy)
                wl-copy "$_TRANS_OUT"
                echo "wl-copy: $_TRANS_OUT"
                ;;
            *)
                echo "OCR.trans: no trans notify actions were perform"
            ;;
            esac
            ;;
        *)
            echo "OCR: no notify actions were perform"
            ;;
        esac
    }
}
# main function
OCRscreenshot_main
