#ifndef VALUE_H
#define VALUE_H

//value和use还没有下手呜呜，字符表写的差不多了，尽力了

#include "SymbolTab.h"



typedef struct Value {
    Type* VTy;
    struct Use* UseList;
    char* name;
}Value;

#endif
