/**********************************************
        CS415  Compilers  Project2
**********************************************/

#ifndef SYMTAB_H
#define SYMTAB_H

#include "attr.h"

void symtab_insert(id_list_t *vars, type_t type);

type_t symtab_find(const char *name);

#endif
