# Nerdboard frontend

Een 'Vue 3 en TypeScript' frontend voor de login, registratie en dashboardwireframes.

## Starten

Start eerst de Rails-backend vanuit de map `nerdboard`:

```sh
bin/rails server -p 3000
```

Start daarna de frontend vanuit de map `dashboard-frontend`:

```sh
npm install
npm run dev
```

De Vite-ontwikkelserver stuurt `/api/*` automatisch door naar Rails op poort 3000. Maak een account aan of log in met een bestaand account. De frontend gebruikt de Rails-endpoints voor registratie, login, sessiecontrole, logout en projecten.

Een account moet door een beheerder aan een Simplicate-organisatie gekoppeld worden voordat het projecten kan ophalen. De Simplicate-integratie in de backend is nog niet echt geïmplementeerd; momenteel retourneert de service voorbeeldprojecten. Voor productie moet ook een proxy/API-adres worden ingericht; de Vite-proxy geldt alleen lokaal.

Voor de huidige lokale voorbeelddata kun je na registratie in de Rails-console een account aan organisatie `999` koppelen:

```ruby
User.find_by!(email: "jouw-email@example.nl").update!(simplicate_organization_id: 999)
```

Daarna opnieuw naar het dashboard gaan. De organisatie-ID mag niet vanuit het registratieformulier worden gekozen; die koppeling moet door een beheerder gebeuren.

## Hoe de onderdelen samenwerken

- `src/main.ts` laadt de algemene CSS, start Vue en registreert Vue Router.
- `src/router.ts` koppelt de URLs `/` en `/dashboard` aan de bijbehorende pagina's en controleert de loginstatus.
- `src/App.vue` toont de pagina die bij de huidige URL hoort.
- `src/composables/useAuth.ts` handelt registratie, login, tokenopslag, sessieherstel en logout af via de backend.
- `src/services/api.ts` verzorgt API-verzoeken naar Rails.
- `src/composables/useProjects.ts` haalt de projecten van de ingelogde klant op via de backend.
- `src/views/` bevat de routepagina's; `src/layouts/` bevat de gedeelde dashboardindeling.
- `src/views/LoginPage.vue` toont het login- en registratieformulier.
- `src/layouts/DashboardLayout.vue` brengt de bovenbalk, navigatie en dashboardpagina's samen; `src/components/DashboardNav.vue` bevat de navigatie.
- `src/views/DashboardPage.vue` toont de projecten die de backend voor de gekoppelde organisatie teruggeeft.
- `src/components/ProjectCard.vue` toont de naam van één project.
- `src/assets/styles/` bevat de gedeelde CSS, los van de Vue-templates.
- `src/locales/nl.json` bevat de Nederlandse UI-teksten; `src/i18n.ts` configureert Vue I18n.
