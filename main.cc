#include <iostream>
#include "json/jsonParser.hh"
#include "toml/tomlParser.hh"

int main() {
    //std::cout << "******** Json *******" << std::endl;
    auto json = parseJSON("test.json");
    std::cout<<json->tojson()<<std::endl;
    std::cout << "******** Toml *******" << std::endl;
    auto toml = parseTOML("test.toml");
    std::cout<<toml->tojson()<<std::endl;



    if (*json == *toml) {
        std::cout<<"oui";
        return 0;
    }
    else {
        std::cout<<"non";
        return 255;
    }


    return 0;
}
