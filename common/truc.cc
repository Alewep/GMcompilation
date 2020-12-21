#include "truc.hh"

using namespace common;

bool Valeur::comparer(Valeur const& v) const {
    if ( type() != v.type()) return false;
    else return comparerSansVerif(v);
}




