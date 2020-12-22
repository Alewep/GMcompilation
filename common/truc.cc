#include "truc.hh"

using namespace common;


bool Objet::contientValeur(std::string key, const Valeur &v) const {
    auto cherch = _valeurs.find(key);
    if(cherch == _valeurs.end()) return false;
    else if (cherch->second->operator==(v)) return true;
    return false;
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

bool ChaineCaractere::operator==(const Valeur &v) const
{
    if( const ChaineCaractere* t = dynamic_cast<const ChaineCaractere *>(&v))
        return (_chaine == t->_chaine);
    else return false;
}



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



long double NombreFlottant::nombre() const
{
    return _nombre;
}

bool NombreFlottant::operator==(const Valeur &v) const
{
    if ( const NombreFlottant*t = dynamic_cast<const NombreFlottant*>(&v))
        return nombre() == t->nombre();
    else return false;
}
