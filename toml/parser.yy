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
    using namespace common;
}

%parse-param { toml::scanner &scanner }
%parse-param { common::driver &driver }

%code{
    #include <iostream>
    
    #include "scanner.hh"

    #undef  yylex
    #define yylex scanner.yylex
}

%token                  END ENDLINE
%token <std::string>    BAREKEY STRING
%token <long>           ENTIER
%token <double>         FLOTTANT
%token <bool>           BOOLEEN

%type <Objet> document start tkey
%type <std::shared_ptr<Valeur>> value


%%

document:()
    start { $1 = Objet()
            driver->setRacine
          }

start :
tkey '=' value ENDLINE start {

    }
    | '[' tkey ']' ENDLINE start
    | '[' '[' tkey ']' ']' ENDLINE start
    | END {
        YYACCEPT;
    }
    ;
tkey :
    key '.' tkey | key

tableau :
    '[' contenutableau ']'
    | '[' ']'
    ;

contenutableau : value ',' contenutableau | value

value : STRING | ENTIER | FLOTTANT | BOOLEEN | tableau
key : STRING | ENTIER | BAREKEY | BOOLEEN


%%

void toml::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
