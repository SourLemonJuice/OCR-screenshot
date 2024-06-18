#!/bin/bash
# OCRscreenshot.sh

# 使用 tesseract 识别屏幕截图上的文字

# ==== configs ====

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

# 主程序设置
# 结果输出模式
# Notification/Terminal
Result_Mode="Notification"

# ==== librarys ====

# clipboard v2
# dependency:
# - wl-clipboard
# - xclip

llib_clipboard_copy() {
    # 检测正在使用的桌面gui程序，并选择对应的剪贴板工具
    case $XDG_SESSION_TYPE in
    wayland)
        # wl-clipboard 是一个wayland下的剪贴板工具集
        wl-copy "$1"
        ;;
    x11)
        # 那这个就是老古董x11的喽
        # xclip 的实现
        echo "$1" | xclip -selection c
        # xsel 的实现
        # echo "$Parsed_Code" | xsel -ib
        ;;
    esac
}

llib_clipboard_paste() {
    case $XDG_SESSION_TYPE in
    wayland)
        wl-paste
        ;;
    x11)
        echo "只找了wayland模式的工具嘞"
        ;;
    esac
}

# ==== END librarys ====

# Get text to stdout from "spectacle"
function OCRscreenshot_getText
{
    # 启动截图，输出至标准输出 [--后台 --无通知 --自定义输出路径到标准输出]
    spectacle "$_Capture_Mode" --background --nonotify --output "/proc/self/fd/1" |
    # 调用 tesseract
    tesseract stdin stdout -l "$_Tesseract_Lang" --oem 3 --psm 6 ${_Tesseract_Configs[@]} |
    # 输出解析后的文字到标准输出
    cat
}

# display something to terminal
function openTerminalViewer
{
    # shell always like this...
    konsole -e bash --rcfile <(echo "echo $@ | less; exit;")
}

# Final return result using multi-way
# - Notification
# - Terminal
function Return_result
{
    case "$1" in
    Notification)
        # 发出通知
        local OCR_Notify_Action=$(notify-send --app-name OCR --action ocr_Copy=复制 --action ocr_Translate=翻译 --action ocr_terminal_viewer=在终端显示 -- "$_OUT_TEXT")
        echo "notify action is: '$OCR_Notify_Action'"
        # 实现
        case "$OCR_Notify_Action" in
        ocr_Copy)
            llib_clipboard_copy "$_OUT_TEXT"
            echo "clipboard-copy: $_OUT_TEXT"
            ;;
        ocr_terminal_viewer)
            openTerminalViewer "$_OUT_TEXT"
            ;;
        ocr_Translate)
            # 获取翻译结果
            local _TRANS_OUT=$(trans -b -t "$_Translate_Shell_Lang" "$_OUT_TEXT")
            echo "translate out: '$_TRANS_OUT'"
            # 发送通知
            local OCR_trans_Notify_Action=$(notify-send --app-name OCR_translate --action trans_Copy=复制 --action trans_terminal_viewer=在终端显示 -- "$_TRANS_OUT")
            echo "OCR.trans action is: '$OCR_trans_Notify_Action'"
            # 实现通知操作
            case "$OCR_trans_Notify_Action" in
            trans_Copy)
                llib_clipboard_copy "$_TRANS_OUT"
                echo "clipboard-copy: '$_TRANS_OUT'"
                ;;
            trans_terminal_viewer)
                openTerminalViewer "$_TRANS_OUT"
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
        ;;

    Terminal)
        # Display output text
        # by echo
        # echo "$_OUT_TEXT"
        # by "gum pager"
        # gum pager "$_OUT_TEXT"
        # by less
        echo "$_OUT_TEXT" | less

        # Choose what to do
        case $(gum choose "Copy" "Translate") in
        Copy)
            # Copy it with lib
            llib_clipboard_copy "$_OUT_TEXT"
            ;;
        Translate)
            local Translate_Output=$(trans -b -t "$_Translate_Shell_Lang" "$_OUT_TEXT")
            echo "$Translate_Output" | less
            # Ask if copying
            case $(gum choose "Copy") in
            Copy)
                llib_clipboard_copy "$Translate_Output"
                ;;
            *)
                return 1
                ;;
            esac
            # END Translate
            ;;
        esac
        # END Terminal mode action
        ;;
    esac
    # END Return_result
}

# main
OCRscreenshot_getText |
{
    # 从管道中获取文字
    _OUT_TEXT="$(cat)"
    echo "OCR: '$_OUT_TEXT'"
    case "$Result_Mode" in
    Notification)
        Return_result "Notification"
        ;;
    Terminal)
        Return_result "Terminal"
        ;;
    esac
}
