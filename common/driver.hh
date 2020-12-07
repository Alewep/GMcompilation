#pragma once

#include "truc.hh"

namespace common {

    class driver {
    private:
        truc* racine;
    public:

        driver();

        truc* get_racine();
    };
}
