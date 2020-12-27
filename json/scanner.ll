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

<<EOF>> {
  std::cout<<"fin"<<std::endl;
  return token::END;

}
\"(([^\x00-\x1F\x7F\"\\])|(\\\\|\\\"|\\\/|\\b|\\f|\\n|\\r|\\t|\\u[0-9A-F]{4,4}))*\" {
      yylval->build<std::string>(yytext);
      return token::STRING;
  }
(\-)?([0-9])+\.([0-9])+([Ee]([\-\+])?[0-9]*)? {
    yylval->build<double>(atof(yytext));
    return token::FLOTTANT;
}
(((\-)?[1-9]([0-9])*)|(0))([Ee]([\-\+])?[0-9]*)? {
    yylval->build<long>(atol(yytext));
    return token::ENTIER;
}                                  
"{" return '{';
"}" return '}';
"," return ',';
":" return ':';
"[" return '[';
"]" return ']';
null return token::Null;
((true)|(false)) {
    std::cout<<"test";
    if ( strcmp(yytext,"true")) yylval->build<bool>(true);
    else if (strcmp(yytext,"false") ) yylval->build<bool>(false);
    return token::BOOLLEEN;
}

([\r\n\s\t])* {}
. {}

%%
