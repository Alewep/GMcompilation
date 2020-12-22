#pragma once
#include <map>
#include <list>
#include <string>
#include <memory>

namespace common {

    class Valeur {
    public:
        virtual bool operator==(Valeur const& v) const = 0;

    };

    class Objet : public Valeur{
    private:
        std::map<std::string,std::unique_ptr<Valeur>> _valeurs;
        bool contientValeur(std::string key,Valeur const& Valeur)const;
    public:
        bool operator==(Valeur const& v) const override;
        bool ajouterValeur(std::string key,std::unique_ptr<Valeur> const& v );

    };
    class Tableau : public Valeur  {
    private:
        std::list<std::unique_ptr<Valeur>> _valeurs;
    public:
        bool operator==(Valeur const&v) const override;
    };

    class Document {
    private:
        std::unique_ptr<Objet> _objetmain;
    public:
        Document () =default;
        Objet& getObjet();
        void setObjet(Objet const& o);
        bool operator==(Document const& d) const;
    };

    class ChaineCaractere : public Valeur {
    private:
        std::string _chaine;
    public:
        ChaineCaractere (std::string chaine);

        bool operator==(Valeur const& v) const override;
    };

    class Nombre : public Valeur {
    public:
        bool operator==(Valeur const& v) const override =0;

    };

    class NombreEntier : public Nombre {
    private:
        long int _nombre;
    public :
        NombreEntier(long int nombre);
        long int nombre() const;
        bool operator==(Valeur const& v) const override;

    };

    class NombreFlottant : public Nombre {
    private:
        long double _nombre;
    public:
        NombreFlottant(long double nombre);
        long double nombre() const;
        bool operator==(Valeur const& v) const override;

    };



}
