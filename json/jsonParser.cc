#include <fstream>
#include "jsonParser.hh"

#include "scanner.hh"

common::Objet* parseJSON(const std::string &filename) {
    auto input = std::ifstream(filename);
    common::driver driver;
    json::scanner scanner(input, std::cout);
    json::parser parser(scanner, driver);

    if (!input.good()) {
        std::cerr << "impossible de lire le fichier : " << filename << std::endl;
        return driver.get_racine();
    }

    if (parser.parse()) {
        std::cerr << "erreur de parsing du fichier" << std::endl;
    }

    input.close();

    return driver.get_racine();
}
