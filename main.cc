#include <iostream>
#include "json/jsonParser.hh"
#include "toml/tomlParser.hh"

int main() {
    std::cout << "******** Json *******" << std::endl;
    auto json = parseJSON("test.json");

    std::cout << "******** Toml *******" << std::endl;
    auto toml = parseTOML("test.toml");
/*
    if (*json == *toml) {
        return 0;
    }
    else {
        return 255;
    }
//*/

    return 0;
}
