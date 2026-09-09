# Functioneel ontwerp

## 1. Inleiding

Dit document beschrijft de functionaliteiten van het klantdashboard.

Het dashboard is bedoeld voor klanten van de organisatie. Klanten kunnen via het dashboard hun eigen projecten en de bijbehorende urenstatus bekijken.

De applicatie is gekoppeld aan Simplicate. Simplicate blijft de bron van de project-en ureninformatie.

Het dashboard is read-only. Klanten kunnen geen gegevens aanpassen of verwijderen.


## 2. Doelgroep

De primaire gebruiker van het systeem is de klant.

De klant gebruikt het dashboard om inzicht te krijgen in:

* eigen projecten;
* beschikbare uren;
* geregistreerde uren;
* resterende uren;
* projectvoortgang.

De gebruiker krijgt geen eigen toegang tot de Simplicate-omgeving.

Interne medewerkers kunnen de applicatie gebruiken voor ontwikkeling, testen en demonstratie.


## 3. Registreren

Een nieuwe gebruiker moet een account kunnen registreren.

Tijdens registratie worden minimaal de benodigde accountgegevens ingevoerd, zoals:

naam;
e-mailadres;
wachtwoord.

Het account moet vervolgens gekoppeld worden aan de juiste klant/organisatie in Simplicate.

De exacte manier waarop deze koppeling tijdens registratie wordt uitgevoerd, wordt tijdens de technische uitwerking bepaald.

Een gebruiker mag niet zelf een willekeurige klant/organisatie kunnen selecteren om toegang te krijgen tot gegevens.


## 4. Inloggen

De gebruiker kan met het geregistreerde account inloggen.

Functionaliteiten

De gebruiker kan:

een e-mailadres invoeren;
een wachtwoord invoeren;
inloggen;
na succesvol inloggen het dashboard openen.

Wanneer de gegevens incorrect zijn, wordt een duidelijke foutmelding weergegeven.


## 5. Uitloggen

De gebruiker kan vanuit het dashboard uitloggen.

Na het uitloggen:

is het dashboard niet meer toegankelijk;
wordt de gebruiker teruggestuurd naar de loginpagina;
wordt de actieve authenticatie beëindigd.


## 6. Authenticatie

De gebruiker moet inloggen voordat het dashboard toegankelijk is.

### Functionaliteiten

De gebruiker kan:

* inloggen met een e-mailadres en wachtwoord;
* uitloggen;
* alleen na succesvolle authenticatie het dashboard bekijken.

Wanneer een gebruiker niet ingelogd is, krijgt deze geen toegang tot het dashboard.


## 7. Autorisatie

Een gebruiker mag uitsluitend informatie bekijken die bij de gekoppelde klant/organisatie hoort.

De autorisatie wordt gebaseerd op de koppeling tussen:

Dashboard gebruiker
        ↓
Simplicate organisatie/klant
        ↓
Projecten van deze organisatie

Een gebruiker mag geen projecten van andere organisaties bekijken.


## 8. Dashboard

Na het inloggen komt de gebruiker op het dashboard.

Het dashboard toont een overzicht van de projecten waarvoor de gebruiker toegang heeft.

Per project worden minimaal de volgende gegevens weergegeven:

* projectnaam;
* urenbudget;
* geregistreerde uren;
* resterende uren;
* voortgang.

Het dashboard moet overzichtelijk zijn en geschikt zijn voor desktop en kleinere schermformaten.


## 9. Projectoverzicht

De gebruiker kan een lijst met projecten bekijken.

Per project wordt de belangrijkste ureninformatie direct weergegeven.

Voorbeeld:

| Project              |  Budget | Geregistreerd | Resterend | Voortgang |

| Website ontwikkeling | 100 uur |        65 uur |    35 uur |       65% |
| Webshop              | 200 uur |       120 uur |    80 uur |       60% |

De exacte gegevens worden vanuit Simplicate opgehaald.


## 10. Projectdetails

De gebruiker kan een project selecteren om meer informatie te bekijken.

De projectdetailpagina toont minimaal:

* projectnaam;
* projectinformatie;
* urenbudget;
* geregistreerde uren;
* resterende uren;
* voortgang.

De projectdetails bevatten alleen informatie die bedoeld is voor de klant.

Interne informatie uit Simplicate, zoals kosten, MRR, facturatie en andere interne financiële gegevens, wordt niet aan de klant getoond.


## 11. Urenstatus

De urenstatus vormt een belangrijk onderdeel van het dashboard.

De applicatie toont:


### Urenbudget

Het aantal uren dat beschikbaar/begroot is voor het project.

### Geregistreerde uren

Het aantal uren dat tot dat moment op het project is geregistreerd.

### Resterende uren

Het aantal uren dat overblijft.


De basisberekening is:

project1
Resterende uren = Urenbudget - Geregistreerde uren


### Voortgang

De voortgang kan worden weergegeven als percentage:

project2
Voortgang = Geregistreerde uren / Urenbudget × 100


De exacte definitie van projectvoortgang wordt tijdens de implementatie afgestemd met de beschikbare gegevens in Simplicate.


## 12. Simplicate

De applicatie haalt de benodigde gegevens op uit Simplicate.

De belangrijkste gegevens zijn:

* klant/organisatie;
* projecten;
* urenregistraties;
* urenbudget/planning.

De applicatie gebruikt deze gegevens om de klantgerichte weergave samen te stellen.

De klant krijgt geen directe toegang tot de Simplicate-omgeving.


## 13. Read-only

Het dashboard is uitsluitend bedoeld voor het bekijken van informatie.

De gebruiker kan:

* gegevens bekijken;
* projecten selecteren;
* uitloggen.

De gebruiker kan niet:

* projecten wijzigen;
* uren wijzigen;
* uren verwijderen;
* projecten verwijderen;
* gegevens aanpassen in Simplicate.


## 14. Foutmeldingen

Wanneer gegevens niet kunnen worden opgehaald, moet de gebruiker een duidelijke melding krijgen.

Voorbeelden:

* "Inloggen mislukt. Controleer je gegevens."
* "De projectgegevens kunnen momenteel niet worden opgehaald."
* "Er is momenteel geen projectinformatie beschikbaar."

Technische foutinformatie mag niet rechtstreeks aan de klant worden getoond.


## 15. Beveiliging

De applicatie moet voorkomen dat gebruikers toegang krijgen tot gegevens waarvoor zij geen rechten hebben.

Belangrijke uitgangspunten:

* authenticatie is verplicht;
* autorisatie wordt server-side gecontroleerd;
* Simplicate API-credentials zijn niet zichtbaar in de frontend;
* gevoelige gegevens worden niet in de broncode opgeslagen;
* gebruikers kunnen alleen hun eigen projectinformatie bekijken.


## 16. Scope

### Functioneel binnen de scope

* Inloggen;
* uitloggen;
* dashboard;
* projecten bekijken;
* projectdetails bekijken;
* urenbudget bekijken;
* geregistreerde uren bekijken;
* resterende uren bekijken;
* projectvoortgang bekijken;
* autorisatie.

### Functioneel buiten de scope

* gegevens wijzigen;
* gegevens verwijderen;
* facturatie;
* betalingen;
* projectplanning;
* uitgebreide rapportages;
* mobiele app;
* uitgebreid gebruikersbeheer.
