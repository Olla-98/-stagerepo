# Nerdboard frontend

Een 'Vue 3 en TypeScript' frontend voor de login, registratie en dashboardwireframes.

## Starten

Voer deze opdrachten uit vanuit de map `dashboard-frontend`:

```sh
npm install
npm run dev
```

## Hoe de onderdelen samenwerken

- `src/main.ts` laadt de algemene CSS, start Vue en registreert Vue Router.
- `src/router.ts` koppelt de URLs `/`, `/dashboard` en `/projects/:id` aan de bijbehorende pagina's.
- `src/App.vue` toont de pagina die bij de huidige URL hoort.
- `src/composables/useDemoSession.ts` bewaart alleen de naam en het e-mailadres van de demo in `sessionStorage`, zodat verversen in hetzelfde browsertabblad de sessie behoudt.
- `src/views/` bevat de routepagina's; `src/layouts/` bevat de gedeelde dashboardindeling.
- `src/views/LoginPage.vue` toont het login- en registratieformulier. Na invullen opent de demo; de gegevens worden niet naar een server gestuurd.
- `src/layouts/DashboardLayout.vue` brengt de bovenbalk, navigatie en dashboardpagina's samen; `src/components/DashboardNav.vue` bevat de navigatie.
- `src/views/DashboardPage.vue` toont de urenkaarten, statusfilters en projectkaarten.
- `src/components/ProjectCard.vue` toont één project en linkt naar de URL van de bijbehorende projectdetails.
- `src/views/ProjectDetailPage.vue` toont uren en fasen van het gekozen project en linkt terug naar het dashboard.
- `src/data/projects.ts` bevat fictieve projecten voor de demo; `src/types/index.ts` beschrijft de vorm van project- en gebruikersgegevens.
- `src/assets/styles/` bevat de gedeelde CSS, los van de Vue-templates.
- `src/locales/nl.json` bevat de Nederlandse UI-teksten; `src/i18n.ts` configureert Vue I18n.

Projectdetails hebben elk hun eigen URL, bijvoorbeeld `/projects/website`. Een onbekend project leidt terug naar het dashboard.

## Wat nog niet echt gekoppeld is

De login en registratie zijn alleen een demo en verifiëren geen account. De voorbeeldprojecten zijn niet afkomstig uit Simplicate. Voor echte accounts, beveiliging, autorisatie en actuele projectgegevens is de backend nodig; de frontend hoort niet rechtstreeks met Simplicate te verbinden. Dat komt nog als ik de simplicate-api key heb. 
