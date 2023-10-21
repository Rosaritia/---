#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"


typedef struct ASTNode {
    char* type;     //节点类型
    struct ASTNode* left;
    struct ASTNode* right;
    int int_val;    //整型数据
    float float_val;    //浮点型数据
    char* symbol_val;   //用于存放标识符
    char* inf;  //更多信息
}ASTNode;

ASTNode* new_node(const char* type, ASTNode* left, ASTNode* right, int int_val, float float_val, char* symbol_val,const char* inf);//创建新的节点

void print_node(ASTNode* root, int layer);//打印当前节点

void display(struct ASTNode* root);  //先序递归遍历

#endif
