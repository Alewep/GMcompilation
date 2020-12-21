%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

using token = json::parser::token;

#undef  YY_DECL
#define YY_DECL int json::scanner::yylex( json::parser::semantic_type * const lval, json::parser::location_type *loc )

/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

using namespace json;
%}

%option c++
%option yyclass="scanner"
%option prefix="Json_"
%option noyywrap
%option nodefault

%%

%{
    yylval = lval;
%}

"{" return '{';
"}" return '}';
"," return ',';
[[:space:]]{+}[\t]{+}[\r] return token::WHITESPACE;
("-")?[1-9]([0-9])* return token::ENTIER;
("-")?([0-9])+\.([0-9])+ return token::FLOTTANT;
[Ee] return token::EXP;

<<EOF>> return token::END;

%%
