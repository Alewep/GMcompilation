%{

#include "scanner.hh"

#define YY_NO_UNISTD_H

using token = toml::parser::token;

#undef  YY_DECL
#define YY_DECL int toml::scanner::yylex( toml::parser::semantic_type * const lval, toml::parser::location_type *loc )


/* update location on matching */
#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

using namespace toml;
%}

%option c++
%option yyclass="scanner"
%option prefix="Toml_"
%option noyywrap
%option nodefault


%%

%{
    yylval = lval;
%}

<<EOF>>       return token::END;

%%
