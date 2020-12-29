#include "truc.hh"
#include <iostream>
using namespace common;


bool Objet::contientValeur(std::string key, const Valeur &v) const {
    auto cherch = _valeurs.find(key);
    if(cherch == _valeurs.end()) return false;
    else if (cherch->second->operator==(v)) return true;
    return false;
}

Objet::Objet(const Objet &o)
{
    _valeurs.clear();
    for ( auto const& e : o._valeurs)
    {
        _valeurs[e.first] = e.second->clone();
    }
}


bool Objet::operator==(const Valeur &v) const
{
    if (const Objet* t = dynamic_cast<const Objet *>(&v)) {
        for (auto const& e : _valeurs)
        {
            if(!(t->contientValeur(e.first,*(e.second)))) return false;
        }
        return true;
    }
    else return false;
}

void Objet::ajouterValeur(std::string key,std::shared_ptr<Valeur> v)
{
    auto cherch = _valeurs.find(key);
    if(cherch == _valeurs.end()) {
        _valeurs[key] = v;
    }
    else return throw "Erreur : ajout de clé multiple";
}

std::shared_ptr<Valeur> Objet::clone() const
{
    return std::make_shared<Objet>(*this);
}

std::string Objet::tojson() const
{

    std::string start = "{";
    for (auto e = _valeurs.begin(); e!=_valeurs.end();++e) {

        start = start + e->first + ":" + e->second->tojson();
        auto suiv = e;
        ++suiv;
        if ( suiv!=_valeurs.end()) start = start + ",";
    }

    start = start + "}";
    return start;
}

Tableau::Tableau(const Tableau &t)
{
    _valeurs.clear();
    for ( auto const& e : t._valeurs)
    {
        _valeurs.push_back(e->clone());
    }
}

bool Tableau::operator==(const Valeur &v) const
{
    if( const Tableau* t = dynamic_cast<const Tableau *>(&v) ) {
        for (auto const& e : _valeurs)
        {
            if(!(*e == *t)) return false;

        }
        return true;
    }
    else return false;
}

void Tableau::ajouterValeur(std::shared_ptr<Valeur> v)
{
    _valeurs.push_back(v);
}


std::shared_ptr<Valeur> Tableau::clone() const
{
    return std::make_shared<Tableau>(*this);
}

std::string Tableau::tojson() const
{
    std::string start = "[";
    for (auto e = _valeurs.begin(); e!=_valeurs.end();++e) {

        start = start + (*e)->tojson();
        auto suiv = e;
        ++suiv;
        if ( suiv!=_valeurs.end()) start = start + ",";
    }

    start = start + "]";
    return start;
}

ChaineCaractere::ChaineCaractere(std::string chaine) : _chaine(chaine) {}

bool ChaineCaractere::operator==(const Valeur &v) const
{
    if( const ChaineCaractere* t = dynamic_cast<const ChaineCaractere *>(&v))
        return (_chaine == t->_chaine);
    else return false;
}


std::shared_ptr<Valeur> ChaineCaractere::clone() const
{
    return std::make_shared<ChaineCaractere> (*this) ;
}

std::string ChaineCaractere::tojson() const
{
    return _chaine;
}



NombreEntier::NombreEntier(long nombre) : _nombre(nombre) {}

long NombreEntier::nombre() const
{
    return _nombre;
}


bool NombreEntier::operator==(const Valeur &v) const
{
    if( const NombreEntier* t = dynamic_cast<const NombreEntier*>(&v))
        return nombre() == t->nombre();
    else return false;
}

std::shared_ptr<Valeur> NombreEntier::clone() const
{
    return std::make_shared<NombreEntier>(*this);
}

std::string NombreEntier::tojson() const
{
    return std::to_string(_nombre);
}
NombreFlottant::NombreFlottant(double nombre) : _nombre(nombre) {}

long double NombreFlottant::nombre() const
{
    return _nombre;
}
bool NombreFlottant::operator==(const Valeur &v) const
{
    if ( const NombreFlottant* t = dynamic_cast<const NombreFlottant*>(&v))
        return nombre() == t->nombre();
    else return false;
}

std::shared_ptr<Valeur> NombreFlottant::clone() const
{
    return std::make_shared<NombreFlottant>(*this);
}

std::string NombreFlottant::tojson() const
{
    return std::to_string(_nombre);
}

Boolleen::Boolleen(bool b) : _b(b) {}

bool Boolleen::operator==(const Valeur &v) const
{
    if(const Boolleen *t = dynamic_cast<const Boolleen*>(&v))
        return _b == t->_b;
    else return false;
}

std::shared_ptr<Valeur> Boolleen::clone() const
{
    return std::make_shared<Boolleen>(*this);
}

std::string Boolleen::tojson() const
{
    if (_b == true) return "true";
    else return "false";
}

bool Null::operator==(const Valeur &v) const
{
    if (dynamic_cast<const Null *>(&v)) return true;
    else return false;
}

std::shared_ptr<Valeur> Null::clone() const
{
    return std::make_shared<Null>(*this);
}

std::string Null::tojson() const
{
    return "null";
}


