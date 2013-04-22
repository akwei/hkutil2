hkutil2
=======

Objective-c 常用工具代码封装

============
使用ASIHTTPRequest xcode编译提示找不到"libxml/HTMLparser.h",解决方法如下:

1>.在xcode中左边选中项目的root节点,在中间编辑区的搜索框中输入"header search paths",
双击Header Search Paths项,点击加号增加一项并输入"${SDK_DIR}/usr/include/libxml2",
点击done按钮结束.

2>.再次在搜索框中输入"other linker flags",双击Other Linker Flags项,
点击加号增加一项并输入"-lxml2",点击done按钮结束.

============