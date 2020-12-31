#include <fstream>
#include "tomlParser.hh"

#include "scanner.hh"

common::Objet* parseTOML(const std::string &filename) {
    auto input = std::ifstream(filename);
    common::driver driver(new Objet());
    toml::scanner scanner(input, std::cout);
    toml::parser parser(scanner, driver);

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
