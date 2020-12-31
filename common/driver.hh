#pragma once
#include "truc.hh"

namespace common {

    class driver {
    private:
        Objet* _racine;
    public:
        driver();
        //~driver() {delete _racine;}
        driver(Objet* racine);
        Objet* get_racine();
        void setRacine(Objet *value);
    };
}
