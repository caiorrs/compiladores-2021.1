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

program: decl
    ;

decl: dec decl
    |
    ;

dec: function
    // | global_var
    |
    ;

function: type TK_IDENTIFIER '(' params ')' cmd_block
    | type TK_IDENTIFIER '('')' cmd_block
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

cmd_block: '{' simple_cmd '}'
    | ';'
    |
    ;

expr: KW_READ 
    | expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | expr '>' expr
    | expr '<' expr
    | expr OPERATOR_EQ expr
    | expr OPERATOR_GE expr
    | expr OPERATOR_LE expr
    | expr OPERATOR_DIF expr
    | '(' expr ')'
    | LIT_INTEGER
    | LIT_CHAR
    | LIT_STRING
    | TK_IDENTIFIER
    | function_call
    ;

function_call: TK_IDENTIFIER '(' call_parameters ')'
    | TK_IDENTIFIER '('')'

call_parameters: TK_IDENTIFIER more_call_params
    | LIT_CHAR more_call_params
    | LIT_INTEGER more_call_params
    | LIT_STRING more_call_params
    |
    ;

more_call_params: ',' call_parameters
    |
    ;

if_statement: KW_IF expr KW_THEN cmd_block ';'
    | KW_IF expr KW_THEN simple_cmd
    | KW_IF expr KW_THEN cmd_block KW_ELSE cmd_block ';'
    | KW_IF expr KW_THEN cmd_block KW_ELSE simple_cmd
    | KW_IF expr KW_THEN simple_cmd KW_ELSE cmd_block ';'
    | KW_IF expr KW_THEN simple_cmd KW_ELSE simple_cmd
    ;

while_statement: KW_WHILE expr cmd_block
    ;

label: TK_IDENTIFIER ':'
    ;

print_values: LIT_STRING more_print_values
    | TK_IDENTIFIER more_print_values
    | TK_IDENTIFIER '[' array_index ']'
    |
    ;

array_index: LIT_INTEGER
    ;

more_print_values: ',' print_values
    |
    ;

return_values: expr
    ;


simple_cmd: TK_IDENTIFIER '=' expr ';' simple_cmd
    // | TK_IDENTIFIER '=' TK_IDENTIFIER '-' TK_IDENTIFIER ';' simple_cmd
    // | KW_READ ';' simple_cmd
    | TK_IDENTIFIER '[' expr ']' '=' expr ';' simple_cmd
    | KW_PRINT print_values ';' simple_cmd
    | KW_RETURN return_values ';' simple_cmd
    | if_statement simple_cmd
    | while_statement ';' simple_cmd
    | label simple_cmd
    // | KW_READ
    // | ';'
    | goto ';' simple_cmd
    |
    ;

goto: KW_GOTO TK_IDENTIFIER
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

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d %s.\n", getLineNumber(), yytext);
    exit(3);
}