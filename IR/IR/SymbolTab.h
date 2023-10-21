#pragma once
#ifndef SYMTAB_H
#define SYMTAB_H

#include "sc_map.h"
#include "Value.h"

typedef struct Hashmap
{
	struct sc_map_sv* map;//key type即为value-name
	int layer; //表所在的层数
	struct Hashmap* next;//并列关系
	struct Hashmap* child//子关系（嵌套关系）

}Hashmap;

typedef struct SymbolTab //符号表的数据结构是链表
{
	int top;
	Hashmap* map[250];//栈中数据为哈希表
	
}SymbolTab;

//初始化链表
void InitList(Hashmap* M)//M就是头节点
//新的一层符号表
void AddSymbolTab(SymbolTab* ST)//分配一层新的栈
//初始化符号表
void InitSymbolTab(SymbolTab* ST)
//查找功能-在当前栈内查找
Value* SymbolTabLookup(SymbolTab* ST, char* name)
//在当前作用域插入
void InsertSymbolTab(SymbolTab* ST, char* name, Value value)
//在指定的哈希表中添加value
void InsertSymbolTab_spe(SymbolTab* ST, struct sc_map_sv* map, char* name, struct _Value* value)
//删除一层栈
void DelateSymbolTab(SymbolTab* ST)
#endif // !SYMTAB_H

