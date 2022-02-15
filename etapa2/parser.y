%token KW_CHAR 
%token KW_INT
%token KW_FLOAT

%token KW_IF 
%token KW_THEN 
%token KW_ELSE 
%token KW_WHILE
%token KW_GOTO 
%token KW_READ 
%token KW_PRINT
%token KW_RETURN 

%token OPERATOR_LE 
%token OPERATOR_GE 
%token OPERATOR_EQ 
%token OPERATOR_DIF

%token TK_IDENTIFIER 

%token LIT_INTEGER 
%token LIT_CHAR
%token LIT_STRING

%token TOKEN_ERROR

%left '<' '>' OPERATOR_DIF OPERATOR_EQ OPERATOR_GE OPERATOR_LE
%left '+' '-'
%left '*' '/'

%%

programa: decl
    ;

decl: global_var ';' decl
    | function decl
    |
    ;

function: type TK_IDENTIFIER '(' params ')' cmd_block
    ;

type: KW_CHAR
    | KW_INT
    | KW_FLOAT
    ;

params: type TK_IDENTIFIER more_params
    |
    ;

more_params: ',' type TK_IDENTIFIER more_params
    |
    ;

cmd_block: '{' simple_cmd ';' '}'
    | ';'
    ;

simple_cmd: label simple_cmd
    | KW_READ simple_cmd
    | ';'
    |
    ;


global_var: KW_CHAR TK_IDENTIFIER ':' arr_element
    | KW_CHAR TK_IDENTIFIER '[' LIT_INTEGER ']' initialized_array
    | KW_INT TK_IDENTIFIER ':' arr_element
    | KW_INT TK_IDENTIFIER '[' LIT_INTEGER ']' initialized_array
    | KW_FLOAT TK_IDENTIFIER ':' LIT_INTEGER '/' LIT_INTEGER
    ;

initialized_array: ':' arr_elements
    |
    ;

arr_elements: arr_element more_elements
    ;

more_elements: arr_elements
    |
    ;

arr_element: LIT_INTEGER
    | LIT_CHAR
    ;

array: '[' array_size ']'
    ;

array_size: LIT_INTEGER
    |
    ;

label: TK_IDENTIFIER ':'
    ;


%%

int yyerror ()
{
  fprintf(stderr, "Syntax error at line %d %s.\n", getLineNumber(), yytext);
  exit(3);
}