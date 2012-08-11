/* C version of M3CG_Binary. */
/* This file is generated by m3cggen. */

#define M3CG_Version  0x100

typedef enum {
  M3CG_BEGIN_UNIT,             /* 0 */
  M3CG_END_UNIT,               /* 1 */
  M3CG_IMPORT_UNIT,            /* 2 */
  M3CG_EXPORT_UNIT,            /* 3 */
  M3CG_SET_SOURCE_FILE,        /* 4 */
  M3CG_SET_SOURCE_LINE,        /* 5 */
  M3CG_DECLARE_TYPENAME,       /* 6 */
  M3CG_DECLARE_ARRAY,          /* 7 */
  M3CG_DECLARE_OPEN_ARRAY,     /* 8 */
  M3CG_DECLARE_ENUM,           /* 9 */
  M3CG_DECLARE_ENUM_ELT,       /* 10 */
  M3CG_DECLARE_PACKED,         /* 11 */
  M3CG_DECLARE_RECORD,         /* 12 */
  M3CG_DECLARE_FIELD,          /* 13 */
  M3CG_DECLARE_SET,            /* 14 */
  M3CG_DECLARE_SUBRANGE,       /* 15 */
  M3CG_DECLARE_POINTER,        /* 16 */
  M3CG_DECLARE_INDIRECT,       /* 17 */
  M3CG_DECLARE_PROCTYPE,       /* 18 */
  M3CG_DECLARE_FORMAL,         /* 19 */
  M3CG_DECLARE_RAISES,         /* 20 */
  M3CG_DECLARE_OBJECT,         /* 21 */
  M3CG_DECLARE_METHOD,         /* 22 */
  M3CG_DECLARE_OPAQUE,         /* 23 */
  M3CG_REVEAL_OPAQUE,          /* 24 */
  M3CG_DECLARE_EXCEPTION,      /* 25 */
  M3CG_SET_RUNTIME_PROC,       /* 26 */
  M3CG_IMPORT_GLOBAL,          /* 27 */
  M3CG_DECLARE_SEGMENT,        /* 28 */
  M3CG_BIND_SEGMENT,           /* 29 */
  M3CG_DECLARE_GLOBAL,         /* 30 */
  M3CG_DECLARE_CONSTANT,       /* 31 */
  M3CG_DECLARE_LOCAL,          /* 32 */
  M3CG_DECLARE_PARAM,          /* 33 */
  M3CG_DECLARE_TEMP,           /* 34 */
  M3CG_FREE_TEMP,              /* 35 */
  M3CG_BEGIN_INIT,             /* 36 */
  M3CG_END_INIT,               /* 37 */
  M3CG_INIT_INT,               /* 38 */
  M3CG_INIT_PROC,              /* 39 */
  M3CG_INIT_LABEL,             /* 40 */
  M3CG_INIT_VAR,               /* 41 */
  M3CG_INIT_OFFSET,            /* 42 */
  M3CG_INIT_CHARS,             /* 43 */
  M3CG_INIT_FLOAT,             /* 44 */
  M3CG_IMPORT_PROCEDURE,       /* 45 */
  M3CG_DECLARE_PROCEDURE,      /* 46 */
  M3CG_BEGIN_PROCEDURE,        /* 47 */
  M3CG_END_PROCEDURE,          /* 48 */
  M3CG_BEGIN_BLOCK,            /* 49 */
  M3CG_END_BLOCK,              /* 50 */
  M3CG_NOTE_PROCEDURE_ORIGIN,  /* 51 */
  M3CG_SET_LABEL,              /* 52 */
  M3CG_JUMP,                   /* 53 */
  M3CG_IF_TRUE,                /* 54 */
  M3CG_IF_FALSE,               /* 55 */
  M3CG_IF_EQ,                  /* 56 */
  M3CG_IF_NE,                  /* 57 */
  M3CG_IF_GT,                  /* 58 */
  M3CG_IF_GE,                  /* 59 */
  M3CG_IF_LT,                  /* 60 */
  M3CG_IF_LE,                  /* 61 */
  M3CG_CASE_JUMP,              /* 62 */
  M3CG_EXIT_PROC,              /* 63 */
  M3CG_LOAD,                   /* 64 */
  M3CG_LOAD_ADDRESS,           /* 65 */
  M3CG_LOAD_INDIRECT,          /* 66 */
  M3CG_STORE,                  /* 67 */
  M3CG_STORE_INDIRECT,         /* 68 */
  M3CG_LOAD_NIL,               /* 69 */
  M3CG_LOAD_INTEGER,           /* 70 */
  M3CG_LOAD_FLOAT,             /* 71 */
  M3CG_EQ,                     /* 72 */
  M3CG_NE,                     /* 73 */
  M3CG_GT,                     /* 74 */
  M3CG_GE,                     /* 75 */
  M3CG_LT,                     /* 76 */
  M3CG_LE,                     /* 77 */
  M3CG_ADD,                    /* 78 */
  M3CG_SUBTRACT,               /* 79 */
  M3CG_MULTIPLY,               /* 80 */
  M3CG_DIVIDE,                 /* 81 */
  M3CG_NEGATE,                 /* 82 */
  M3CG_ABS,                    /* 83 */
  M3CG_MAX,                    /* 84 */
  M3CG_MIN,                    /* 85 */
  M3CG_ROUND,                  /* 86 */
  M3CG_TRUNC,                  /* 87 */
  M3CG_FLOOR,                  /* 88 */
  M3CG_CEILING,                /* 89 */
  M3CG_CVT_FLOAT,              /* 90 */
  M3CG_DIV,                    /* 91 */
  M3CG_MOD,                    /* 92 */
  M3CG_SET_UNION,              /* 93 */
  M3CG_SET_DIFFERENCE,         /* 94 */
  M3CG_SET_INTERSECTION,       /* 95 */
  M3CG_SET_SYM_DIFFERENCE,     /* 96 */
  M3CG_SET_MEMBER,             /* 97 */
  M3CG_SET_EQ,                 /* 98 */
  M3CG_SET_NE,                 /* 99 */
  M3CG_SET_LT,                 /* 100 */
  M3CG_SET_LE,                 /* 101 */
  M3CG_SET_GT,                 /* 102 */
  M3CG_SET_GE,                 /* 103 */
  M3CG_SET_RANGE,              /* 104 */
  M3CG_SET_SINGLETON,          /* 105 */
  M3CG_NOT,                    /* 106 */
  M3CG_AND,                    /* 107 */
  M3CG_OR,                     /* 108 */
  M3CG_XOR,                    /* 109 */
  M3CG_SHIFT,                  /* 110 */
  M3CG_SHIFT_LEFT,             /* 111 */
  M3CG_SHIFT_RIGHT,            /* 112 */
  M3CG_ROTATE,                 /* 113 */
  M3CG_ROTATE_LEFT,            /* 114 */
  M3CG_ROTATE_RIGHT,           /* 115 */
  M3CG_WIDEN,                  /* 116 */
  M3CG_CHOP,                   /* 117 */
  M3CG_EXTRACT,                /* 118 */
  M3CG_EXTRACT_N,              /* 119 */
  M3CG_EXTRACT_MN,             /* 120 */
  M3CG_INSERT,                 /* 121 */
  M3CG_INSERT_N,               /* 122 */
  M3CG_INSERT_MN,              /* 123 */
  M3CG_SWAP,                   /* 124 */
  M3CG_POP,                    /* 125 */
  M3CG_COPY_N,                 /* 126 */
  M3CG_COPY,                   /* 127 */
  M3CG_ZERO_N,                 /* 128 */
  M3CG_ZERO,                   /* 129 */
  M3CG_LOOPHOLE,               /* 130 */
  M3CG_ABORT,                  /* 131 */
  M3CG_CHECK_NIL,              /* 132 */
  M3CG_CHECK_LO,               /* 133 */
  M3CG_CHECK_HI,               /* 134 */
  M3CG_CHECK_RANGE,            /* 135 */
  M3CG_CHECK_INDEX,            /* 136 */
  M3CG_CHECK_EQ,               /* 137 */
  M3CG_ADD_OFFSET,             /* 138 */
  M3CG_INDEX_ADDRESS,          /* 139 */
  M3CG_START_CALL_DIRECT,      /* 140 */
  M3CG_CALL_DIRECT,            /* 141 */
  M3CG_START_CALL_INDIRECT,    /* 142 */
  M3CG_CALL_INDIRECT,          /* 143 */
  M3CG_POP_PARAM,              /* 144 */
  M3CG_POP_STRUCT,             /* 145 */
  M3CG_POP_STATIC_LINK,        /* 146 */
  M3CG_LOAD_PROCEDURE,         /* 147 */
  M3CG_LOAD_STATIC_LINK,       /* 148 */
  M3CG_COMMENT,                /* 149 */
  M3CG_STORE_ORDERED,          /* 150 */
  M3CG_LOAD_ORDERED,           /* 151 */
  M3CG_EXCHANGE,               /* 152 */
  M3CG_COMPARE_EXCHANGE,       /* 153 */
  M3CG_FENCE,                  /* 154 */
  M3CG_FETCH_AND_ADD,          /* 155 */
  M3CG_FETCH_AND_SUB,          /* 156 */
  M3CG_FETCH_AND_OR,           /* 157 */
  M3CG_FETCH_AND_AND,          /* 158 */
  M3CG_FETCH_AND_XOR,          /* 159 */
  LAST_OPCODE } M3CG_opcode;

static const char *M3CG_opnames[] = {
  "begin_unit",             /* 0 */
  "end_unit",               /* 1 */
  "import_unit",            /* 2 */
  "export_unit",            /* 3 */
  "set_source_file",        /* 4 */
  "set_source_line",        /* 5 */
  "declare_typename",       /* 6 */
  "declare_array",          /* 7 */
  "declare_open_array",     /* 8 */
  "declare_enum",           /* 9 */
  "declare_enum_elt",       /* 10 */
  "declare_packed",         /* 11 */
  "declare_record",         /* 12 */
  "declare_field",          /* 13 */
  "declare_set",            /* 14 */
  "declare_subrange",       /* 15 */
  "declare_pointer",        /* 16 */
  "declare_indirect",       /* 17 */
  "declare_proctype",       /* 18 */
  "declare_formal",         /* 19 */
  "declare_raises",         /* 20 */
  "declare_object",         /* 21 */
  "declare_method",         /* 22 */
  "declare_opaque",         /* 23 */
  "reveal_opaque",          /* 24 */
  "declare_exception",      /* 25 */
  "set_runtime_proc",       /* 26 */
  "import_global",          /* 27 */
  "declare_segment",        /* 28 */
  "bind_segment",           /* 29 */
  "declare_global",         /* 30 */
  "declare_constant",       /* 31 */
  "declare_local",          /* 32 */
  "declare_param",          /* 33 */
  "declare_temp",           /* 34 */
  "free_temp",              /* 35 */
  "begin_init",             /* 36 */
  "end_init",               /* 37 */
  "init_int",               /* 38 */
  "init_proc",              /* 39 */
  "init_label",             /* 40 */
  "init_var",               /* 41 */
  "init_offset",            /* 42 */
  "init_chars",             /* 43 */
  "init_float",             /* 44 */
  "import_procedure",       /* 45 */
  "declare_procedure",      /* 46 */
  "begin_procedure",        /* 47 */
  "end_procedure",          /* 48 */
  "begin_block",            /* 49 */
  "end_block",              /* 50 */
  "note_procedure_origin",  /* 51 */
  "set_label",              /* 52 */
  "jump",                   /* 53 */
  "if_true",                /* 54 */
  "if_false",               /* 55 */
  "if_eq",                  /* 56 */
  "if_ne",                  /* 57 */
  "if_gt",                  /* 58 */
  "if_ge",                  /* 59 */
  "if_lt",                  /* 60 */
  "if_le",                  /* 61 */
  "case_jump",              /* 62 */
  "exit_proc",              /* 63 */
  "load",                   /* 64 */
  "load_address",           /* 65 */
  "load_indirect",          /* 66 */
  "store",                  /* 67 */
  "store_indirect",         /* 68 */
  "load_nil",               /* 69 */
  "load_integer",           /* 70 */
  "load_float",             /* 71 */
  "eq",                     /* 72 */
  "ne",                     /* 73 */
  "gt",                     /* 74 */
  "ge",                     /* 75 */
  "lt",                     /* 76 */
  "le",                     /* 77 */
  "add",                    /* 78 */
  "subtract",               /* 79 */
  "multiply",               /* 80 */
  "divide",                 /* 81 */
  "negate",                 /* 82 */
  "abs",                    /* 83 */
  "max",                    /* 84 */
  "min",                    /* 85 */
  "round",                  /* 86 */
  "trunc",                  /* 87 */
  "floor",                  /* 88 */
  "ceiling",                /* 89 */
  "cvt_float",              /* 90 */
  "div",                    /* 91 */
  "mod",                    /* 92 */
  "set_union",              /* 93 */
  "set_difference",         /* 94 */
  "set_intersection",       /* 95 */
  "set_sym_difference",     /* 96 */
  "set_member",             /* 97 */
  "set_eq",                 /* 98 */
  "set_ne",                 /* 99 */
  "set_lt",                 /* 100 */
  "set_le",                 /* 101 */
  "set_gt",                 /* 102 */
  "set_ge",                 /* 103 */
  "set_range",              /* 104 */
  "set_singleton",          /* 105 */
  "not",                    /* 106 */
  "and",                    /* 107 */
  "or",                     /* 108 */
  "xor",                    /* 109 */
  "shift",                  /* 110 */
  "shift_left",             /* 111 */
  "shift_right",            /* 112 */
  "rotate",                 /* 113 */
  "rotate_left",            /* 114 */
  "rotate_right",           /* 115 */
  "widen",                  /* 116 */
  "chop",                   /* 117 */
  "extract",                /* 118 */
  "extract_n",              /* 119 */
  "extract_mn",             /* 120 */
  "insert",                 /* 121 */
  "insert_n",               /* 122 */
  "insert_mn",              /* 123 */
  "swap",                   /* 124 */
  "pop",                    /* 125 */
  "copy_n",                 /* 126 */
  "copy",                   /* 127 */
  "zero_n",                 /* 128 */
  "zero",                   /* 129 */
  "loophole",               /* 130 */
  "abort",                  /* 131 */
  "check_nil",              /* 132 */
  "check_lo",               /* 133 */
  "check_hi",               /* 134 */
  "check_range",            /* 135 */
  "check_index",            /* 136 */
  "check_eq",               /* 137 */
  "add_offset",             /* 138 */
  "index_address",          /* 139 */
  "start_call_direct",      /* 140 */
  "call_direct",            /* 141 */
  "start_call_indirect",    /* 142 */
  "call_indirect",          /* 143 */
  "pop_param",              /* 144 */
  "pop_struct",             /* 145 */
  "pop_static_link",        /* 146 */
  "load_procedure",         /* 147 */
  "load_static_link",       /* 148 */
  "comment",                /* 149 */
  "store_ordered",          /* 150 */
  "load_ordered",           /* 151 */
  "exchange",               /* 152 */
  "compare_exchange",       /* 153 */
  "fence",                  /* 154 */
  "fetch_and_add",          /* 155 */
  "fetch_and_sub",          /* 156 */
  "fetch_and_or",           /* 157 */
  "fetch_and_and",          /* 158 */
  "fetch_and_xor",          /* 159 */
  0 };

#define M3CG_Int1        255
#define M3CG_NInt1       254
#define M3CG_Int2        253
#define M3CG_NInt2       252
#define M3CG_Int4        251
#define M3CG_NInt4       250
#define M3CG_Int8        249
#define M3CG_NInt8       248
#define M3CG_LastRegular 247