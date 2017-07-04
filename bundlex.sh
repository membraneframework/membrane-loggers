#!/bin/sh
cc -fPIC -W -dynamiclib -undefined dynamic_lookup -o membrane_loggers_console.so -I"/usr/local/Cellar/erlang/19.3/lib/erlang/usr/include" -I"../membrane_common_c/c_src" -I"./deps/membrane_common_c/c_src"   "c_src/console.c"
