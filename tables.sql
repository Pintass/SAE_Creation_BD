-- Création des tables

CREATE TABLE Pays (
    nom_pays VARCHAR(80) PRIMARY KEY,
    langage VARCHAR(80) NOT NULL
);

CREATE TABLE Compte_utilisateur (
    login VARCHAR(20) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    n_telephone NUMBER,
    email VARCHAR(25) NOT NULL,
    date_naissance DATE,
    adresse VARCHAR(50),
    date_inscription TIMESTAMP DEFAULT SYSDATE,
    pays_residence VARCHAR(40) REFERENCES Pays(nom_pays)
);

CREATE TABLE Chaine (
    id_chaine NUMBER PRIMARY KEY,
    createur_chaine VARCHAR(20) REFERENCES Compte_utilisateur(login),
    nom_chaine VARCHAR(30) NOT NULL,
    desc_chaine VARCHAR(255),
    date_creation TIMESTAMP DEFAULT SYSDATE,
    fichier_logo BLOB NOT NULL,
    fichier_banniere BLOB NOT NULL
);

CREATE TABLE Playlist (
    id_playlist NUMBER PRIMARY KEY,
    createur_playlist VARCHAR(20) REFERENCES Compte_utilisateur(login),
    nom_playlist VARCHAR(30) NOT NULL,
    desc_playlist VARCHAR(100),
    statut_playlist VARCHAR(20) NOT NULL CHECK (statut_playlist IN ('publique', 'non-repertoriée', 'privée')),
    date_creation_playlist TIMESTAMP DEFAULT SYSDATE
);

CREATE TABLE Video (
    id_video NUMBER PRIMARY KEY,
    titre_video VARCHAR(30) NOT NULL,
    createur_video VARCHAR(20) REFERENCES Compte_utilisateur(login),
    fichier_media_video BLOB NOT NULL,
    description_video VARCHAR(255),
    date_publication TIMESTAMP DEFAULT SYSDATE,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('publique', 'non-repertoriée', 'privée')),
    duree INTERVAL DAY TO SECOND NOT NULL,
    fichier_miniature BLOB,
    adapte_aux_enfants VARCHAR(1) NOT NULL CHECK (adapte_aux_enfants IN ('O', 'N')),
    id_chaine NUMBER REFERENCES Chaine(id_chaine)
);

CREATE TABLE Reaction (
    titre_reaction VARCHAR(30) PRIMARY KEY,
    auteur_reaction VARCHAR(30) DEFAULT USER,
    type_reaction VARCHAR(20) NOT NULL,
    favoris VARCHAR(1) NOT NULL CHECK (favoris IN ('O', 'N')),
    login VARCHAR(30) REFERENCES Compte_utilisateur(login),
    id_video NUMBER REFERENCES Video(id_video)
);

CREATE TABLE Historique_lecture (
    id_video NUMBER REFERENCES Video(id_video),
    date_lecture TIMESTAMP DEFAULT SYSDATE,
    login VARCHAR(20) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Commentaire (
    id_commentaire NUMBER PRIMARY KEY,
    auteur_commentaire VARCHAR(20) REFERENCES Compte_utilisateur(login),
    contenu_texte VARCHAR(255) NOT NULL,
    date_commentaire TIMESTAMP DEFAULT SYSDATE,
    a_ete_modifie VARCHAR(1) NOT NULL CHECK (a_ete_modifie IN ('O', 'N')),
    commentaire_pere NUMBER REFERENCES Commentaire(id_commentaire) ON DELETE CASCADE,
    id_video NUMBER REFERENCES Video(id_video),
    nom_pays VARCHAR(40) REFERENCES Pays(nom_pays)
);

CREATE TABLE Media_produit (
    id_media NUMBER PRIMARY KEY,
    titre_media VARCHAR(25) NOT NULL,
    fichier_media BLOB NOT NULL
);

CREATE TABLE Produit_propose (
    id_produit NUMBER NOT NULL PRIMARY KEY,
    nom_produit VARCHAR(30) NOT NULL,
    description_produit VARCHAR(255),
    type_prod VARCHAR(30) NOT NULL,
    date_publication TIMESTAMP DEFAULT SYSDATE,
    id_media NUMBER REFERENCES Media_produit(id_media)
);

CREATE TABLE Moyen_paiement (
    id_moyen NUMBER PRIMARY KEY,
    nom_moyen VARCHAR(30) NOT NULL,
    plafond_maximal NUMBER,
    plafond_minimal NUMBER,
    id_produit NUMBER REFERENCES Produit_propose(id_produit),
    login VARCHAR(30) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Publicite (
    id_publicite NUMBER NOT NULL PRIMARY KEY,
    fichier_media_publicite BLOB NOT NULL,
    titre_publicite VARCHAR(30) NOT NULL,
    description_publicite VARCHAR(255),
    duree INTERVAL DAY TO SECOND NOT NULL,
    id_produit NUMBER REFERENCES Produit_propose(id_produit)
);

CREATE TABLE Categorie (
    id_categorie NUMBER PRIMARY KEY,
    nom_categorie VARCHAR(30) NOT NULL,
    description_categorie VARCHAR(255),
    id_video NUMBER REFERENCES Video(id_video)
);

CREATE TABLE Signalement (
    id_signalement NUMBER PRIMARY KEY,
    titre_signalement VARCHAR(30) NOT NULL,
    contenu_signalement VARCHAR(200) NOT NULL,
    statut_signalement VARCHAR(30) NOT NULL,
    date_signalement TIMESTAMP DEFAULT SYSDATE,
    type_contenu VARCHAR(16) NOT NULL CHECK (type_contenu IN ('Video', 'Commentaire', 'Chaine')),
    login VARCHAR(30) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Statistiques_video (
    id_stats NUMBER PRIMARY KEY,
    nb_vues NUMBER NOT NULL,
    nb_dislikes NUMBER NOT NULL,
    nb_likes NUMBER NOT NULL,
    nb_ajouts_playlist NUMBER NOT NULL,
    id_video NUMBER REFERENCES Video(id_video)
);

CREATE TABLE Recherche (
    id_recherche NUMBER PRIMARY KEY,
    date_recherche TIMESTAMP DEFAULT SYSDATE,
    contenu_recherche VARCHAR(200) NOT NULL,
    login VARCHAR(30) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Mot_clef (
    id_mot_clef NUMBER PRIMARY KEY,
    nom_mot_clef VARCHAR(25) NOT NULL,
    id_recherche NUMBER REFERENCES Recherche(id_recherche)
);

CREATE TABLE Ligne_achat_produit (
    id_achat_produit NUMBER PRIMARY KEY,
    statut_commande VARCHAR(30) NOT NULL
);

CREATE TABLE Historique_achat (
    id_achat NUMBER PRIMARY KEY,
    montant NUMBER NOT NULL,
    date_paiement TIMESTAMP DEFAULT SYSDATE,
    id_achat_produit NUMBER REFERENCES Ligne_achat_produit(id_achat_produit),
    auteur_achat VARCHAR(30) DEFAULT USER
);

CREATE TABLE Moderateur_plateforme (
    id_moderateur_plat NUMBER PRIMARY KEY,
    date_promotion TIMESTAMP DEFAULT SYSDATE,
    login VARCHAR(30) REFERENCES Compte_utilisateur(login),
    id_signalement NUMBER REFERENCES Signalement(id_signalement)
);

CREATE TABLE Moderateur_chaine (
    id_moderateur_chaine NUMBER PRIMARY KEY,
    date_promotion TIMESTAMP DEFAULT SYSDATE,
    id_chaine NUMBER REFERENCES Chaine(id_chaine),
    login VARCHAR(30) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Abonnement (
    login VARCHAR(30) REFERENCES Compte_utilisateur(login),
    id_chaine NUMBER REFERENCES Chaine(id_chaine),
    date_abonnement TIMESTAMP DEFAULT SYSDATE,
    etat_notifications VARCHAR(30) NOT NULL,
    PRIMARY KEY (login, id_chaine)
);

CREATE TABLE preference_compte_utilisateur (
    id_preference NUMBER PRIMARY KEY,
    score_recherche NUMBER NOT NULL,
    score_type_video_vue NUMBER NOT NULL,
    login VARCHAR(20) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE Centre_interets (
    id_cinterets NUMBER PRIMARY KEY,
    titre_cinterets VARCHAR(25) NOT NULL,
    desc_cinterets VARCHAR(255) NOT NULL,
    login VARCHAR(20) REFERENCES Compte_utilisateur(login)
);

CREATE TABLE diffuseur_publicite (
    id_diffuseur NUMBER PRIMARY KEY,
    nom_diffuseur VARCHAR(30) NOT NULL,
    contact_telephonique_diffuseur NUMBER NOT NULL,
    adresse_diffuseur VARCHAR(100) NOT NULL,
    email_diffuseur VARCHAR(30) NOT NULL,
    id_produit NUMBER REFERENCES Produit_propose(id_produit)
);

-- Création des rôles et initiation des permissions

CREATE ROLE MODERATEUR;
CREATE ROLE MEMBRE;
GRANT MEMBRE TO login;
GRANT INSERT ON Compte_utilisateur TO MEMBRE, MODERATEUR;

-- Permissions pour tout le monde

GRANT SELECT ON Playlist TO PUBLIC;
GRANT SELECT ON Chaine TO PUBLIC;
GRANT SELECT ON Video TO PUBLIC;
GRANT SELECT ON Commentaire TO PUBLIC;
GRANT SELECT ON Categorie TO PUBLIC;
GRANT SELECT ON Statistiques_video TO MEMBRE, MODERATEUR;
GRANT SELECT ON Publicite TO PUBLIC;

-- Permissions pour le rôle MEMBRE

GRANT INSERT ON Video TO MEMBRE, MODERATEUR;
GRANT INSERT ON Commentaire TO MEMBRE, MODERATEUR;
GRANT SELECT ON Produit_propose TO MEMBRE, MODERATEUR;
GRANT SELECT ON Pays TO MEMBRE, MODERATEUR;
GRANT INSERT ON Reaction TO MEMBRE, MODERATEUR;
GRANT INSERT ON Categorie TO MEMBRE, MODERATEUR;
GRANT INSERT ON Recherche TO MEMBRE, MODERATEUR;
GRANT INSERT ON Signalement TO MEMBRE, MODERATEUR;

-- Permissions pour le rôle MODERATEUR

GRANT UPDATE ON Commentaire TO MODERATEUR;
GRANT UPDATE ON Categorie TO MODERATEUR;
GRANT SELECT, INSERT, UPDATE ON Compte_utilisateur TO MODERATEUR;
GRANT SELECT, INSERT ON Moderateur_plateforme TO MODERATEUR;
GRANT DELETE ON Chaine TO MODERATEUR;
GRANT DELETE ON Video TO MODERATEUR;
GRANT DELETE ON Commentaire TO MODERATEUR;
GRANT DELETE ON Playlist TO MODERATEUR;
GRANT DELETE ON Reaction TO MODERATEUR;
GRANT DELETE ON Publicite TO MODERATEUR;
GRANT SELECT, INSERT, UPDATE ON Signalement TO MODERATEUR;

-- Création de vues et initiation de leurs permissions

CREATE VIEW ajout_moderateur_chaine AS (SELECT mc.login FROM Moderateur_chaine mc, Chaine WHERE Chaine.id_chaine = mc.id_chaine AND Chaine.createur_chaine = user);
GRANT INSERT, UPDATE, SELECT ON ajout_moderateur_chaine TO MEMBRE, MODERATEUR;

CREATE VIEW signalement_perso AS (SELECT titre_signalement, contenu_signalement, statut_signalement, type_contenu FROM Signalement WHERE login = user);
GRANT SELECT ON signalement_perso TO MEMBRE, MODERATEUR;

CREATE VIEW gestion_compte AS (SELECT nom,prenom,n_telephone,email,adresse,pays_residence,date_naissance FROM Compte_utilisateur WHERE login = user);
GRANT UPDATE ON gestion_compte TO PUBLIC, MEMBRE, MODERATEUR;

CREATE VIEW video_visible AS (SELECT * FROM Video WHERE statut = 'publique');
GRANT SELECT ON video_visible TO PUBLIC, MEMBRE, MODERATEUR;

CREATE VIEW playlist_visible AS (SELECT * FROM Playlist WHERE statut_playlist = 'publique');
GRANT SELECT ON playlist_visible TO PUBLIC, MEMBRE, MODERATEUR;

CREATE VIEW gestion_chaine AS (SELECT nom_chaine, desc_chaine, fichier_logo, fichier_banniere FROM Chaine WHERE createur_chaine = USER);
GRANT INSERT, UPDATE ON gestion_chaine TO MEMBRE, MODERATEUR;

CREATE VIEW playlist_perso AS (SELECT nom_playlist, desc_playlist FROM Playlist WHERE createur_playlist = USER);
GRANT INSERT, UPDATE ON playlist_perso TO MEMBRE, MODERATEUR;

CREATE VIEW modif_comm_perso AS (SELECT contenu_texte FROM Commentaire WHERE auteur_commentaire = USER);
GRANT SELECT, UPDATE, DELETE ON modif_comm_perso TO MEMBRE, MODERATEUR;

CREATE VIEW modif_video_perso AS (SELECT titre_video, description_video, statut, fichier_miniature FROM Video WHERE createur_video = USER);
GRANT SELECT, INSERT, UPDATE, DELETE ON modif_video_perso TO MEMBRE, MODERATEUR;

CREATE VIEW achat_perso AS (SELECT * FROM Historique_achat WHERE auteur_achat = USER);
GRANT SELECT ON achat_perso TO MEMBRE, MODERATEUR;

-- Anaïs Giraud & Daniel Rodrigues Amorim
