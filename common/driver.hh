#pragma once

#include "truc.hh"

namespace common {

    class driver {
    private:
        Document* racine;
    public:
        driver();
        Document* get_racine();
    };
}
