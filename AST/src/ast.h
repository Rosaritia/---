#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"


typedef struct ASTNode {
    char* type;     //�ڵ�����
    struct ASTNode* left;
    struct ASTNode* right;
    int int_val;    //��������
    float float_val;    //����������
    char* symbol_val;   //���ڴ�ű�ʶ��
    char* inf;  //������Ϣ
}ASTNode;

ASTNode* new_node(const char* type, ASTNode* left, ASTNode* right, int int_val, float float_val, char* symbol_val,const char* inf);//�����µĽڵ�

void print_node(ASTNode* root, int layer);//��ӡ��ǰ�ڵ�

void display(struct ASTNode* root);  //����ݹ����

#endif
