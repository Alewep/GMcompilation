#pragma once
#include "truc.hh"

namespace common {

    class driver {
    private:
        Objet* racine;
    public:
        driver();
        Objet* get_racine();
        void setRacine(Objet *value);
    };
}
