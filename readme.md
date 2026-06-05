
# Banking Analytics & Business Intelligence Platform

[![Data Stack](https://img.shields.io/badge/Stack-PostgreSQL%20%7C%20dbt%20%7C%20Neo4j%20%7C%20Power%20BI-blue)](#)

## 📝 Description du Projet
Ce projet propose une plateforme décisionnelle de Business Intelligence (BI) de bout en bout dédiée au secteur bancaire. L'objectif est d'ingérer des flux de transactions brutes, de structurer un entrepôt de données centralisé, d'appliquer une analyse de réseaux (graphes) pour segmenter la clientèle en communautés, de détecter les risques de fraude et de propulser un moteur de recommandation de produits dynamique.

> 💾 **Source des données :** Le dataset brut initial utilisé pour alimenter ce projet provient du dépôt public [Banking-Dataset par ahsan084](https://github.com/ahsan084/Banking-Dataset).

---

## 🏗️ Architecture et Structure du Dépôt

Le projet est modulaire et structuré de la manière suivante :

```text
├── .github/workflows/        # Pipeline CI/CD (GitHub Action)
├── bank_bi/                  # Projet dbt (Nettoyage, staging et modèles de Data Warehouse)
│   ├── models/
│   │   ├── staging/          # Vues de nettoyage et sources (schema.yml)
│   │   └── marts/            # Tables physiques finales (Faits et Dimensions)
├── fichier_sql/              # Scripts DDL exécutés dans pgAdmin (Contraintes PK/FK, relations 1:N)
├── graph/                    # Scripts Python connectés à Neo4j (Détection de communautés - Louvain)
├── raw_data/                 # Fichiers de données sources brutes (Fichiers CSV)
└── README.md                 # Documentation principale du dépôt

```

---

## ⚙️ Pipeline de Données & Choix Techniques

Le flux de traitement de la donnée respecte rigoureusement les étapes suivantes :

1. **Ingestion brute :** Chargement des fichiers du dossier `raw_data/` dans des tables de stockage temporaires au sein d'une base de données **PostgreSQL**.
   
3. **Transformation dbt :** Nettoyage des types de données, gestion des valeurs manquantes et préparation des tables de staging dans le dossier `bank_bi/`.
4. **Analyse de Graphes (Neo4j) :** Exportation des données nettoyées vers **Neo4j** pour modéliser les clients et leurs interactions. Exécution du script Python (`graph/`) appliquant l'**Algorithme de Louvain** pour calculer l'index de modularité et segmenter les clients en communautés homogènes.
5. **Vue des Communautés :** Les ID de communautés générés par l'algorithme sont réimportés dans PostgreSQL à travers une vue de table spécifique (`stg_communities`) directement jointe à la dimension finale des clients (`dim_customers`).
6. **Scellage relationnel (pgAdmin) :** Exécution des scripts du dossier `fichier_sql/` depuis l'interface **pgAdmin** pour appliquer physiquement les contraintes de clés primaires (PK) et clés étrangères (FK) afin de sceller le Schéma en Étoile (relations 1:N).
7. **Restitution Power BI :** Importation du modèle physique dans **Power BI Desktop** pour la construction d'un dashboard décisionnel interactif sur deux pages.

---

## 🛠️ Validation & Modélisation dbt

Les relations de l'entrepôt sont testées automatiquement via dbt. Voici un aperçu des tests d'intégrité appliqués dans `bank_bi/models/staging/schema.yml` :

```yaml
version: 2

sources:
  - name: internal_data
    schema: raw
    tables:
      - name: raw_transactions
      - name: stg_communities

models:
  - name: fct_transactions
    columns:
      - name: branch_id
        tests:
          - relationships:
              to: ref('dim_branches')
              field: branch_id
      - name: customer_id
        tests:
          - relationships:
              to: ref('dim_customers')
              field: customer_id

```

---

## 🧠 Intelligence Analytique & Logique DAX

Le dashboard Power BI intègre un **Moteur de Recommandation Dynamique (*Next Best Action*)** écrit en DAX. Dès qu'un utilisateur sélectionne une communauté à l'aide du segment (`community_id`), le système calcule instantanément le produit financier le plus populaire (utilisé par le plus grand nombre de clients uniques au sein de ce groupe) pour le proposer à l'écran :

```dax
Produit Recommande Popularite = 
VAR _CommSelectionnee = SELECTEDVALUE(dim_customers[community_id])
RETURN
IF(
    ISBLANK(_CommSelectionnee),
    "Sélectionnez une communauté",
    TOPN(
        1, 
        VALUES(fct_transactions[transaction_type]), 
        [Nombre de Clients], 
        DESC
    )
)

```

---

## 🚀 Guide de Déploiement Rapide

### Prérequis

* PostgreSQL 14+ & pgAdmin 4
* dbt-core & dbt-postgres
* Python 3.10+ & Instance Neo4j active
* Power BI Desktop

### Étapes d'exécution

1. **Préparer l'entrepôt avec dbt :**
```bash
cd bank_bi
dbt deps
dbt run --full-refresh
dbt test

```


2. **Lancer le calcul des communautés :** Exécuter le script présent dans le dossier `graph/` pour projeter le réseau dans Neo4j, calculer les partitions de Louvain et mettre à jour la vue `stg_communities`.
3. **Appliquer les contraintes physiques :** Ouvrir **pgAdmin** et exécuter les scripts SQL de `fichier_sql/` pour sceller les clés étrangères de la table de faits `fct_transactions`.
4. **Visualiser :** Ouvrir le rapport dans **Power BI**, actualiser les données pour charger le schéma en étoile interconnecté, et utiliser les filtres synchronisés sur les deux pages d'analyse.

---
## 👥 Équipe
SMAOUI MOHAMED 
AMARA YASSINE

*Projet académique réalisé dans le cadre du module BI (2026).*
