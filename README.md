# Planning Dev

Planning hebdomadaire de l'équipe dev : qui travaille sur quel projet, les absences, et le bilan mensuel prévu / réel (temps Redmine).

- **Site** : `public/index.html` (une seule page, sans étape de build), publiée par GitHub Pages via `.github/workflows/pages.yml`.
- **Données** : Supabase, projet `planning-dev` (région Paris). Schéma dans `supabase/schema.sql`.
- **Connexion** : lien magique envoyé par e-mail (Supabase Auth). Toute personne connectée peut lire et modifier.

## Mise en route

1. Pousser ce dépôt sur GitHub, puis dans *Settings → Pages*, choisir **Source : GitHub Actions**. Le workflow publie le site sur `https://<votre-identifiant>.github.io/planning-dev/`.
2. Dans Supabase → *Authentication* → *URL Configuration* :
   - **Site URL** : l'adresse GitHub Pages ci-dessus ;
   - **Redirect URLs** : ajouter la même adresse.
   Sans ça, le lien reçu par e-mail renvoie vers `localhost`.

## Données

| Chemin | Contenu |
|---|---|
| `config/team` | développeurs et projets (nom, couleur, archivé) |
| `config/redmine` | heures par jour (7,5) et correspondances des noms Redmine |
| `weeks/<AAAA-MM-JJ>` | une semaine (clé = lundi) : `days[dev][0..4] = [{p: projet, v: 1 ou 0.5} ou {abs: CP/TP/E/M/F/A, v}]` |
| `actuals/<AAAA-MM>` | temps réels en jours : `values[dev][projet]` |
