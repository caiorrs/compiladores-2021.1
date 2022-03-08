// Caio Roberto Ramos da Silva - 00279459
// Compiladores - 2021.2 - Marcelo Johann

%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "hash.h"
  #include "ast.h"

  int getLineNumber();
  int yylex();
  char *yytext;

  AST *root;
%}

%union
{
  HASH_NODE *symbol;
  AST *ast;
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

%token<symbol> TK_IDENTIFIER 
%token<symbol> LIT_INTEGER 
%token<symbol> LIT_CHAR
%token<symbol> LIT_STRING

%token TOKEN_ERROR

%type<ast> program
%type<ast> decl
%type<ast> dec
%type<ast> params
%type<ast> block

%type<ast> expr
%type<ast> cmd
%type<ast> cmd_list
%type<ast> print_values
%type<ast> more_print_values
%type<ast> array_index
%type<ast> array_initialization
%type<ast> arr_elements
%type<ast> arr_element
%type<ast> more_elements
%type<ast> more_params
%type<ast> type
%type<ast> float
%type<ast> function_call

%left '<' '>' OPERATOR_DIF OPERATOR_EQ OPERATOR_GE OPERATOR_LE
%left '+' '-'
%left '*' '/'

%{
    void yyerror(char *s);
%}

%%


// a program is a list of declarations
program: decl {root = $$;}
    ;

// a list of declarations is 1 declaration followed by a list of declarations or empty (for program ending or empty program)
decl: dec decl {$$ = astCreate(AST_DECLIST, 0, $1,$2,0,0);}
    |          {$$ = 0;}
    ;

// a declaration is a TYPE followed by an IDENTIFIER and then a declaration_type
dec: type TK_IDENTIFIER '(' params ')' cmd       {$$ = astCreate(AST_FUNC_DEC, $2, $1, $4, $6, 0);}
    | type TK_IDENTIFIER ':' arr_element ';'       {$$ = astCreate(AST_GLOBAL_VAR_DEC, $2, $1, $4, 0, 0);}
    | type TK_IDENTIFIER ':' float ';'             {$$ = astCreate(AST_GLOBAL_VAR_FLOAT_DEC, $2, $1, $4, 0, 0);}
    | type TK_IDENTIFIER '[' LIT_INTEGER ']' ';'   {$$ = astCreate(AST_GLOBAL_VAR_ARR_DEC, $2, $1, astCreate(AST_SYMBOL, $4, 0,0,0,0), 0, 0);}
    | type TK_IDENTIFIER '[' LIT_INTEGER ']' ':' array_initialization ';' {$$ = astCreate(AST_GLOBAL_VAR_INITIALIZED_ARR_DEC, $2, $1, astCreate(AST_SYMBOL, $4, 0,0,0,0), $7, 0);}
    ;

// a type is one of CHAR, INT, FLOAT
type: KW_CHAR   {$$ = astCreate(AST_TYPE_CHAR, 0, 0, 0, 0, 0);}
    | KW_INT    {$$ = astCreate(AST_TYPE_INT, 0, 0, 0, 0, 0);}
    | KW_FLOAT  {$$ = astCreate(AST_TYPE_FLOAT, 0, 0, 0, 0, 0);}
    ;

// parameters are defined as a TYPE, followed by an IDENTIFIER and then followed by more parameters
params: type TK_IDENTIFIER more_params {$$ = astCreate(AST_FUNC_PARAMS, $2, $1, $3, 0, 0);}
    | {$$ = 0;}
    ;

// more parameters is defined as a comma (to separate params), followed by an IDENTIFIER and then more parameters or empty (no more parameters)
more_params: ',' type TK_IDENTIFIER more_params {$$ = astCreate(AST_FUNC_MORE_PARAMS, $3, $2, $4, 0, 0);}
    | {$$ = 0;}
    ;

// a block is a command list between curly braces
block: '{' cmd_list '}' {$$ = astCreate(AST_CMDBLOCK, 0, $2, 0, 0, 0);}
    ;

// a float is an INTEGER, followed by a slash and another INTEGER
float: LIT_INTEGER '/' LIT_INTEGER {$$ = astCreate(AST_FLOAT_VALUE, 0, astCreate(AST_SYMBOL, $1, 0,0,0,0), astCreate(AST_SYMBOL, $3, 0,0,0,0), 0, 0);}
    ;

// an expression cand be one of the following
expr: KW_READ                 {$$ = astCreate(AST_READ, 0, 0,0,0,0);}  // read command
    | expr '+' expr           {$$ = astCreate(AST_ADD, 0, $1,$3,0,0);} // sum
    | expr '-' expr           {$$ = astCreate(AST_SUB, 0, $1,$3,0,0);} // subtraction
    | expr '*' expr           {$$ = astCreate(AST_MULT, 0, $1,$3,0,0);} // multiplication
    | expr '/' expr           {$$ = astCreate(AST_DIV, 0, $1,$3,0,0);} // division
    | expr '>' expr           {$$ = astCreate(AST_GREAT, 0, $1,$3,0,0);} // greater than
    | expr '<' expr           {$$ = astCreate(AST_LESS, 0, $1,$3,0,0);} // less than
    | expr OPERATOR_EQ expr   {$$ = astCreate(AST_EQ, 0, $1,$3,0,0);} // equals
    | expr OPERATOR_GE expr   {$$ = astCreate(AST_GE, 0, $1,$3,0,0);} // greater or equals
    | expr OPERATOR_LE expr   {$$ = astCreate(AST_LE, 0, $1,$3,0,0);} // less or equals
    | expr OPERATOR_DIF expr  {$$ = astCreate(AST_DIF, 0, $1,$3,0,0);} // different
    | '(' expr ')'   {$$ = $2;}         // an expression can be between parenthesis
    | LIT_INTEGER    {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0);} // int
    | LIT_CHAR       {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0);}     // char
    | LIT_STRING     {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0);}     // string
    | TK_IDENTIFIER  {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0);}     // identifier
    | function_call  {$$ = $1;}         // a function call
    //| TK_IDENTIFIER '[' expr ']'  {$$ = astCreate(AST_SYMBOL, $1, $3,0,0,0);} // and index for an array
    ;

function_call: TK_IDENTIFIER '(' call_parameters ')' {$$ = 0;}
    //| TK_IDENTIFIER '('')' {$$ = 0;}
    ;

call_parameters: TK_IDENTIFIER more_call_params
    | LIT_CHAR more_call_params
    | LIT_INTEGER more_call_params
    |
    ;

more_call_params: ',' call_parameters
    |
    ;

print_values: LIT_STRING more_print_values {$$ = 0;}
    | TK_IDENTIFIER more_print_values {$$ = 0;}
    | TK_IDENTIFIER '[' array_index ']' {$$ = 0;}
    | {$$ = 0;}
    ;

array_index: LIT_INTEGER {$$ = 0;}
    ;

more_print_values: ',' print_values {$$ = 0;}
    | {$$ = 0;}
    ;

cmd_list: cmd ';' cmd_list {$$ = astCreate(AST_CMDLIST, 0, $1,$3,0,0);}
    | TK_IDENTIFIER ':' cmd_list {$$ = astCreate(AST_CMDLIST, $1, $3,0,0,0);}
    | {$$ = 0;}
    ;

cmd: TK_IDENTIFIER '=' expr  {$$ = astCreate(AST_ATTR, $1, $3,0,0,0);}
    | TK_IDENTIFIER '[' expr ']' '=' expr {$$ = astCreate(AST_ATTR_ARR, $1, $3, $6, 0, 0);}
    | KW_PRINT print_values {$$ = astCreate(AST_PRINT, 0, $2, 0, 0, 0);}
    | KW_RETURN expr {$$ = astCreate(AST_RETURN, 0, $2, 0, 0, 0);}
    | KW_IF expr KW_THEN cmd {$$ = astCreate(AST_IF, 0, $2, $4, 0, 0);}
    | KW_IF expr KW_THEN cmd KW_ELSE cmd {$$ = astCreate(AST_IF_ELSE, 0, $2, $4, $6, 0);}
    | KW_WHILE expr cmd {$$ = astCreate(AST_WHILE, 0, $2, $3, 0, 0);}
    | KW_GOTO TK_IDENTIFIER {$$ = astCreate(AST_GOTO, 0, 0, 0, 0, 0);}
    | block {$$ = $1;}
    // | expr {$$ = $1;}
    | {$$ = 0;}
    ;

array_initialization: arr_elements {$$ = $1;}
    | {$$ = 0;}
    ;

arr_elements: arr_element more_elements {$$ = astCreate(AST_ARR_ELEMENTS, 0, $1, $2, 0, 0);}
    ;

more_elements: arr_elements {$$ = $1;}
    | {$$ = 0;}
    ;

arr_element: LIT_INTEGER {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0); }
    | LIT_CHAR {$$ = astCreate(AST_SYMBOL, $1, 0,0,0,0); }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Syntax error at line %d %s.\n", getLineNumber(), yytext);
    exit(3);
}

AST* getASTRoot(){
	return root;
}