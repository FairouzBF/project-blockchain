pragma solidity ^0.5.3;

pragma experimental ABIEncoderV2;

import "./Token.sol";

contract Diplome {
    address private owner;
    address private token;

    struct Etablissement {
        bool existe;
        uint256 ees_id;
        string nom_etablissement;
		string type_etablissement;
		string pays;
		string adresse; 
		string site_web;
		uint256 id_agent;
    }

    struct InfoDiplome {
		bool existe;
		uint256 id_titulaire;
		string nom_etablissement;
		string pays;
		string type_diplome;
		string specialite;
		string mention;
		string date_obtention;
	}

    struct InfoPersoEtudiant {
		string nom;
		string prenom;
		string date_naissance;
		string sexe;
		string nationalite;
		string status_civil;
		string adresse;
		string courriel;
		string telephone;
	}

    struct InfoAcademiqueEtudiant {
        string section;
		string sujet_pfe;
		string entreprise_stage_pfe;
		string maitre_stage;
		string date_debut_stage;
		string date_fin_stage;
		string evaluation;
    }

    struct Etudiant {
        bool existe;
        uint256 id_etudiant;
        InfoPersoEtudiant infoPerso;
        InfoAcademiqueEtudiant infoAcademique;
    }

    struct Entreprise {
        bool existe;
		string nom;
		string secteur;
		string date_creation;
		string classification_taille;
		string pays;
		string adresse;
		string courriel;
		string telephone;
		string site_web;
        uint256 id_diplome;
        uint256 id_entreprise;
	}

    mapping(uint256 => Etablissement) public Etablissements;
    mapping(address => uint256) AdresseEtablissements;
    mapping(uint256 => Etudiant) public Etudiants;
    mapping(uint256 => Entreprise) public Entreprises;
	mapping(uint256 => uint256) public AdresseEntreprises;
	mapping(uint256 => InfoDiplome) public Diplomes;

    uint256 public NbEtablissements;
    uint256 public NbEtudiants;
    uint256 public NbEntreprises;
    uint256 public NbDiplomes;

    constructor(address tokenaddress) public {
        token = tokenaddress;
        owner = msg.sender; 

        NbEtablissements = 0;
        NbEtudiants = 0;
        NbEntreprises = 0;
        NbDiplomes = 0;
    }

    function ajouterEtablissements(Etablissement memory e, address a) private {
        NbEtablissements += 1;
        e.existe = true;
        e.ees_id += 1;
        Etablissements[NbEtablissements] = e;
        AdresseEtablissements[a] = NbEtablissements;
    }

    function ajouterEntreprises(Entreprise memory e, address a) private {
        NbEntreprises += 1;
        e.existe = true;
        e.id_entreprise += 1;
        Entreprises[NbEntreprises] = e;
        AdresseEntreprises[uint256(a)] = NbEntreprises;
    }

    function ajouterEtudiants(Etudiant memory e) private {
        e.existe = true;
        e.id_etudiant += 1;
        NbEtudiants += 1;
        Etudiants[NbEtudiants] = e;
    }

    function ajouterDiplomes(InfoDiplome memory d) private {
        d.existe = true;
        d.id_titulaire += 1;
        NbDiplomes += 1;
        Diplomes[NbDiplomes] = d;
    }

    function ajouterEtablissements(string memory nom_etabliseement, string memory type_etablissement, string memory pays, string memory adresse, string memory site_web, uint256 id_agent) public {
        Etablissement memory e;
        e.nom_etablissement = nom_etabliseement;
        e.type_etablissement = type_etablissement;
        e.pays = pays;
        e.adresse = adresse;
        e.site_web = site_web;
        e.id_agent = id_agent;
        ajouterEtablissements(e, msg.sender);
    }

    function ajouterEntreprises(string memory nom, string memory secteur, string memory date_creation, string memory classification_taille, string memory pays, string memory adresse, string memory courriel, string memory telephone, string memory site_web) public {
        Entreprise memory e;
        e.nom = nom;
        e.secteur = secteur;
        e.date_creation = date_creation;
        e.classification_taille = classification_taille;
        e.pays = pays;
        e.adresse = adresse;
        e.courriel = courriel;
        e.telephone = telephone;
        e.site_web = site_web;
        ajouterEntreprises(e, msg.sender);
    }

 
    function ajouterEtudiants(InfoPersoEtudiant  memory infoPerso, InfoAcademiqueEtudiant memory infoAcademique) public {
        uint256 id = AdresseEtablissements[msg.sender];
        require(id != 0, "pas un etablissement");
        Etudiant storage e = Etudiants[NbEtudiants + 1];
        e.existe = true;
        e.id_etudiant = NbEtudiants + 1;
        e.infoPerso = infoPerso;
        e.infoAcademique = infoAcademique;
        NbEtudiants += 1;
    }
  
    function ajouterDiplomes(uint256 id_titulaire, string memory pays, string memory type_diplome, string memory specialite, string memory mention, string memory date_obtention) public {
        uint256 id = AdresseEtablissements[msg.sender];
        require(id != 0, "pas un etablissement");
        require(Etudiants[id_titulaire].existe == true, "pas un etudiant");
        InfoDiplome memory d;
        d.existe = true;
        d.id_titulaire = id_titulaire;
        d.nom_etablissement = Etablissements[id].nom_etablissement;
        d.pays = pays;
        d.type_diplome = type_diplome;
        d.specialite = specialite;
        d.mention = mention;
        d.date_obtention = date_obtention;
        ajouterDiplomes(d);
    }


    function evaluer(uint256 id_etudiant,string memory sujet_pfe,string memory entreprise_stage_pfe,string memory maitre_stage,string memory date_debut_stage,string memory date_fin_stage,string memory evaluation) public {
        uint256 id = AdresseEntreprises[uint256(uint160(msg.sender))];
        require(id != 0, "pas une entreprise");
        require(Etudiants[id_etudiant].existe == true, "pas un etudiant");
        Etudiants[id_etudiant].infoAcademique.sujet_pfe = sujet_pfe;
        Etudiants[id_etudiant].infoAcademique.entreprise_stage_pfe = entreprise_stage_pfe;
        Etudiants[id_etudiant].infoAcademique.maitre_stage = maitre_stage;
        Etudiants[id_etudiant].infoAcademique.date_debut_stage = date_debut_stage;
        Etudiants[id_etudiant].infoAcademique.date_fin_stage = date_fin_stage;
        Etudiants[id_etudiant].infoAcademique.evaluation = evaluation;
        
        require(
            Token(token).allowance(owner, address(this)) >= 15, 
            "Token not allowed"
        );
        require(
            Token(token).transferFrom(owner, msg.sender, 15),
            "Transfer failed"
        );
    }


    event VerificationResultat(bool success, InfoDiplome diplome);


    function verify(uint256 diplomeId) public returns (bool, InfoDiplome memory) {
        require(
            Token(token).allowance(msg.sender, address(this)) >= 10,
            "Token not allowed"
        );
        require(
            Token(token).transferFrom(msg.sender, owner, 10),
            "Transfer failed"
        );
        emit VerificationResultat(Diplomes[diplomeId].existe, Diplomes[diplomeId]);
        return (Diplomes[diplomeId].existe, Diplomes[diplomeId]);
    }
}