#define CRT_SECURE_NO_WARNINGS 1
#include <stdio.h>
#include "SymbolTab.h"


//��ʼ������
void InitList(Hashmap* M)//M����ͷ�ڵ�
{
    M = (v)malloc(sizeof(Hashmap));
    M->next = NULL;
    M->child = NULL;
}
//�µ�һ����ű�
void AddSymbolTab(SymbolTab *ST)//����һ���µ�ջ
{
    ST->top++;
    Hashmap* p;//pΪ�µĹ�ϣ��洢�����ڵ�
    InitList(p);
    sc_map_init_sv(p->map, 0, 0);
    p->layer = ST->top;
    //next��ϵ������
    Hashmap* temp = ST->map[ST->top];
    while (temp->next != NULL)
        temp = temp->next;
    temp->next = p;
    //child��ϵ������
    if (ST->top != 0)
        temp = ST->map[(ST->top) - 1];
    if (temp->child != NULL)
        temp->child = p;


}
//��ʼ�����ű�
void InitSymbolTab(SymbolTab* ST)
{
    ST->S.top = -1;
    InitList(ST->map[0]);
    AddSymbolTab(ST);
}
//���ҹ���-�ڵ�ǰջ�ڲ���
Value* SymbolTabLookup(SymbolTab* ST, char* name)//����value-name����value
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
//�ڵ�ǰ���������
void InsertSymbolTab(SymbolTab* ST, char* name, Value value)
{
    sc_map_put_sv(ST->map[ST->top]->map, name, value);
}
//��ָ���Ĺ�ϣ�������value
void InsertSymbolTab_spe(SymbolTab* ST, struct sc_map_sv* map, char* name, struct _Value* value)
{
    sc_map_put_sv(map, name, value);
}


//ɾ��һ��ջ
void DelateSymbolTab(SymbolTab* ST)
{
    ST->top--;
}




