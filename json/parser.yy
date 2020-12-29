%skeleton "lalr1.cc"
%require "3.2"

%defines
%define api.namespace { json }
%define api.parser.class { parser }
%define api.value.type variant
%define parse.assert

%locations

%code requires{

    namespace json {
        class scanner;
    }

    #include "common.hh"
    using namespace common;
}

%parse-param { json::scanner &scanner }
%parse-param { common::driver &driver }

%code{
    #include <iostream>
    
    #include "scanner.hh"

    #undef  yylex
    #define yylex scanner.yylex
}


%token <std::string> STRING
%token END
%token <long> ENTIER
%token <double> FLOTTANT
%token <bool> BOOLLEEN
%token  Null


%type <std::shared_ptr<Valeur>>  valeur
%type   <Objet>         objet contenueObjet
%type <std::pair<std::string,std::shared_ptr<Valeur>>> elementObjet
%type <Tableau> tableau contenueTableau
%type <std::shared_ptr<Valeur>> elementTableau

%%

document:
    objet END  {
         driver.setRacine(new Objet($1));
         YYACCEPT;
    }
    | END {
        driver.setRacine(nullptr);
        YYACCEPT;
    }
valeur: objet {

        $$ = std::make_shared<Objet>($1);
    }
    | tableau{
        $$ = std::make_shared<Tableau>($1) ;
    }
    | ENTIER {

        $$ = std::make_shared<NombreEntier>($1);
    }
    | FLOTTANT {
        $$ = std::make_shared<NombreFlottant>($1);
    }
    | BOOLLEEN {
        $$ = std::make_shared<Boolleen>($1);
    }
    | STRING {
        $$ = std::make_shared<ChaineCaractere>($1) ;
    }
    | Null {
        $$ = std::make_shared<Null>();
    }
objet :
    '{' contenueObjet '}'
    {
        $$ = $2;
    } | '{' '}' {
        $$ = Objet();
    }

contenueObjet:
elementObjet ',' contenueObjet  {
    $$ = Objet($3);
    $$.ajouterValeur($1.first,$1.second);
}
| elementObjet {
    $$ = Objet();
    $$.ajouterValeur($1.first,$1.second);
}
elementObjet :
    STRING ':' valeur {
        $$ = std::pair<std::string,std::shared_ptr<Valeur>>($1,$3);
    }

tableau: '[' contenueTableau ']' {
        $$ = $2;

    }
    | '[' ']' {
        $$ = Tableau();
    }
contenueTableau:
elementTableau ',' contenueTableau {
    $$ = Tableau($3);
    $$.ajouterValeur($1);
}
| elementTableau {
    $$ = Tableau();
    $$.ajouterValeur($1);
}
elementTableau : valeur {
    $$ = $1;
}

%%

void json::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
