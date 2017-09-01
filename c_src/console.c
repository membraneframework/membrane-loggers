/**
 * Membrane Logger
 *
 * All Rights Reserved, (c) 2016 Mateusz Nowak
 */

 #include <erl_nif.h>
 #include <string.h>
 #include <membrane/membrane.h>

#define MAX_LEVEL_ATOM_LEN 10
#define BINARY_TRUNC_SIZE 30

#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KCYA  "\x1B[36m"
#define KWHT  "\x1B[37m"


int load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM load_info) {
  return 0;
}


static ERL_NIF_TERM export_log_prefix(ErlNifEnv *env, int arg, const ERL_NIF_TERM argv[])
{
  long timestamp;

  MEMBRANE_UTIL_PARSE_ATOM_ARG(0, level_atom_buf, MAX_LEVEL_ATOM_LEN)

  if(!enif_get_long(env, argv[1], &timestamp)) {
    return membrane_util_make_error_args(env, "timestamp", "Passed timestamp is not a valid long");
  }

  if(!strcmp(level_atom_buf, "debug")) {
    printf("%ld [debug] %s", timestamp, KCYA);
  } else if(!strcmp(level_atom_buf, "info")) {
    printf("%ld [info] %s", timestamp, KGRN);
  } else if(!strcmp(level_atom_buf, "warn")){
    printf("%ld [warn] %s", timestamp, KYEL);
  } else {
    return membrane_util_make_error_args(env, "level", "Should be one of :debug, :info, :warn");
  }

  return membrane_util_make_ok(env);
}


static ERL_NIF_TERM export_log_number(ErlNifEnv *env, int arg, const ERL_NIF_TERM argv[])
{
  long number;

  if(!enif_get_long(env, argv[0], &number)) {
    return membrane_util_make_error_args(env, "term_list", "Passed invalid long");
  }
  printf("%ld", number);
  return membrane_util_make_ok(env);
}


static ERL_NIF_TERM export_log_text(ErlNifEnv *env, int arg, const ERL_NIF_TERM argv[])
{
  MEMBRANE_UTIL_PARSE_BINARY_ARG(0, binary)
  printf("%.*s", binary.size, binary.data);
  return membrane_util_make_ok(env);
}

static ERL_NIF_TERM export_log_binary(ErlNifEnv *env, int arg, const ERL_NIF_TERM argv[])
{
  MEMBRANE_UTIL_PARSE_BINARY_ARG(0, binary)
  printf("<<");
  int bytes_to_write = binary.size;
  if(bytes_to_write > BINARY_TRUNC_SIZE) {
    bytes_to_write = BINARY_TRUNC_SIZE;
  }

  for (int i = 0; i < bytes_to_write; i++) {
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



static ERL_NIF_TERM export_log_sufix(ErlNifEnv *env, int arg, const ERL_NIF_TERM argv[])
{
  printf("%s\r\n", KWHT);
  return membrane_util_make_ok(env);
}

static ErlNifFunc nif_funcs[] =
{
  {"log_prefix", 2, export_log_prefix},
  {"log_sufix", 0, export_log_sufix},
  {"log_text", 1, export_log_text},
  {"log_number", 1, export_log_number},
  {"log_binary", 1, export_log_binary}
};

ERL_NIF_INIT(Elixir.Membrane.Loggers.ConsoleNative, nif_funcs, load, NULL, NULL, NULL)
