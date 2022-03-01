%{
/*
  Caio Roberto Ramos da Silva - 00279459
  Compiladores - 2021.2 - Marcelo Johann
  String regex from - https://stackoverflow.com/a/1016356
*/
#include "hash.h"
#include "y.tab.h"

int running = 1;
int lineNumber = 1;

int getLineNumber(void) {
  return lineNumber;
}
%}

%x MULTILINE_COMMENT

%%  

"char"                  {return KW_CHAR;}
"int"                   {printf("%s\n", yytext); return KW_INT;}
"float"                 {return KW_FLOAT;}
"if"                    {return KW_IF;}
"then"                  {return KW_THEN;}
"else"                  {return KW_ELSE;}
"while"                 {return KW_WHILE;}
"goto"                  {return KW_GOTO;}
"read"                  {return KW_READ;}
"print"                 {return KW_PRINT;}
"return"                {return KW_RETURN;}
[,;:/(/){}\[\]+-/*<>=]           {printf("%c\n", yytext[0]); return yytext[0];}
"<="                  {return OPERATOR_LE;}
">="                  {return OPERATOR_GE;}
"=="                  {return OPERATOR_EQ;}
"!="                  {return OPERATOR_DIF;}
[ \t]
"\n"                  {++lineNumber;}
[0-9]+                {
                        
                        yylval.symbol = hashInsert(yytext, LIT_INTEGER); 
                        return LIT_INTEGER;
                      }
\'.\'                 {hashInsert(yytext, LIT_CHAR); return LIT_CHAR;}
\"(\\.|[^\"])*\"      {hashInsert(yytext, LIT_STRING); return LIT_STRING;}
\\\\.*                {printf("COMMENT\n");}
\\\*                  {BEGIN(MULTILINE_COMMENT);printf("MULTILINE_COMMENT\n");}
[a-z_\-]+             {
                        
                        yylval.symbol = hashInsert(yytext, TK_IDENTIFIER);
                        return TK_IDENTIFIER;
                      }
.                     {printf("Invalid token: %c ", yytext[0]); return TOKEN_ERROR;}

<MULTILINE_COMMENT>\n {++lineNumber;}
<MULTILINE_COMMENT>"*\\" {BEGIN(INITIAL);}
<MULTILINE_COMMENT>.

%%

#include "y.tab.c"
#include "hash.c"
#include "main.c"

int isRunning(void) {
  return running;
}

void initMe(void) {
  hashInit();
}

int yywrap() {
  running = 0;
  return 1;
}
