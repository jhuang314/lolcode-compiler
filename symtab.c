/**********************************************
        CS415  Compilers  Project2
**********************************************/

#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "symtab.h"

//extern void * malloc(int size);

id_list_t *variables = NULL;


void insert_var(id_list_t *var)
{
	assert(var);
	id_list_t *it = variables;
	for (;it != NULL; it = it->next)
		if (strcmp(var->name, it->name) == 0) {
			fprintf(stderr,
			    "\n***Error: duplicate declaration of %s\n",
			    it->name);
			return;
		}

	var->next = variables;
	variables = var;
}

void symtab_insert(id_list_t *vars, type_t type)
{
	assert(vars);
	id_list_t * it = vars;
	while (it != NULL) {
		id_list_t * old = it;
		it = it->next;
		old->type = type;
		insert_var(old);
	}
}

type_t symtab_find(const char *name)
{
	id_list_t *it = variables;
	for (;it != NULL; it = it->next)
		if (strcmp(name, it->name) == 0) {
			return it->type;
		}
	return INVALID_T;
}
