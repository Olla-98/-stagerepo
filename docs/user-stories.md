# User stories

## 1. Inleiding

De user stories beschrijven de belangrijkste functionaliteiten vanuit het perspectief van de gebruiker.

De primaire gebruiker van het systeem is de klant.

De user stories worden gebruikt als basis voor de ontwikkeling en het testen van het klantdashboard.


## 2. Registratie

### US-01 – Account registreren

**Als nieuwe klantgebruiker**
wil ik een account kunnen registreren
**zodat** ik toegang kan krijgen tot het klantdashboard.

**Acceptatiecriteria:**

* De gebruiker kan zijn naam invoeren.
* De gebruiker kan een e-mailadres invoeren.
* De gebruiker kan een wachtwoord invoeren.
* Het systeem controleert of het e-mailadres geldig is.
* Het wachtwoord wordt veilig opgeslagen.
* Een bestaand e-mailadres kan niet opnieuw worden geregistreerd.
* Het account wordt gekoppeld aan de juiste klant/organisatie.


## 3. Authenticatie

### US-02 – Inloggen

**Als klant**
wil ik kunnen inloggen met mijn e-mailadres en wachtwoord
**zodat** ik toegang krijg tot mijn dashboard.

**Acceptatiecriteria:**

* De gebruiker kan een e-mailadres invoeren.
* De gebruiker kan een wachtwoord invoeren.
* Bij correcte gegevens wordt de gebruiker ingelogd.
* Bij incorrecte gegevens wordt een foutmelding weergegeven.
* Een niet-ingelogde gebruiker heeft geen toegang tot het dashboard.



### US-03 – Uitloggen

**Als klant**
wil ik kunnen uitloggen
**zodat** mijn account beveiligd blijft wanneer ik klaar ben.

**Acceptatiecriteria:**

* De gebruiker kan vanuit het dashboard uitloggen.
* Na het uitloggen is het dashboard niet meer toegankelijk.
* De gebruiker wordt teruggestuurd naar de loginpagina.


## 4. Dashboard

### US-04 – Projectoverzicht bekijken

**Als klant**
wil ik mijn projecten kunnen bekijken
**zodat** ik overzicht heb over mijn lopende projecten.

**Acceptatiecriteria:**

* De gebruiker ziet een overzicht van zijn projecten.
* Alleen projecten van de eigen klant worden weergegeven.
* Per project wordt minimaal de projectnaam weergegeven.


### US-05 – Urenstatus bekijken

**Als klant**
wil ik per project mijn urenstatus kunnen bekijken
**zodat** ik kan zien hoeveel uren er zijn gebruikt en hoeveel uren er nog beschikbaar zijn.

**Acceptatiecriteria:**

* Het urenbudget wordt weergegeven.
* Het aantal geregistreerde uren wordt weergegeven.
* Het aantal resterende uren wordt weergegeven.
* De gegevens worden vanuit Simplicate opgehaald.


### US-06 – Projectvoortgang bekijken

**Als klant**
wil ik de voortgang van mijn project kunnen bekijken
**zodat** ik snel kan zien hoe ver het project is.

**Acceptatiecriteria:**

* De voortgang wordt als percentage of visuele indicator weergegeven.
* De berekening is gebaseerd op de beschikbare project- en ureninformatie.
* De weergegeven informatie is actueel.


## 5. Projectdetails

### US-07 – Projectdetails bekijken

**Als klant**
wil ik een project kunnen openen
**zodat** ik meer informatie over de urenstatus van dat project kan bekijken.

**Acceptatiecriteria:**

* De gebruiker kan een project selecteren.
* De gebruiker krijgt de details van het geselecteerde project te zien.
* De gebruiker ziet alleen informatie waarvoor hij geautoriseerd is.


## 6. Beveiliging en autorisatie

### US-08 – Alleen eigen projecten bekijken

**Als klant**
wil ik alleen mijn eigen projecten kunnen bekijken
**zodat** andere klanten geen toegang hebben tot mijn projectinformatie.

**Acceptatiecriteria:**

* De gebruiker is gekoppeld aan een klant/organisatie.
* De backend controleert de autorisatie.
* Projecten van andere klanten worden niet teruggegeven.
* Het aanpassen van een project-ID geeft geen toegang tot een project van een andere klant.


### US-09 – Geen interne informatie tonen

**Als klant**
wil ik alleen relevante projectinformatie zien
**zodat** interne bedrijfsinformatie niet zichtbaar is.

**Acceptatiecriteria:**

* Interne financiële informatie wordt niet weergegeven.
* Kosten worden niet weergegeven.
* MRR wordt niet weergegeven.
* Facturatiegegevens worden niet weergegeven.
* Interne correcties worden niet onnodig weergegeven.


## 7. Gegevens uit Simplicate

### US-10 – Actuele projectinformatie ophalen

**Als klant**
wil ik actuele projectinformatie zien
**zodat** mijn dashboard aansluit bij de actuele informatie in Simplicate.

**Acceptatiecriteria:**

* Projectinformatie wordt vanuit Simplicate opgehaald.
* Ureninformatie wordt vanuit Simplicate opgehaald.
* De backend verwerkt de benodigde gegevens voordat deze naar de frontend worden gestuurd.


## 8. Foutafhandeling

### US-11 – Foutmelding bij problemen

**Als klant**
wil ik een duidelijke melding krijgen wanneer gegevens niet geladen kunnen worden
**zodat** ik begrijp dat er een probleem is.

**Acceptatiecriteria:**

* Bij een API-fout wordt een duidelijke melding weergegeven.
* Technische details worden niet aan de klant getoond.
* De applicatie blijft bruikbaar wanneer een request mislukt.


## 9. Responsive gebruik

### US-12 – Dashboard gebruiken op verschillende schermformaten

**Als klant**
wil ik het dashboard op verschillende schermformaten kunnen gebruiken
**zodat** de applicatie gebruiksvriendelijk blijft.

**Acceptatiecriteria:**

* Het dashboard werkt op desktop.
* Het dashboard werkt op kleinere schermformaten.
* Belangrijke informatie blijft leesbaar.
