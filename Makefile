all: build-all run-all

build-all: build-time build-static build-shared build-dynamic

run-all: test-static test-shared test-dynamic

build-static: build-objects-static build-libs-static build-main build-exec

build-objects-static: table_manager.c table_manager_static.c
	gcc -c table_manager.c table_manager_static.c

build-libs-static: table_manager.o table_manager_static.o
	ar rcs table_manager.a table_manager.o
	ar rcs table_manager_static.a table_manager_static.o

build-time: time_full.c
	gcc -c time_full.c

build-main: main.c
	gcc -c main.c

build-exec: main.o  table_manager.a table_manager_static.a
	gcc main.o time_full.o table_manager.a table_manager_static.a -o main

build-shared:
	gcc -fPIC -c table_manager.c table_manager_static.c
	gcc -shared -o table_manager.so table_manager.o
	gcc -shared -o table_manager_static.so table_manager_static.o
	gcc  main.c time_full.o table_manager.so table_manager_static.so -L. -Wl,-rpath=. -o main_shared

build-dynamic:
	gcc -fPIC -c table_manager.c table_manager_static.c
	gcc -shared -o table_manager.so table_manager.o
	gcc -shared -o table_manager_static.so table_manager_static.o
	gcc main_dynamic.c time_full.o -o main_dynamic -ldl

test-static:
	$(info ######TESTING STATIC LIBRARY#######)
	./main 10000 10000 0 10
	./main 10000 10000 1 10

test-shared:
	$(info ######TESTING SHARED LIBRARY#######)
	./main_shared 10000 10000 0 10
	./main_shared 10000 10000 1 10

test-dynamic:
	$(info ######TESTING DYNAMIC LIBRARY#######)
	./main_dynamic 10000 10000 0 10
	./main_dynamic 10000 10000 1 10
