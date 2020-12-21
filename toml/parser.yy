%skeleton "lalr1.cc"
%require "3.2"

%defines
%define api.namespace { toml }
%define api.parser.class { parser }
%define api.value.type variant
%define parse.assert

%locations

%code requires{

    namespace toml {
        class scanner;
    }

    #include "common.hh"
}

%parse-param { toml::scanner &scanner }
%parse-param { common::driver &driver }

%code{
    #include <iostream>
    
    #include "scanner.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  END

%%

document:
    END {
        YYACCEPT;
    }

%%

void toml::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}