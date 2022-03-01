// Caio Roberto Ramos da Silva - 00279459
// Compiladores - 2021.2 - Marcelo Johann

%{
  #include "hash.h"
%}

%union
{
  int value;
  HASH_NODE *symbol;
}

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

%token<value> LIT_INTEGER 
%token LIT_CHAR
%token LIT_STRING

%token TOKEN_ERROR

%type<value> expr

%left '<' '>' OPERATOR_DIF OPERATOR_EQ OPERATOR_GE OPERATOR_LE
%left '+' '-'
%left '*' '/'

%{
    void yyerror(char *s);
%}

%%


// a program is a list of declarations
program: decl
    ;

// a list of declarations is 1 declaration followed by a list of declarations or empty (for program ending or empty program)
decl: dec decl
    |
    ;

// a declaration is a TYPE followed by an IDENTIFIER and then a declaration_type
dec: type TK_IDENTIFIER declaration_type
    ;

// a type is one of CHAR, INT, FLOAT
type: KW_CHAR
    | KW_INT
    | KW_FLOAT
    ;

// a declaration type is or a function or a global variable
declaration_type: function
    | global_var ';'
    ;

// a function or has parameters or does not, between parenthesis, followed by a block
function: '(' params ')' block
    | '('')' block
    ;

// parameters are defined as a TYPE, followed by an IDENTIFIER and then followed by more parameters
params: type TK_IDENTIFIER more_params
    ;

// more parameters is defined as a comma (to separate params), followed by an IDENTIFIER and then more parameters or empty (no more parameters)
more_params: ',' type TK_IDENTIFIER more_params
    |
    ;

// a block is a command list between curly braces
block: '{' cmd_list '}'
    ;

// a global variable is a type, followed by an IDENTIFIER and one of:
// 1- followed by a semicolon and an array element
// 2- followed by a semicolon and a float
// 3- an initialized array, with and INTEGER size between brackets followed by initialized array initialization
global_var: ':' arr_element
    | ':' float
    | '[' LIT_INTEGER ']' array_initialization
    ;

// a float is an INTEGER, followed by a slash and another INTEGER
float: LIT_INTEGER '/' LIT_INTEGER
    ;

// an expression cand be one of the following
expr: KW_READ         {$$ = 0;}  // read command
    | expr '+' expr  {$$ = $1 + $3;}   // sum
    | expr '-' expr  {$$ = $1 - $3;}   // subtraction
    | expr '*' expr  {$$ = $1 * $3;}   // multiplication
    | expr '/' expr  {$$ = $1 / $3;}   // division
    | expr '>' expr  {$$ = $1 > $3;}   // greater than
    | expr '<' expr  {$$ = $1 < $3;} // less than
    | expr OPERATOR_EQ expr   {$$ = $1 == $3;} // equals
    | expr OPERATOR_GE expr   {$$ = $1 >= $3;}  // greater or equals
    | expr OPERATOR_LE expr   {$$ = $1 <= $3;}   // less or equals
    | expr OPERATOR_DIF expr  {$$ = $1 != $3;}   // different
    | '(' expr ')'  {$$ = $2;} // an expression can be between parenthesis
    | LIT_INTEGER        {fprintf(stderr, "Recebi: %d\n", $1);} // int
    | LIT_CHAR      {$$ = 0;} // char
    | LIT_STRING    {$$ = 0;} // string
    | TK_IDENTIFIER {$$ = 0;} // identifier
    | function_call {$$ = 0;} // a function call
    | '[' expr ']'  {$$ = $2;} // and index for an array
    ;

function_call: TK_IDENTIFIER '(' call_parameters ')'
    | TK_IDENTIFIER '('')'

call_parameters: TK_IDENTIFIER more_call_params
    | LIT_CHAR more_call_params
    | LIT_INTEGER more_call_params
    |
    ;

more_call_params: ',' call_parameters
    |
    ;

if_statement: KW_IF expr KW_THEN if_cases
    ;

if_cases: block
    | block KW_ELSE block
    | block KW_ELSE cmd
    | cmd
    | cmd KW_ELSE block
    | cmd KW_ELSE cmd
    ;

while_statement: KW_WHILE expr block
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


cmd_list: cmd ';' cmd_list
    | label cmd_list
    |
    ;

cmd: TK_IDENTIFIER '=' expr     {fprintf(stderr, "Expr vale %d\n", $3);}
    | TK_IDENTIFIER '[' expr ']' '=' expr
    | KW_PRINT print_values
    | KW_RETURN return_values
    | if_statement
    | while_statement
    | goto
    | block
    | expr
    ;

goto: KW_GOTO TK_IDENTIFIER
    ;

array_initialization: ':' arr_elements
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

%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax error at line %d %s.\n", getLineNumber(), yytext);
    exit(3);
}