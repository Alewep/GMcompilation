#pragma once
#include <map>
#include <list>
#include <string>
#include <memory>

namespace common {

    class Valeur {
    public:
        virtual bool operator==(Valeur const& v) const = 0;
        virtual std::shared_ptr<Valeur> clone() const = 0;
        virtual ~Valeur() {};
        virtual std::string tojson() const =0 ;
    };

    class Objet : public Valeur{
    private:
        std::map<std::string,std::shared_ptr<Valeur>> _valeurs;
        bool contientValeur(std::string key,Valeur const& Valeur)const;
    public:
        Objet() = default;
        Objet(Objet const& o);
        bool operator==(Valeur const& v) const override;
        void ajouterValeur(std::string key,std::shared_ptr<Valeur> v);
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;
    };
    class Tableau : public Valeur  {
    private:
        std::list<std::shared_ptr<Valeur>> _valeurs;
    public:
        Tableau() = default;
        Tableau(Tableau const& t);
        bool operator==(Valeur const&v) const override;
        void ajouterValeur(std::shared_ptr<Valeur>);
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;
    };


    class ChaineCaractere : public Valeur {
    private:
        std::string _chaine;
    public:
        ChaineCaractere (std::string chaine);

        bool operator==(Valeur const& v) const override;
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;
    };

    class Nombre : public Valeur {
    public:
        bool operator==(Valeur const& v) const override =0;
        std::shared_ptr<Valeur> clone () const override =0;
        std::string tojson() const override =0;

    };

    class NombreEntier : public Nombre {
    private:
        long _nombre;
    public :
        NombreEntier(long nombre);
        long int nombre() const;
        bool operator==(Valeur const& v) const override;
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;

    };

    class NombreFlottant : public Nombre {
    private:
        double _nombre;
    public:
        NombreFlottant(double nombre);
        long double nombre() const;
        bool operator==(Valeur const& v) const override;
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;

    };

    class Boolleen : public Valeur {
    private:
        bool _b;
    public:
        Boolleen (bool b);
        bool operator==(Valeur const& v) const override;
        std::shared_ptr<Valeur>clone () const override;
        std::string tojson() const override;
    };

    class Null : public Valeur {
    public :
        bool operator==(Valeur const& v) const override;
        std::shared_ptr<Valeur> clone () const override;
        std::string tojson() const override;
    };



}
