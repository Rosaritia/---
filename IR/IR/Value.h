#ifndef VALUE_H
#define VALUE_H

//value��use��û���������أ��ַ���д�Ĳ���ˣ�������

#include "SymbolTab.h"



typedef struct Value {
    Type* VTy;
    struct Use* UseList;
    char* name;
}Value;

#endif
