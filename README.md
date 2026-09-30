# Planning Dev

Planning hebdomadaire de l'équipe dev : qui travaille sur quel projet, les absences, et le bilan mensuel prévu / réel (temps Redmine).

- **Site** : `public/index.html` (une seule page, sans étape de build), publiée par GitHub Pages via `.github/workflows/pages.yml`.
- **Données** : Supabase, projet `planning-dev` (région Paris). Schéma dans `supabase/schema.sql`.
- **Accès** : page de mot de passe. Le mot de passe est celui du compte Supabase `webmaster@culture.gouv.fr` : il n'est pas dans le code, Supabase le vérifie. Seul ce compte peut lire ou modifier les données (règles RLS).

## Mise en route

1. Pousser ce dépôt sur GitHub, puis dans *Settings → Pages*, choisir **Source : GitHub Actions**. Le workflow publie le site sur `https://<votre-identifiant>.github.io/planning-dev/`.
2. Dans Supabase → *Authentication* → *Users* → *Add user* → *Create new user* : e-mail `webmaster@culture.gouv.fr`, le mot de passe de l'équipe, cocher **Auto Confirm User**.
3. Pour changer le mot de passe : même écran, menu du compte → *Reset password* ou *Change password*.

## Données

| Chemin | Contenu |
|---|---|
| `config/team` | développeurs et projets (nom, couleur, archivé) |
| `config/redmine` | heures par jour (7,5) et correspondances des noms Redmine |
| `weeks/<AAAA-MM-JJ>` | une semaine (clé = lundi) : `days[dev][0..4] = [{p: projet, v: 1 ou 0.5} ou {abs: CP/TP/E/M/F/A, v}]` |
| `actuals/<AAAA-MM>` | temps réels en jours : `values[dev][projet]` |
