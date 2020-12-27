#include "driver.hh"

common::driver::driver() : racine(new Objet) {}

common::Objet *common::driver::get_racine() {
    return racine;
}

void common::driver::setRacine(common::Objet *value) {
    racine = value;
}
