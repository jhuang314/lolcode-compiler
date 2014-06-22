/**********************************************
        CS415  Compilers  Project2
**********************************************/

#ifndef ATTR_H
#define ATTR_H

typedef union {char* str; int num; float f;} tokentype;

typedef enum {
     YARN_T, NUMBR_T, NUMBAR_T, TROOF_T,     
     INVALID_T
} type_t;

typedef struct id {
     char *name;
     int low, high;
     type_t type;
     struct id *next;
} id_list_t;

int id_list_insert(char *name);

#endif
