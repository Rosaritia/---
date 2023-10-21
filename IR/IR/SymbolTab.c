#define CRT_SECURE_NO_WARNINGS 1
#include <stdio.h>
#include "SymbolTab.h"


//初始化链表
void InitList(Hashmap* M)//M就是头节点
{
    M = (v)malloc(sizeof(Hashmap));
    M->next = NULL;
    M->child = NULL;
}
//新的一层符号表
void AddSymbolTab(SymbolTab *ST)//分配一层新的栈
{
    ST->top++;
    Hashmap* p;//p为新的哈希表存储的链节点
    InitList(p);
    sc_map_init_sv(p->map, 0, 0);
    p->layer = ST->top;
    //next关系的连接
    Hashmap* temp = ST->map[ST->top];
    while (temp->next != NULL)
        temp = temp->next;
    temp->next = p;
    //child关系的连接
    if (ST->top != 0)
        temp = ST->map[(ST->top) - 1];
    if (temp->child != NULL)
        temp->child = p;


}
//初始化符号表
void InitSymbolTab(SymbolTab* ST)
{
    ST->S.top = -1;
    InitList(ST->map[0]);
    AddSymbolTab(ST);
}
//查找功能-在当前栈内查找
Value* SymbolTabLookup(SymbolTab* ST, char* name)//根据value-name查找value
{
    Value* value;
    for (int i = 0; i <= ST->top; i++)
    {
        value = (Value*)sc_map_get_sv(ST->map[i]->map, name);
        if (value != NULL)
            return value;
        return NULL;
    }
}
//在当前作用域插入
void InsertSymbolTab(SymbolTab* ST, char* name, Value value)
{
    sc_map_put_sv(ST->map[ST->top]->map, name, value);
}
//在指定的哈希表中添加value
void InsertSymbolTab_spe(SymbolTab* ST, struct sc_map_sv* map, char* name, struct _Value* value)
{
    sc_map_put_sv(map, name, value);
}


//删除一层栈
void DelateSymbolTab(SymbolTab* ST)
{
    ST->top--;
}




