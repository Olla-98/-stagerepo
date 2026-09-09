# Plan van aanpak

## 1. Inleiding

Tijdens deze stage wordt een klantdashboard ontwikkeld waarmee klanten inzicht krijgen in de urenstatus van hun projecten.

De project- en ureninformatie wordt momenteel beheerd binnen Simplicate. Klanten hebben geen directe toegang tot deze interne omgeving. Het doel van dit project is daarom om een aparte, beveiligde omgeving te ontwikkelen waarin klanten alleen de informatie kunnen bekijken die voor hen relevant is.

Het dashboard wordt gekoppeld aan Simplicate zodat project- en ureninformatie vanuit Simplicate kan worden opgehaald.


## 2. Aanleiding

Binnen de organisatie is behoefte aan een eenvoudige manier om klanten inzicht te geven in de actuele status van hun projecten.

De benodigde informatie is al beschikbaar in Simplicate, maar deze omgeving bevat ook interne informatie die niet bedoeld is voor klanten. Daarnaast hebben klanten geen directe toegang tot Simplicate.

Door een apart klantdashboard te ontwikkelen, kan een beperkte en overzichtelijke weergave van de projectinformatie aan klanten worden aangeboden.


## 3. Doelstelling

Het doel van dit project is het ontwikkelen van een beveiligd klantdashboard waarmee klanten inzicht krijgen in hun eigen projecten en de bijbehorende urenstatus.

De klant moet na het inloggen onder andere kunnen zien:

* welke projecten aan de klant gekoppeld zijn;
* hoeveel uren voor een project beschikbaar zijn;
* hoeveel uren geregistreerd zijn;
* hoeveel uren nog beschikbaar zijn;
* wat de voortgang van het project is.

De applicatie wordt read-only. Klanten kunnen gegevens niet wijzigen of verwijderen.



## 4. Resultaat

Het eindresultaat bestaat uit een werkend klantdashboard met:

* registratie van een gebruikersaccount;
* een loginfunctie;
* uitlogen;
* authenticatie en autorisatie;
* koppeling tussen een dashboardgebruiker en een Simplicate-klant/organisatie;
* een overzicht van projecten;
* projectdetails;
* ureninformatie;
* een koppeling met de Simplicate REST API;
* een duidelijke en responsive gebruikersinterface.

De applicatie toont alleen informatie waarvoor de ingelogde gebruiker geautoriseerd is.


## 5. Aanpak

Het project wordt stapsgewijs uitgevoerd.

### Fase 1 – Analyse

Tijdens de analyse wordt onderzocht:

* welke informatie klanten nodig hebben;
* welke gegevens beschikbaar zijn in Simplicate;
* welke gegevens via de Simplicate API kunnen worden opgehaald;
* hoe klanten en projecten aan elkaar gekoppeld kunnen worden;
* hoe een dashboardgebruiker aan een Simplicate-klant/organisatie gekoppeld kan worden;
* welke technische oplossing geschikt is.

De belangrijkste API-mogelijkheden van Simplicate worden hierbij onderzocht.


### Fase 2 – Functioneel ontwerp

In het functioneel ontwerp wordt beschreven wat de applicatie moet kunnen.

Hierbij worden onder andere de volgende onderdelen uitgewerkt:

* registratie;
* gebruikers en rollen;
* login;
* dashboard;
* projecten;
* projectdetails;
* urenstatus;
* autorisatie;
* foutmeldingen
* scope van de applicatie.


### Fase 3 – Technisch ontwerp

In het technisch ontwerp wordt bepaald hoe de applicatie technisch wordt opgebouwd.

De voorlopige technische richting bestaat uit:

* React;
* TypeScript;
* Node.js;
* Express;
* Simplicate REST API;
* een eigen database voor gebruikersgegevens en de koppeling met een Simplicate-organisatie, indien nodig.

De definitieve technische keuzes worden tijdens de implementatie gevalideerd. Simplicate blijft de bron van waarheid voor project- en ureninformatie.


### Fase 4 – Ontwikkeling

Na het ontwerp wordt de applicatie ontwikkeld.

De ontwikkeling wordt opgesplitst in afzonderlijke onderdelen:

1. projectstructuur;
2. gebruikersregistratie;
3. authenticatie;
4. backend;
5. koppeling met Simplicate;
6. autorisatie;
7. dashboard;
8. projectdetails;
9. foutafhandeling.

De onderdelen worden stapsgewijs ontwikkeld en getest.


### Fase 5 – Testen

Tijdens en na de ontwikkeling wordt de applicatie getest.

Er wordt onder andere getest of:

* gebruikeers kunnen registreren;
* gebruikers kunnen inloggen;
* gebruikers kunnen uitloggen;
* gebruikers alleen hun eigen projecten kunnen bekijken;
* projectgegevens correct worden weergegeven;
* uren correct worden opgehaald;
* resterende uren correct worden berekend;
* ongeautoriseerde gegevens niet toegankelijk zijn;
* de applicatie correct werkt op verschillende schermformaten.


### Fase 6 – Oplevering

Na het testen wordt de applicatie klaargemaakt voor oplevering.

De oplevering bestaat uit:

* de werkende applicatie;
* de broncode;
* de documentatie;
* testresultaten;
* een overzicht van de gemaakte technische keuzes.


## 6. Planning

De exacte planning wordt afgestemd op de beschikbare stageperiode.

De werkzaamheden worden globaal als volgt verdeeld:

| Fase                | Werkzaamheden                                     |


| Analyse             | Eisen, API-onderzoek en technische mogelijkheden  |

| Functioneel ontwerp | Functionaliteiten en gebruikersinteractie         |

| Technisch ontwerp   | Architectuur, technologie en beveiliging          |

| Ontwikkeling        | Frontend, backend, authenticatie en API-koppeling |

| Testen              | Functionele, technische en autorisatietests       |

| Oplevering          | Documentatie, afronding en presentatie            |

Tijdens het project kan de planning worden aangepast wanneer technische of functionele inzichten hier aanleiding toe geven.


## 7. Risico's

Tijdens het project zijn verschillende risico's aanwezig.

### API-mogelijkheden

Niet alle gewenste informatie hoeft direct beschikbaar te zijn via de Simplicate REST API.

**Maatregel:**

De benodigde API-endpoints worden tijdens de analyse en ontwikkeling getest voordat de definitieve implementatie wordt gemaakt.

### Autorisatie

Een belangrijk risico is dat een klant toegang krijgt tot gegevens van een andere klant.

**Maatregel:**

De backend controleert bij het ophalen van projectinformatie altijd welke klant bij de ingelogde gebruiker hoort.

### API-credentials

De API-sleutels van Simplicate mogen niet openbaar worden gemaakt.

**Maatregel:**

API-credentials worden opgeslagen in environment variables en niet rechtstreeks in de broncode geplaatst.

### Technische complexiteit

Tijdens de ontwikkeling kunnen nieuwe technische problemen ontstaan.

**Maatregel:**
De applicatie wordt stap voor stap ontwikkeld en getest. Functionaliteiten worden niet onnodig uitgebreid.


## 8. Afbakening

### Binnen de scope

* gebruikerregistratie;
* Authenticatie;
* login;
* uitlogin; 
* klantdashboard;
* projectoverzicht;
* projectdetails;
* urenbudget;
* geregistreerde uren;
* resterende uren;
* projectvoortgang;
* Simplicate API-koppeling;
* autorisatie.

### Buiten de scope

* mobiele applicatie;
* facturatie;
* projectplanning;
* wijzigen van Simplicate-gegevens;
* verwijderen van gegevens;
* uitgebreid gebruikersbeheer;
* geavanceerde rapportages;
* complexe AI-functionaliteiten.


## 9. Git en versiebeheer

Voor het project wordt Git gebruikt voor versiebeheer en GitHub voor het beheren van de broncode.

De ontwikkeling wordt uitgevoerd met feature branches. Hierdoor kunnen onderdelen afzonderlijk worden ontwikkeld en vervolgens via een Pull Request worden samengevoegd met de `main` branch.

Voorbeelden van branches zijn:

* `feature/authentication`
* `feature/dashboard`
* `feature/backend`
* `feature/simplicate-api`
* `feature/testing`

De `main` branch bevat steeds een stabiele versie van het project.


## 10. Eindresultaat

Aan het einde van het project is er een werkend klantdashboard waarmee geautoriseerde klanten op een eenvoudige manier inzicht krijgen in de urenstatus van hun eigen projecten.

De applicatie vormt hiermee een beperkte en klantgerichte weergave van relevante informatie uit Simplicate.
