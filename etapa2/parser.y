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

%%

programa: decl
    |
    ;

decl: global_var ';' decl
    | funcao decl
    |
    ;

funcao: tipo TK_IDENTIFIER '(' parametros ')' bloco_cmd ';'
    ;

tipo: KW_CHAR
    | KW_INT
    | KW_FLOAT
    ;

parametros: tipo TK_IDENTIFIER ','
    |
    ;

bloco_cmd: '{' cmd_simples ';' '}'
    | ';'
    ;

cmd_simples: TK_IDENTIFIER '=' expr cmd_simples
    | TK_IDENTIFIER '[' expr ']' '=' expr cmd_simples
    | KW_PRINT '(' print_values ')' cmd_simples
    | KW_RETURN return_values cmd_simples
    | if_statement cmd_simples
    | while_statement cmd_simples
    | label cmd_simples
    | KW_READ cmd_simples
    | ';'
    ;

print_values: LIT_STRING
    | expr
    ;

return_values: expr
    ;

expr: LIT_INTEGER
    | LIT_CHAR
    | LIT_STRING
    | TK_IDENTIFIER
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr OPERATOR_EQ expr
    | expr OPERATOR_GE expr
    | expr OPERATOR_LE expr
    | expr OPERATOR_DIF expr
    | '(' expr ')'
    | KW_READ
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

if_statement: KW_IF expr KW_THEN bloco_cmd
    | KW_IF expr KW_THEN cmd_simples
    | KW_IF expr KW_THEN bloco_cmd KW_ELSE bloco_cmd
    | KW_IF expr KW_THEN bloco_cmd KW_ELSE cmd_simples
    | KW_IF expr KW_THEN cmd_simples KW_ELSE bloco_cmd
    | KW_IF expr KW_THEN cmd_simples KW_ELSE cmd_simples
    ;

while_statement: KW_WHILE expr bloco_cmd
    ;

label: TK_IDENTIFIER ':'
    ;


%%

int yyerror ()
{
  fprintf(stderr, "Syntax error at line %d.\n", getLineNumber());
  exit(3);
}