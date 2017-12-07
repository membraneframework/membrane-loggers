/**
 * Membrane Logger
 *
 * All Rights Reserved, (c) 2016 Mateusz Nowak
 */

#include <erl_nif.h>
#include <string.h>
#include <stdio.h>
#include <membrane/membrane.h>

#define MAX_LEVEL_ATOM_LEN 10
#define BINARY_TRUNC_SIZE 30

#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KCYA  "\x1B[36m"
#define KWHT  "\x1B[37m"

#define UNUSED(x) (void)(x)


int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  UNUSED(env);
  UNUSED(priv_data);
  UNUSED(load_info);
  return 0;
}

static char* format_tags(ErlNifEnv *env, ERL_NIF_TERM tags) {

  size_t output_len = 0;
  unsigned tags_len;

  // check if tags is a valid list
  if(!enif_get_list_length(env, tags, &tags_len)) {
    return NULL;
  }

  ERL_NIF_TERM cell, list = tags;

  // calculate size of the output string
  while(enif_get_list_cell(env, list, &cell, &list)) {
    unsigned atom_len;
    if(!enif_get_atom_length(env, cell, &atom_len, ERL_NIF_LATIN1)) {
      return NULL;
    }

    output_len += 1 + atom_len;
  }

  // alocate memory for output string
  char *output = enif_alloc(output_len);
  char *output_it = output;

  list = tags;

  // fill allocated memomory with tags
  while(enif_get_list_cell(env, list, &cell, &list)) {
    int atom_len;
    output_it += atom_len = enif_get_atom(env, cell, output_it, output_len - (output_it - output), ERL_NIF_LATIN1);

    if(atom_len <= 0) {
      return NULL;
    }

    // replace NULL-byte with space
    *(output_it-1) = ' ';
  }

  *(output_it-1) = 0;

  return output;
}

static ERL_NIF_TERM export_log_prefix(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  UNUSED(argc);

  MEMBRANE_UTIL_PARSE_ATOM_ARG(0, level, MAX_LEVEL_ATOM_LEN)

  MEMBRANE_UTIL_PARSE_BINARY_ARG(1, time)

  char *tags_string = format_tags(env, argv[2]);

  if(!tags_string) {
    return membrane_util_make_error_args(env, "tags", "Passed 'tag list' is not a valid list with atoms");
  }

  if(!strcmp(level, "debug")) {
    printf("%s%.*s [debug] [%s] ", KCYA, (int)time.size, time.data, tags_string);
  } else if(!strcmp(level, "info")) {
    printf("%s%.*s [info] [%s] ", KGRN, (int)time.size, time.data, tags_string);
  } else if(!strcmp(level, "warn")){
    printf("%s%.*s [warn] [%s] ", KYEL, (int)time.size, time.data, tags_string);
  } else {
    return membrane_util_make_error_args(env, "level", "Should be one of :debug, :info, :warn");
  }

  enif_free(tags_string);

  return membrane_util_make_ok(env);
}


static ERL_NIF_TERM export_log_number(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  UNUSED(argc);
  long number;

  if(!enif_get_long(env, argv[0], &number)) {
    return membrane_util_make_error_args(env, "term_list", "Passed invalid long");
  }
  printf("%ld", number);
  return membrane_util_make_ok(env);
}


static ERL_NIF_TERM export_log_text(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  UNUSED(argc);

  MEMBRANE_UTIL_PARSE_BINARY_ARG(0, binary)
  printf("%.*s", (int)binary.size, binary.data);
  return membrane_util_make_ok(env);
}

static ERL_NIF_TERM export_log_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  UNUSED(argc);

  MEMBRANE_UTIL_PARSE_BINARY_ARG(0, binary)
  printf("<<");
  unsigned bytes_to_write = binary.size;
  if(bytes_to_write > BINARY_TRUNC_SIZE) {
    bytes_to_write = BINARY_TRUNC_SIZE;
  }

  for (unsigned i = 0; i < bytes_to_write; i++) {
    printf("%d", (int)binary.data[i]);
    if (i != bytes_to_write - 1) {
      printf(", ");
    }
  }

  if (bytes_to_write < binary.size) {
    printf(", ...");
  }

  printf(">>");
  return membrane_util_make_ok(env);
}



static ERL_NIF_TERM export_log_sufix(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  UNUSED(argc);
  UNUSED(argv);

  printf("%s\r\n", KWHT);
  return membrane_util_make_ok(env);
}

static ErlNifFunc nif_funcs[] =
{
  {"log_prefix", 3, export_log_prefix, 0},
  {"log_sufix", 0, export_log_sufix, 0},
  {"log_text", 1, export_log_text, 0},
  {"log_number", 1, export_log_number, 0},
  {"log_binary", 1, export_log_binary, 0}
};

ERL_NIF_INIT(Elixir.Membrane.Loggers.ConsoleNative, nif_funcs, load, NULL, NULL, NULL)
