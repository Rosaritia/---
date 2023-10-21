#include "ast.h"
#include "parser.tab.h"  //��bison����parser.y����
int currentlayer = 1;


ASTNode* new_node(const char* type, ASTNode* left, ASTNode* right, int int_val, float float_val, char* symbol_val, const char* inf)
{
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->type = (char*)malloc(strlen(type) + 1); // �����㹻���ڴ�
    strcpy(n->type, type);
    n->left = left;
    n->right = right;
    n->int_val = int_val;
    n->float_val = float_val;
    n->symbol_val = symbol_val;
    if (inf != NULL)
    {   
        n->inf = (char*)malloc(strlen(inf) + 1); // �����㹻���ڴ�
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
void display(ASTNode* root)  //����ݹ������ӡ
{

    currentlayer++;
    if (root == NULL)
    {
        currentlayer--;
        return; //��������
    }
    print_node(root, currentlayer);         //���ڴ�ӡ��ǰָ��ָ����������д�ŵ�����
    display(root->left); //�������������˳������ָ��Ӧ��ָ���������ڵ�

    display(root->right); //�������������˳�����ָ��Ӧ��ָ���������ڵ�
    currentlayer--;


}