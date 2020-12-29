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
null return token::Null;

\"(([^\x00-\x1F\x7F\"\\])|(\\\\|\\\"|\\\/|\\b|\\f|\\n|\\r|\\t|\\u[0-9A-F]{4,4}))*\" {
      std::string s(yytext);
      yylval->build<std::string>(s.substr(1,s.length()-2));
      return token::STRING;
 }
(((\-)?[1-9]([0-9])*)|(0)) {
    yylval->build<long>(atol(yytext));
    return token::ENTIER;
}
((\-)?(([1-9](_?[0-9](_[0-9])?)*)|0))(\.((([0-9]*[1-9])|0)([Ee][\+\-]?[0-9]+)?)|[Ee][\+\-]?[0-9]+) {
    yylval->build<double>(atof(yytext));
    return token::FLOTTANT;
}

"{" return '{';
"}" return '}';
"," return ',';
":" return ':';
"[" return '[';
"]" return ']';

(true|false) {
    std::cout<<"test";
    if ( strcmp(yytext,"true")) yylval->build<bool>(true);
    else if (strcmp(yytext,"false") ) yylval->build<bool>(false);
    return token::BOOLLEEN;
}

([\r\n\s\t])* {}


. {}

%%
