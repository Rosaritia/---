#include "ast.h"
#include "parser.tab.h"  //由bison根据parser.y生成
int currentlayer = 1;


ASTNode* new_node(const char* type, ASTNode* left, ASTNode* right, int int_val, float float_val, char* symbol_val, const char* inf)
{
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = (char*)malloc(strlen(type) + 1); // 分配足够的内存
    strcpy(n->type, type);
    n->left = left;
    n->right = right;
    n->int_val = int_val;
    n->float_val = float_val;
    n->symbol_val = symbol_val;
    if (inf != NULL)
    {   
        n->inf = (char*)malloc(strlen(inf) + 1); // 分配足够的内存
        strcpy(n->inf, inf);

    }
    
    return n;
}
void print_node(struct ASTNode* root, int layer)
{
    for (int i = 1; i < layer; i++)
    {
        printf("  ");
    }
    printf("%s:", root->type);
    if (root->inf != NULL)
        printf("%s  ", root->inf);
    if (root->int_val != 0)
        printf("%d  ", root->int_val);
    if (root->float_val != 0)
        printf("%f  ", root->float_val);
    if (root->symbol_val != NULL)
        printf("%s  ", root->symbol_val);
    
    printf("\n");
    return;
}
void display(ASTNode* root)  //先序递归遍历打印
{

    currentlayer++;
    if (root == NULL)
    {
        currentlayer--;
        return; //结束条件
    }
    print_node(root, currentlayer);         //用于打印当前指针指向的数据域中存放的数据
    display(root->left); //按照先序遍历的顺序，现在指针应该指向左子树节点

    display(root->right); //按照先序遍历的顺序，最后指针应该指向右子树节点
    currentlayer--;


}