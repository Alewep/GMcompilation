#pragma once
#include <map>
#include <memory>

namespace common {

    class Valeur {
    private:
        virtual bool comparerSansVerif(Valeur const& v) const = 0;
    public:
        bool comparer(Valeur const& v) const;
        virtual std::string type() const = 0;
    };

    class Objet : public Valeur{
    private:
        std::map<std::string,std::unique_ptr<Valeur>> _valeurs;
        bool contientValeur(std::string key,Valeur const& Valeur)const;
    public:
        bool comparer(Objet const& o)const;
        bool ajouterValeur(std::string key,std::unique_ptr<Valeur> const& v );
        std::string type() const override;
    };

    class Document {
    private:
        std::unique_ptr<Objet> _objetmain;
    public:
        Document () =default;
        Objet& getObjet();
        void setObjet(Objet const& o);
        bool comparerdoc(Document d) const;
    };

    class ChaineCaractere : public Valeur {
    private:
        std::string _chaine;
        bool comparerSansVerif(const Valeur &v) const override;
    public:
        ChaineCaractere (std::string chaine);
        std::string type() const override;
    };

    class Nombre : public Valeur {
    public:
        bool comparerSansVerif(const Valeur &v) const override;
        std::string type() const override = 0;
    };

    class NombreEntier : public Nombre {
    private:
        long int _nombre;
    public :
        NombreEntier(long int nombre);
        long int nombre() const;
        std::string type() const override;

    };

    class NombreFlottant : public Nombre {
    private:
        long double _nombre;
    public:
        NombreFlottant(long double nombre);
        long double nombre() const;
        std::string type() const override;
    };



}
