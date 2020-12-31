#include "driver.hh"

common::driver::driver() : _racine(new Objet) {}

common::driver::driver(common::Objet *racine) : _racine(racine) {}

common::Objet *common::driver::get_racine() {
    return _racine;
}


void common::driver::setRacine(common::Objet *value) {
    _racine = value;
}
