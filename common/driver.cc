#include "driver.hh"

common::driver::driver() : racine(new Document) {}

common::Document *common::driver::get_racine() {
    return racine;
}
