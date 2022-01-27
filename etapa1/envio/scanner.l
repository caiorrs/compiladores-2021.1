%{
#include "tokens.h"
#include "hash.h"

int running = 1;
int lineNumber = 1;
%}

%x MULTILINE_COMMENT

%%  

"char"                  {hashInsert(yytext, KW_CHAR); return KW_CHAR;}
"int"                   {hashInsert(yytext, KW_INT); return KW_INT;}
"float"                 {hashInsert(yytext, KW_FLOAT); return KW_FLOAT;}
"if"                    {hashInsert(yytext, KW_IF); return KW_IF;}
"then"                  {hashInsert(yytext, KW_THEN); return KW_THEN;}
"else"                  {hashInsert(yytext, KW_ELSE); return KW_ELSE;}
"while"                 {hashInsert(yytext, KW_WHILE); return KW_WHILE;}
"goto"                  {hashInsert(yytext, KW_GOTO); return KW_GOTO;}
"read"                  {hashInsert(yytext, KW_READ); return KW_READ;}
"print"                 {hashInsert(yytext, KW_PRINT); return KW_PRINT;}
"return"                {hashInsert(yytext, KW_RETURN); return KW_RETURN;}
[,;:(){}\[\]+-/*<>=]           {return yytext[0];}
"<="                  {hashInsert(yytext, OPERATOR_LE); return OPERATOR_LE;}
">="                  {hashInsert(yytext, OPERATOR_GE); return OPERATOR_GE;}
"=="                  {hashInsert(yytext, OPERATOR_EQ); return OPERATOR_EQ;}
"!="                  {hashInsert(yytext, OPERATOR_DIF); return OPERATOR_DIF;}
[ \t]
"\n"                  {++lineNumber;}
[0-9]+                {hashInsert(yytext, LIT_INTEGER); return LIT_INTEGER;}
\'[ -~]\'             {hashInsert(yytext, LIT_CHAR); return LIT_CHAR;}
\"[ -~]*\"            {hashInsert(yytext, LIT_STRING); return LIT_STRING;}
\\\\.*                {printf("COMMENT\n");}
\\\*                  {BEGIN(MULTILINE_COMMENT);printf("MULTILINE_COMMENT\n");}
[a-zA-Z_\-]+          {hashInsert(yytext, TK_IDENTIFIER); return TK_IDENTIFIER;}
.                     {hashInsert(yytext, TOKEN_ERROR); return TOKEN_ERROR;}

<MULTILINE_COMMENT>\n {++lineNumber;}
<MULTILINE_COMMENT>"*\\" {BEGIN(INITIAL);}
<MULTILINE_COMMENT>.

%%

#include "hash.c"
#include "main.c"

int getLineNumber(void) {
  return lineNumber;
}

int isRunning(void) {
  return running;
}

int yywrap() {
  running = 0;
  return 1;
}
