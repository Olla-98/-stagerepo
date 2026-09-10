# Technisch ontwerp

## 1. Inleiding

Dit document beschrijft de technische opbouw van het klantdashboard.

De applicatie wordt opgebouwd uit een frontend en backend. De backend verzorgt onder andere de authenticatie, autorisatie en communicatie met de Simplicate REST API.

De frontend communiceert niet rechtstreeks met Simplicate.


## 2. Technologieën

De voorlopige technische stack bestaat uit:

| Onderdeel                | Technologie                          |

| Frontend                 | Vue                                 |

| Programmeertaal frontend | TypeScript                           |

| Backend                  |  Ruby                                 |

| Backend framework        | Elixir!                             |

| Data-integratie          | Simplicate REST API                  |

| Database                 | voor gebruikersgegevens / alleen indien nodig |

| Versiebeheer             | Git                                  |

| Repository               | GitHub                               |

Deze technologieën sluiten aan bij de bestaande kennis en de eisen van het project.


## 3. Architectuur

De applicatie krijgt globaal de volgende architectuur:


┌─────────────────────┐
│      Klant          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Vue   + Javascript  │
│     Frontend        │
└──────────┬──────────┘
           │ HTTP/JSON
           ▼
┌─────────────────────┐
│      Ruby.          │
│      Backend        │
├─────────────────────┤
│Registratie          |
|Authenticatie        │
│ Autorisatie         │
│ API-logica          │
└──────────┬──────────┘
           │ HTTPS
           ▼
┌─────────────────────┐
│   Simplicate API    │
└─────────────────────┘


Wanneer een database nodig is voor gebruikersgegevens, wordt deze gekoppeld aan de backend.


## 4. Frontend

De frontend wordt ontwikkeld met Vue en Javascript.

De frontend is verantwoordelijk voor:

* registratiepagina;
* loginpagina;
* dashboard;
* projectoverzicht;
* projectdetails;
* navigatie;
* tonen van laadstatussen;
* tonen van foutmeldingen.

De frontend ontvangt alleen de gegevens die de backend beschikbaar stelt.

API-credentials van Simplicate worden nooit in de frontend opgeslagen.



## 5. Backend

De backend wordt ontwikkeld met Ruby.

De backend vormt de tussenlaag tussen de frontend en Simplicate.

De backend is verantwoordelijk voor:

* gebruikersregistratie;
* authenticatie;
* autorisatie;
* gebruikerssessies/tokens;
* ophalen van gegevens uit Simplicate;
* verwerken van gegevens;
* berekenen van resterende uren;
* terugsturen van klantgerichte gegevens naar de frontend;
* afhandelen van fouten.


## 6. Simplicate REST API

Voor de koppeling met Simplicate wordt de REST API gebruikt.

De belangrijkste onderzochte endpoints zijn:


* GET /api/v2/crm/organization


Voor organisaties/klanten.


* GET /api/v2/projects/project


Voor projecten.


* GET /api/v2/hours/hours


Voor urenregistraties.


Daarnaast is binnen de Simplicate API een endpoint voor planning budget beschikbaar:


* GET /api/v2/projects/service/{id}/planningBudget


De exacte responsevelden van dit endpoint worden tijdens de implementatie geverifieerd.


## 7. API-authenticatie

De Simplicate API maakt gebruik van een API Key en API Secret.

Deze gegevens worden uitsluitend door de backend gebruikt.

De credentials worden opgeslagen als environment variables.


Voorbeeld:

`env
SIMPLICATE_API_KEY=...
SIMPLICATE_API_SECRET=...
SIMPLICATE_BASE_URL=...
`

Het `.env` bestand wordt niet opgenomen in Git.

Een `.env.example` bestand kan worden gebruikt om aan te geven welke variabelen nodig zijn.


## 8. Gegevensstroom

De gegevensstroom verloopt als volgt:


1. Klant logt in
        ↓
2. Backend controleert gebruiker
        ↓
3. Backend bepaalt bij welke klant/organisatie de gebruiker hoort
        ↓
4. Backend haalt projecten op uit Simplicate
        ↓
5. Backend haalt benodigde ureninformatie op
        ↓
6. Backend verwerkt de gegevens
        ↓
7. Backend controleert autorisatie
        ↓
8. Alleen toegestane gegevens worden naar frontend gestuurd
        ↓
9. Vue toont gegevens op het dashboard



## 9. Gebruikers en database

Een eigen database wordt niet gebruikt om alle Simplicate-projecten en uren te dupliceren.

Simplicate blijft de bron van waarheid voor project- en ureninformatie.

Een eigen database kan wel worden gebruikt voor gebruikersgegevens en de koppeling tussen een dashboardgebruiker en een Simplicate-organisatie.


Een mogelijke structuur is:

User

id: 
email: 
password_hash: 
simplicate_customer_id: 
simplicate_organization_id:
created_at: 
updated_at:

Hierbij is simplicate_organization_id de koppeling tussen de dashboardgebruiker en de klant/organisatie in Simplicate.

Bijvoorbeeld:

Dashboard User
id: 7
email: klant@example.nl
simplicate_organization_id: 12345

De gebruiker krijgt hiermee niet direct toegang tot Simplicate.

De backend gebruikt deze ID om te bepalen welke gegevens de gebruiker mag opvragen.

De exacte database en datastructuur worden bepaald wanneer de authenticatie wordt geïmplementeerd.


## 10. Autorisatie

Autorisatie wordt in de backend uitgevoerd.

Een dashboardgebruiker wordt gekoppeld aan een Simplicate-organisatie.

Wanneer de gebruiker projecten opvraagt, controleert de backend of de projecten bij de gekoppelde organisatie horen.

De frontend mag niet verantwoordelijk zijn voor deze beveiligingscontrole.

Dit voorkomt dat een gebruiker door het aanpassen van een URL of project-ID gegevens van een andere klant kan opvragen.


## 11. API-laag

De backend krijgt een aparte laag voor communicatie met Simplicate.

Een mogelijke structuur:


backend/
├── src/
│   ├── routes/
│   ├── controllers/
│   ├── services/
│   ├── middleware/
│   └── config/


De Simplicate API-logica wordt zoveel mogelijk in services geplaatst.

Bijvoorbeeld:

simplicateService

Deze service is verantwoordelijk voor het uitvoeren van requests naar Simplicate.


## 12. Mogelijke backend endpoints

De frontend communiceert met de eigen backend.

Mogelijke endpoints:

POST /api/auth/register
POST /api/auth/login
POST /api/auth/logout
GET  /api/auth/me

GET  /api/projects
GET  /api/projects/:id

De backend gebruikt vervolgens de Simplicate API om de benodigde gegevens op te halen.

## 13. Authenticatie

Voor authenticatie wordt een veilige manier gebruikt om gebruikerssessies te beheren.

Wachtwoorden worden nooit als plaintext opgeslagen.

De database bevat uitsluitend een veilige password hash.

De authenticatie wordt volledig via de backend afgehandeld.


## 14. Berekeningen

Wanneer Simplicate de benodigde waarden afzonderlijk aanlevert, kunnen bepaalde waarden in de backend worden berekend.

Bijvoorbeeld:

resterende uren =
urenbudget - geregistreerde uren

De backend geeft vervolgens de verwerkte gegevens terug aan de frontend.


## 14. Beveiliging

De applicatie moet rekening houden met de volgende beveiligingsmaatregelen:

* HTTPS gebruiken;
* API-credentials niet in de frontend plaatsen;
* API-credentials via environment variables beheren;
* wachtwoorden niet als plaintext opslaan;
* wachtwoorden veilig hashen;
* authenticatie afdwingen op beveiligde routes;
* autorisatie server-side uitvoeren;
* gebruikers alleen toegang geven tot hun eigen gegevens;
* `.env` uitsluiten van Git.
* geen gevoelige interne Simplicate-informatie naar de frontend sturen.


## 15. Foutafhandeling

De backend moet fouten van Simplicate correct afhandelen.

Bijvoorbeeld wanneer:

* Simplicate niet bereikbaar is;
* een API-request mislukt;
* een gebruiker geen toegang heeft;
* een project niet bestaat;
* authenticatiegegevens ongeldig zijn.

De backend geeft hierbij een passende HTTP-status en foutmelding terug.

Technische details zoals API-credentials of stack traces worden niet naar de gebruiker gestuurd.


## 16. API-limieten

Bij het gebruik van de Simplicate API moet rekening worden gehouden met API-rate limiting.

De applicatie moet daarom voorkomen dat onnodig veel requests worden uitgevoerd.

Tijdens de implementatie wordt gekeken welke gegevens gecombineerd kunnen worden en welke requests daadwerkelijk noodzakelijk zijn.


## 17. Real-time informatie

Het dashboard moet actuele informatie uit Simplicate tonen.

Daarom wordt in eerste instantie gekeken naar de Simplicate REST API.

De Simplicate Insights API wordt niet als primaire databron gebruikt wanneer actuele gegevens noodzakelijk zijn, omdat de gegevens daar periodiek worden bijgewerkt.



## 18. Versiebeheer

Git wordt gebruikt voor versiebeheer.

De `main` branch bevat een stabiele versie.

Nieuwe functionaliteiten worden ontwikkeld op feature branches.

Voorbeelden:

feature/authentication
feature/dashboard
feature/backend
feature/simplicate-api
feature/testing

Na afronding wordt een Pull Request aangemaakt en wordt de feature gemerged naar `main`.


## 19. Technische afbakening

De applicatie richt zich op een eenvoudige klantgerichte weergave van project- en ureninformatie.

De applicatie is niet bedoeld als vervanging van Simplicate.

Simplicate blijft verantwoordelijk voor:

* projectgegevens;
* urenregistraties;
* interne projectinformatie;
* financiële gegevens.

Het dashboard toont alleen de informatie die voor klanten relevant en toegestaan is.
