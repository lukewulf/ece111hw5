package definitions;


typedef logic        Sign;
typedef logic [ 7:0] Exponent;
typedef logic [22:0] Mantissa;

typedef logic [23:0] Mantissa_ext;

typedef struct packed {
    Sign     sign;
    Exponent exp;
    Mantissa mnt;
} Float32;

typedef struct packed {
    Sign         sign;
    Exponent     exp;
    Mantissa_ext mnt;
} Float32_ext;

typedef struct packed {
    logic op;
    Float32 a;
    Float32 b;
} Compare_in;

typedef struct packed {
    logic        op;
    logic        flip;

    Float32 gt;
    Float32 lt;
    Exponent e_dif;
} Operate_in;

typedef struct packed {
    logic        op;
    logic        flip;

    Sign         sign;
    Exponent     exp;
    logic [24:0] mnt;
} Align_in;

endpackage
