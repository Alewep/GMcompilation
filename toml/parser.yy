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

    struct arbrekey {
        std::shared_ptr<Objet> racine;
        std::shared_ptr<Objet> noeud;
        std::string key;
        std::string startkey;
    };
    struct arbreObjet {
         std::shared_ptr<Objet> courant;
         std::map<std::string,std::shared_ptr<Valeur>>::iterator ajout;

    };

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
%token <Notanumber>     NAN SNAN
%token <valueinfinity>  INF SINF

%type <std::shared_ptr<Valeur>> value
%type <arbrekey>                tkey
%type <arbreObjet>  start
%type <Tableau>                 tableau contenutableau
%type <std::string>             key


%%

document:
    ENDLINE start {  driver.get_racine()->unionObj(*($2.courant.get())); YYACCEPT; }
    | start { driver.get_racine()->unionObj(*($1.courant.get())); YYACCEPT;}


start :
    tkey '=' value ENDLINE start {
        $$.ajout = $5.ajout;
        $$.courant = $1.racine;
        $1.noeud->ajouterValeur($1.key,$3);
        $$.courant->unionObj(*($5.courant.get()));
    }
    | '[' tkey ']' ENDLINE start {
        $$.courant = std::make_shared<Objet>();
        $2.noeud->ajouterValeur($2.key,$5.courant);
        driver.get_racine()->unionObj(*($2.racine.get()));
        $$.ajout = driver.get_racine()->getValeur($2.startkey);

    }
    | '[' '[' tkey ']' ']' ENDLINE start {
         $$.courant = std::make_shared<Objet>();
        if(driver.get_racine()->empty($7.ajout)) {
             $3.noeud->ajouterdanstab($3.key,$7.courant);
         }
        else {
            std::shared_ptr<Objet> o = std::make_shared<Objet>();
            o->ajouterValeur($7.ajout->first,$7.ajout->second);
            $3.noeud->ajouterdanstab($3.key,o);
            driver.get_racine()->supprimerValeur($7.ajout);
        }

        driver.get_racine()->unionObj(*($3.racine.get()));

    }
    | END {
        $$.courant = std::make_shared<Objet>();
        $$.ajout = driver.get_racine()->getempty();
    }



tkey :
    key '.' tkey {
        $$.noeud = $3.noeud;
        $$.key = $3.key;
        $$.startkey = $1;

        $$.racine = std::make_shared<Objet>();
        $$.racine->ajouterValeur($1,$3.racine);
    }
    | key {
        std::shared_ptr<Objet> o = std::make_shared<Objet>();
        $$ = {o,o,$1,$1};
    }

tableau :
    '[' contenutableau ']' {
        $$ = $2;
    }
    | '[' ']' {
        $$ = Tableau();
    }
    ;

contenutableau : value ',' contenutableau {
    $$ = Tableau($3);
    $$.ajouterValeur($1);
}
| value {
    $$.ajouterValeur ($1);

}

value : STRING { $$ = std::make_shared<ChaineCaractere>($1); }
        | ENTIER { $$ = std::make_shared<NombreEntier>($1); }
        | FLOTTANT { $$ = std::make_shared<NombreFlottant>($1); }
        | BOOLEEN  { $$ = std::make_shared<Booleen>($1); }
        | tableau  { $$ = std::make_shared<Tableau>($1); }
        | INF  { $$ = std::make_shared<Infinity>($1); }
        | SINF { $$ = std::make_shared<Infinity>($1); }
        | NAN { $$ = std::make_shared<Notanumber>($1); }
        | SNAN { $$ = std::make_shared<Notanumber>($1); }
key : STRING { $$ = $1; }
     | ENTIER { $$ = std::to_string($1); }
     | BAREKEY { $$ = $1; }
     | BOOLEEN {
        if($1) $$ = "true";
        else $$ = "false";
     }
     | NAN { $$ = "nan"; }
     | INF { $$ = "inf"; }


%%

void toml::parser::error( const location_type &l, const std::string & err_msg) {
    std::cerr << "Erreur : " << l << ", " << err_msg << std::endl;
}
