# 硝子 GLASS · 命令行配色 —— 见设计稿 §10 命令行。
#
# 这里只管颜色。行为（menu select / compinit / 键位 / 历史）在 ~/.zshrc。
#
# 高亮的义务是防错，不是分类。三十多种 token 全部显式指定
# ——不留插件默认值，默认值来自别人的调色板——但区分做全不等于
# 响度做满：它们取自一组有序的层，彩色只落在真正有意义的地方。
#
#   ink 粗    外部命令。你打的主语。
#   cyan      保留字与内建。系统给你的结构。
#   accent2   alias 与 function。你自己定义的东西。
#   muted     参数、选项、路径。占面积最大，所以最安静。
#   faint     注释、管道、重定向、分号。结构标点，不是内容。
#   success   引号里的字符串。
#   info      $ 后面的东西 —— 变量、命令替换、历史展开。
#   danger    命令不存在 / 引号没闭合。唯一的错误信号。
#
# 形态不占颜色配额：已存在的路径加下划线，还不存在的不加。


# ── 语法高亮 ────────────────────────────────────────────────────
typeset -gA ZSH_HIGHLIGHT_STYLES

# 命令 —— 你打的主语
ZSH_HIGHLIGHT_STYLES[command]='fg={{ colors.on_surface.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg={{ colors.on_surface.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg={{ colors.on_surface.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg={{ colors.on_surface.default.hex }},bold'

# 系统给你的结构
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg={{ colors.glass_cyan.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg={{ colors.glass_cyan.default.hex }},bold'

# 你自己定义的东西
ZSH_HIGHLIGHT_STYLES[alias]='fg={{ colors.glass_accent2.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg={{ colors.glass_accent2.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg={{ colors.glass_accent2.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[function]='fg={{ colors.glass_accent2.default.hex }},bold'

# 参数 —— 占面积最大，所以最安静
ZSH_HIGHLIGHT_STYLES[default]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[assign]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[globbing]='fg={{ colors.on_surface_variant.default.hex }}'

# 路径 —— 下划线说「它真的存在」，颜色不参与
ZSH_HIGHLIGHT_STYLES[path]='fg={{ colors.on_surface_variant.default.hex }},underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg={{ colors.on_surface_variant.default.hex }},underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=''
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=''

# 结构标点 —— 看得见就够了
ZSH_HIGHLIGHT_STYLES[comment]='fg={{ colors.outline.default.hex }}'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg={{ colors.outline.default.hex }}'
ZSH_HIGHLIGHT_STYLES[redirection]='fg={{ colors.outline.default.hex }}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg={{ colors.outline.default.hex }}'

# 字符串 —— 一眼能看出引号闭没闭
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg={{ colors.glass_success.default.hex }}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg={{ colors.glass_success.default.hex }}'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg={{ colors.glass_success.default.hex }}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg={{ colors.glass_success.default.hex }}'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg={{ colors.glass_success.default.hex }}'

# $ 后面的东西不是字面量
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg={{ colors.glass_info.default.hex }}'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg={{ colors.on_surface_variant.default.hex }}'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg={{ colors.on_surface_variant.default.hex }}'

# 错误 —— 整条命令行里唯一的错误信号
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg={{ colors.glass_danger.default.hex }},bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg={{ colors.glass_danger.default.hex }}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg={{ colors.glass_danger.default.hex }}'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg={{ colors.glass_danger.default.hex }}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg={{ colors.glass_danger.default.hex }}'


# ── 自动建议 ────────────────────────────────────────────────────
# 必须明显比你真正输入的字淡。一个看起来像已输入、
# 实际按回车才生效的东西，是会骗人的。
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg={{ colors.outline.default.hex }}'


# ── ls 的颜色 ───────────────────────────────────────────────────
# 只给类型上色，不给扩展名上色 —— 扩展名是名字的一部分，不是类型。
export LS_COLORS='di=38;2;{{ colors.glass_amber.default.red }};{{ colors.glass_amber.default.green }};{{ colors.glass_amber.default.blue }}:ln=38;2;{{ colors.glass_cyan.default.red }};{{ colors.glass_cyan.default.green }};{{ colors.glass_cyan.default.blue }}:or=38;2;{{ colors.glass_danger.default.red }};{{ colors.glass_danger.default.green }};{{ colors.glass_danger.default.blue }}:ex=1;38;2;{{ colors.on_surface.default.red }};{{ colors.on_surface.default.green }};{{ colors.on_surface.default.blue }}:pi=38;2;{{ colors.outline.default.red }};{{ colors.outline.default.green }};{{ colors.outline.default.blue }}:so=38;2;{{ colors.outline.default.red }};{{ colors.outline.default.green }};{{ colors.outline.default.blue }}:bd=38;2;{{ colors.outline.default.red }};{{ colors.outline.default.green }};{{ colors.outline.default.blue }}:cd=38;2;{{ colors.outline.default.red }};{{ colors.outline.default.green }};{{ colors.outline.default.blue }}:su=38;2;{{ colors.glass_danger.default.red }};{{ colors.glass_danger.default.green }};{{ colors.glass_danger.default.blue }}:sg=38;2;{{ colors.glass_danger.default.red }};{{ colors.glass_danger.default.green }};{{ colors.glass_danger.default.blue }}:tw=38;2;{{ colors.glass_amber.default.red }};{{ colors.glass_amber.default.green }};{{ colors.glass_amber.default.blue }}:ow=38;2;{{ colors.glass_amber.default.red }};{{ colors.glass_amber.default.green }};{{ colors.glass_amber.default.blue }}:st=38;2;{{ colors.glass_amber.default.red }};{{ colors.glass_amber.default.green }};{{ colors.glass_amber.default.blue }}'


# ── 补全菜单 ────────────────────────────────────────────────────
# 别处的选中态是重音药丸，终端里做不到 —— 单元格是方的，
# 没有圆角，没有 alpha。所以它只能是一块反白的方块。这里不假装。
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" \
  'ma=48;2;{{ colors.glass_accent.default.red }};{{ colors.glass_accent.default.green }};{{ colors.glass_accent.default.blue }};38;2;{{ colors.surface.default.red }};{{ colors.surface.default.green }};{{ colors.surface.default.blue }}'

# zsh 的 %F color escape 与模板占位符直接相邻会产生三重花括号，
# 模板引擎无法解析；而在花括号后补空格又会被 zsh 当作 8 色回退
# （实测退化为 ESC[30m）。用变量把两者隔开。
local _c_glass_danger='{{ colors.glass_danger.default.hex }}'
local _c_glass_warning='{{ colors.glass_warning.default.hex }}'
local _c_outline='{{ colors.outline.default.hex }}'

zstyle ':completion:*:descriptions' format '%F{${_c_outline}}%d%f'
zstyle ':completion:*:messages'     format '%F{${_c_outline}}%d%f'
zstyle ':completion:*:warnings'     format '%F{${_c_glass_danger}}没有匹配：%d%f'
zstyle ':completion:*:corrections'  format '%F{${_c_glass_warning}}%d（错 %e 处）%f'
