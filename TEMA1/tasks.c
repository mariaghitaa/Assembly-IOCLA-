#include "functional.h"
#include "tasks.h"
#include "tests.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void add_first(void *list, void *elem) {
	array_t *ptr = (array_t *)list;
	ptr->data = realloc(ptr->data, (ptr->len + 1) * ptr->elem_size);
	memmove((char *)ptr->data + ptr->elem_size,
			ptr->data, ptr->len * ptr->elem_size);
	memcpy(ptr->data, elem, ptr->elem_size);
	ptr->len++;
}

array_t reverse(array_t list) {
	array_t rev;
	rev.len = 0;
	rev.elem_size = list.elem_size;
	rev.destructor = list.destructor;
	rev.data = NULL;
	reduce(add_first, &rev, list);
	return rev;
}

array_t create_number_array(array_t integer_part, array_t fractional_part) {
	(void)integer_part;
	(void)fractional_part;
	return (array_t){0};
}

boolean grade_student(void *s) {
	student_t *student = (student_t *)s;
	if (student->grade >= 5.0)
		return true;
	return false;
}

void extract_name(void *num, void *sr) {
	student_t *stud = (student_t *)sr;
	char **name = (char **)num;
	*name = malloc(strlen(stud->name) + 1);
	strcpy(*name, stud->name);
}

array_t get_passing_students_names(array_t list) {
	array_t passing_name = map(extract_name, sizeof(char *), NULL, list);
	return passing_name;
}

array_t check_bigger_sum(array_t list_list, array_t int_list) {
	(void)list_list;
	(void)int_list;
	return (array_t){0};
}

array_t get_even_indexed_strings(array_t list) {
	(void)list;
	return (array_t){0};
}

array_t generate_square_matrix(int n) {
	(void)n;
	return (array_t){0};
}
