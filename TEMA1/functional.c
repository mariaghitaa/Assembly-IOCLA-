#include "functional.h"
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void for_each(void (*func)(void *), array_t list)
{
	int i;
	for (i = 0; i < list.len; i++)
	{
		void *elem = (char *)list.data + i * list.elem_size;
		func(elem);
	}
}

array_t map(void (*func)(void *, void *),
			int new_list_elem_size,
			void (*new_list_destructor)(void *),
			array_t list)
{	int i;
	array_t new_list;
	new_list.elem_size = new_list_elem_size;
	new_list.len = list.len;
	new_list.destructor = new_list_destructor;
	new_list.data = malloc(new_list.elem_size * new_list.len);
	for (i = 0; i < new_list.len; i++)
	{
		void *elem = (char *)list.data + i * list.elem_size;
		void *new_elem = (char *)new_list.data + i * new_list.elem_size;
		func(new_elem, elem);
	}
	for (i = 0; i < list.len; i++)
	{
		void *elem = (char *)list.data + i * list.elem_size;
		if (list.destructor)
			list.destructor(elem);
	}
	free(list.data);
	return new_list;
}

array_t filter(boolean(*func)(void *), array_t list)
{
	int cnt = 0;
	int i;
	array_t lista;
	lista.elem_size = list.elem_size;
	lista.destructor = list.destructor;
	lista.data = malloc(list.len * list.elem_size);
	for (i = 0; i < list.len; i++)
	{
		if (func(list.data + i * list.elem_size))
		{
			memcpy(lista.data + cnt * list.elem_size,
				   list.data + i * list.elem_size,
				   list.elem_size);
			cnt++;
		}
	}
	lista.len = cnt;
	for (i = 0; i < list.len; i++)
	{
		void *elem = (char *)list.data + i * list.elem_size;
		if (list.destructor)
			list.destructor(elem);
	}
	free(list.data);
	(void)func;
	(void)list;
	return lista;
}

void *reduce(void (*func)(void *, void *), void *acc, array_t list)
{
	int i;
	for (i = 0; i < list.len; i++)
	{
		void *elem = (char *)list.data + i * list.elem_size;
		func(acc, elem);
	}
	return acc;
}

void for_each_multiple(void(*func)(void **), int varg_c, ...)
{
	int i, j, min_len = 100000000;
	va_list arg_list;
	va_start(arg_list, varg_c);
	for (i = 0; i < varg_c; i++)
	{
		array_t arr = va_arg(arg_list, array_t);
		if (arr.len < min_len)
		{
			min_len = arr.len;
		}
	}
	va_end(arg_list);
	void **v = (void **)malloc(varg_c * sizeof(void *));
	for (i = 0; i < min_len; i++)
	{
		va_start(arg_list, varg_c);
		for (j = 0; j < varg_c; j++)
		{
			array_t arr = va_arg(arg_list, array_t);
			v[j] = arr.data + i * arr.elem_size;
		}
		va_end(arg_list);
		func(v);
	}
	free(v);
}

array_t map_multiple(void (*func)(void *, void **),
					 int new_list_elem_size,
					 void (*new_list_destructor)(void *),
					 int varg_c, ...)
{
	int i, j, min_len = 100000000;
	va_list arg_list;
	va_start(arg_list, varg_c);
	for (i = 0; i < varg_c; i++)
	{
		array_t arr = va_arg(arg_list, array_t);
		if (arr.len < min_len)
		{
			min_len = arr.len;
		}
	}
	va_end(arg_list);
	array_t new_list;
	new_list.elem_size = new_list_elem_size;
	new_list.len = min_len;
	new_list.destructor = new_list_destructor;
	new_list.data = malloc(min_len * new_list_elem_size);
	void **v = (void **)malloc(varg_c * sizeof(void *));
	for (i = 0; i < min_len; i++)
	{
		va_start(arg_list, varg_c);
		for (j = 0; j < varg_c; j++)
		{
			array_t arr = va_arg(arg_list, array_t);
			v[j] = arr.data + i * arr.elem_size;
		}
		va_end(arg_list);
		func((char *)new_list.data + i * new_list_elem_size, v);
	}
	free(v);
	va_start(arg_list, varg_c);
	for (i = 0; i < varg_c; i++)
	{
		array_t tmp = va_arg(arg_list, array_t);
		if (tmp.destructor)
		{
			for (j = 0; j < tmp.len; j++)
			{
				void *elem = (char *)tmp.data + j * tmp.elem_size;
				tmp.destructor(elem);
			}
		}
		free(tmp.data);
	}
	va_end(arg_list);
	return new_list;
}

void *reduce_multiple(void(*func)(void *, void **), void *acc, int varg_c, ...)
{
	int i, min_len = 100000000;
	va_list arg_list;
	va_start(arg_list, varg_c);
	for (i = 0; i < varg_c; i++)
	{
		array_t arr = va_arg(arg_list, array_t);
		if (arr.len < min_len)
		{
			min_len = arr.len;
		}
	}
	va_end(arg_list);
	void **v = (void **)malloc(varg_c * sizeof(void *));
	int index;
	int j;
	for (index = 0; index < min_len; index++)
	{
		va_list args_list;
		va_start(args_list, varg_c);
		for (j = 0; j < varg_c; j++)
		{
			array_t arr = va_arg(args_list, array_t);
			v[j] = arr.data + index * arr.elem_size;
		}
		va_end(args_list);
		func(acc, v);
	}
	free(v);
	return acc;
}
