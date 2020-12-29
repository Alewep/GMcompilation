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

\, return ',';
\[ return '[';
\] return ']';
\= return '=';
\. return '.';
\n return token::ENDLINE;

true {
 yylval->build<bool>(true);
 return token::BOOLEEN;
}
false {
 yylval->build<bool>(false);
 return token::BOOLEEN;
}


([\+\-]?(([1-9](_?[0-9](_[0-9])?)*)|0))(\.((([0-9]*[1-9])|0)([Ee][\+\-]?[0-9]+)?)|[Ee][\+\-]?[0-9]+) {
    yylval->build<double>(atof(yytext));
    return token::FLOTTANT;
 }
([\+\-]?(([1-9](_?[0-9](_[0-9])?)*)|0)) {
     yylval->build<long>(atoi(yytext));
     return token::ENTIER;
}
0x([0-9A-Fa-f](_?[0-9A-Fa-f])*) {
    std::string s(yytext);
    yylval->build<long>(stoi(s.substr(2), 0, 16));
    return token::ENTIER;
}
0o([0-8](_?[0-8])*) {
     std::string s(yytext);
     yylval->build<long>(stoi(s.substr(2), 0, 8));
     return token::ENTIER;
}
0b([01](_?[01])*) {
     std::string s(yytext);
     yylval->build<long>(stoi(s.substr(2), 0, 2));
     return token::ENTIER;
}

([A-Za-z0-9_-]*) {
     yylval->build<std::string>(yytext);
     return token::BAREKEY;
}
\"(([^\x00-\x1F\x7F\"\\])|(\\\\|\\\"|\\b|\\f|\\n|\\r|\\t|\\u[0-9A-F]{4,4}))*\"  {
    std::string s(yytext);
    yylval->build<std::string>(s.substr(1,s.length()-2));
    return token::STRING;
}


([\r\s\t\n])* {}
. {}

%%
