# Nerdboard frontend

Een Vue 3- en TypeScript-frontend voor de login, registratie en dashboardwireframes.

## Starten

Voer deze opdrachten uit vanuit de map `dashboard-frontend`:

```sh
npm install
npm run dev
```

Maak een productiebuild met `npm run build`.

## Hoe de onderdelen samenwerken

- `src/main.ts` laadt de algemene CSS en start Vue.
- `src/App.vue` houdt bij of de demo is geopend, welke pagina actief is en welk project is geselecteerd. Het verbindt schermen door eigenschappen door te geven en gebeurtenissen op te vangen.
- `src/components/AuthView.vue` toont het login en registratieformulier. Na invullen opent de demo; de gegevens worden niet naar een server gestuurd.
- `src/components/DashboardShell.vue` toont de bovenbalk en navigatie die bij ingelogde dashboardschermen horen.
- `src/components/DashboardView.vue` toont de urenkaarten, statusfilters en projectkaarten.
- `src/components/ProjectCard.vue` toont één project. De knop stuurt het gekozen project terug naar `App.vue`, dat de detailpagina opent.
- `src/components/ProjectDetailView.vue` toont uren en fasen van het gekozen project.
- `src/components/ProfileView.vue` toont de accountgegevens van de demosessie.
- `src/data/projects.ts` bevat fictieve projecten voor de demo; `src/types.ts` beschrijft de vorm van project-, profiel- en paginagegevens.
- `src/style.css`, `src/auth.css` en `src/dashboard.css` bevatten de CSS, los van de Vue-templates.

In Vue geeft een oudercomponent gegevens door aan een kind via props. Een kind meldt een gebruikersactie terug via een event. Bijvoorbeeld: `ProjectCard` meldt welk project is aangeklikt; `App.vue` bewaart dat project en toont `ProjectDetailView`.

## Wat nog niet echt gekoppeld is

De login en registratie zijn alleen een demo en verifiëren geen account. De voorbeeldprojecten zijn niet afkomstig uit Simplicate. Voor echte accounts, beveiliging, autorisatie en actuele projectgegevens is de backend nodig; de frontend hoort niet rechtstreeks met Simplicate te verbinden. Dat komt nog als ik de simplicate-api key heb. 
