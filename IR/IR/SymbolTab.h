#pragma once
#ifndef SYMTAB_H
#define SYMTAB_H

#include "sc_map.h"
#include "Value.h"

typedef struct Hashmap
{
	struct sc_map_sv* map;//key type��Ϊvalue-name
	int layer; //�����ڵĲ���
	struct Hashmap* next;//���й�ϵ
	struct Hashmap* child//�ӹ�ϵ��Ƕ�׹�ϵ��

}Hashmap;

typedef struct SymbolTab //���ű�����ݽṹ������
{
	int top;
	Hashmap* map[250];//ջ������Ϊ��ϣ��
	
}SymbolTab;

//��ʼ������
void InitList(Hashmap* M)//M����ͷ�ڵ�
//�µ�һ����ű�
void AddSymbolTab(SymbolTab* ST)//����һ���µ�ջ
//��ʼ�����ű�
void InitSymbolTab(SymbolTab* ST)
//���ҹ���-�ڵ�ǰջ�ڲ���
Value* SymbolTabLookup(SymbolTab* ST, char* name)
//�ڵ�ǰ���������
void InsertSymbolTab(SymbolTab* ST, char* name, Value value)
//��ָ���Ĺ�ϣ�������value
void InsertSymbolTab_spe(SymbolTab* ST, struct sc_map_sv* map, char* name, struct _Value* value)
//ɾ��һ��ջ
void DelateSymbolTab(SymbolTab* ST)
#endif // !SYMTAB_H

