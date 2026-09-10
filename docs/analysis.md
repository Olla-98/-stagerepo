analysis.md

# Projectanalyse

## 1. Aanleiding

Binnen de organisatie is behoefte aan een eenvoudige en overzichtelijke manier om klanten inzicht te geven in de urenstatus van hun projecten.

De benodigde project- en ureninformatie is beschikbaar binnen Simplicate. Door deze informatie via een klantdashboard beschikbaar te maken.

## 2. Probleemstelling

Klanten hebben momenteel geen eenvoudige manier om zelf inzicht te krijgen in de actuele urenstatus van hun projecten.

Het is daardoor lastiger om snel te bepalen:

* hoeveel uren zijn begroot;
* hoeveel uren zijn geregistreerd;
* hoeveel uren nog beschikbaar zijn;
* hoe ver een project gevorderd is.

## 3. Doelstelling

Het doel van dit project is het ontwikkelen van een klantdashboard dat project- en ureninformatie vanuit Simplicate beschikbaar maakt voor geautoriseerde gebruikers.

Het dashboard moet de belangrijkste informatie overzichtelijk presenteren en gebruikers in staat stellen om snel de actuele urenstatus van hun projecten te bekijken.

## 4. Gebruikers

De primaire gebruiker van het systeem is de klant.

Een klant moet na het inloggen alleen toegang krijgen tot de projecten en informatie waarvoor deze gebruiker geautoriseerd is.

Daarnaast kan het systeem intern worden gebruikt voor ontwikkeling, testen en demonstratie.

## 5. Functionele eisen

### Authenticatie

* De gebruiker kan inloggen.
* Alleen geauthenticeerde gebruikers krijgen toegang tot het dashboard.
* De gebruiker kan uitloggen.
* Een gebruiker mag alleen geautoriseerde projectinformatie bekijken.

### Dashboard

* De gebruiker kan zijn of haar projecten bekijken.
* Per project wordt het urenbudget weergegeven.
* Per project worden de geregistreerde uren weergegeven.
* Per project worden de resterende uren weergegeven.


### Projectdetails

* De gebruiker kan een project selecteren.
* De gebruiker kan de urenstatus van een specifiek project bekijken.

### Simplicate

* Het systeem kan projectinformatie vanuit Simplicate ophalen.
* Het systeem kan ureninformatie vanuit Simplicate ophalen.
* De opgehaalde informatie wordt verwerkt voordat deze aan de gebruiker wordt getoond.

## 6. Niet-functionele eisen

* De applicatie moet gebruiksvriendelijk zijn.
* De applicatie moet responsive zijn.
* Gevoelige gegevens en API-credentials mogen niet in de broncode worden opgeslagen.
* Gebruikers mogen geen gegevens zien waarvoor zij niet geautoriseerd zijn.
* De code moet overzichtelijk en onderhoudbaar zijn.
* De oplossing moet later uitbreidbaar zijn.

## 7. Afbakening

### Binnen de scope

* Authenticatie
* Klantdashboard
* Projectoverzicht
* Projectdetails
* Urenbudget
* Geregistreerde uren
* Resterende uren
* Koppeling met Simplicate

### Buiten de scope

* Mobiele applicatie
* Facturatie
* Projectplanning
* Bewerken van gegevens in Simplicate
* Uitgebreid gebruikersbeheer
* Geavanceerde rapportages
* Complexe AI-functionaliteiten

Deze onderdelen kunnen alleen worden toegevoegd wanneer hier tijdens het project voldoende tijd en toegevoegde waarde voor is.

## 8. Technische onderzoeksvragen

Tijdens het project worden de volgende vragen onderzocht:

1. Welke gegevens zijn beschikbaar via de Simplicate API?
2. Welke gegevens zijn noodzakelijk voor het dashboard?
3. Is de Simplicate API voldoende voor de gewenste functionaliteiten?
4. Heeft MCP een toegevoegde waarde ten opzichte van een reguliere API-koppeling?
5. Welke frontendtechnologie is geschikt voor het dashboard?
6. Welke backendtechnologie is geschikt voor de koppeling met Simplicate?
7. Hoe kan authenticatie eenvoudig en veilig worden geïmplementeerd?
8. Hoe wordt voorkomen dat een klant gegevens van andere klanten kan bekijken?

## 9. Voorlopige technische richting

Op basis van de eerste analyse wordt voorlopig gekeken naar:

* Frontend: Vue / Javascript
* Backend: Ruby
* Data-integratie: Simplicate API
* Authenticatie: nader te bepalen

De definitieve technische keuzes worden gemaakt nadat de benodigde Simplicate-functionaliteiten en API-mogelijkheden zijn onderzocht.
