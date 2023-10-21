实现了语法树的打印和LLVM IR的符号表
AST 文件
--lexer.l 词法分析
--parser.y 语法分析（其中包括main函数）
--ast.h 语法树节点的结构和声明
--ast.c 函数具体实现

IR 文件
--sc_map.c 哈希表实现
--sc_map.h 哈希表的声明
--Symboltab.c  符号表具体函数的实现
--Symboltab.h 采用以栈表示作用域，内置哈希表（用链表连接哈希表以保存完整符号表信息的结构）
