# Gebruikersverhalen en functioneel ontwerp: urenherinnering

## 1. Doel en afbakening

`hours_reminder` is een zelfstandige Ruby-applicatie voor het automatisch
controleren van urenindieningen in Simplicate en het versturen van een
herinneringsmail aan medewerkers bij wie de indiening ontbreekt. De applicatie
kan handmatig worden gestart of volgens een vast schema worden uitgevoerd.

De applicatie automatiseert de controle en herinnering; de medewerker blijft
verantwoordelijk voor het registreren en indienen van de uren in Simplicate. De
applicatie wijzigt geen gegevens en dient zelf geen uren in. De code staat in de
afzonderlijke map `hours_reminder/` en kan onafhankelijk van andere onderdelen
van de repository worden geïnstalleerd en uitgevoerd.

De beoogde meerwaarde is een herhaalbare controle op een afgesproken moment,
een overzicht van ontbrekende indieningen en een gerichte herinnering zonder
dat iemand iedere medewerker handmatig hoeft na te lopen. Een beheerder kan
dezelfde controle ook handmatig starten. De toepassing van eventuele
ingebouwde Simplicate-meldingen valt buiten de werking van deze app.

**Implementatie- en validatiestatus (9 november 2026):** geautomatiseerde
tests met testgegevens zijn geslaagd. De live API-integratie is nog niet
bevestigd: `GET /api/v2/hrm/employee` gaf HTTP 401. API-toegang, benodigde
rechten en het antwoordformaat voor de urenstatus moeten daarom nog in de
Simplicate-omgeving worden gevalideerd. Tot die validatie is afgerond, is de
integratie niet gereed voor productiegebruik.

## 2. Betrokkenen en verantwoordelijkheden

- **Medewerker:** registreert en dient uren in Simplicate in en ontvangt een
  herinneringsmail wanneer de indiening volgens Simplicate ontbreekt.
- **Functioneel eigenaar:** bepaalt vooraf voor welke medewerkers en urenweek
  de controle geldt en op welk moment na de indieningsdeadline de controle
  plaatsvindt. Dit zijn bedrijfsafspraken; de eigenaar hoeft de controle niet
  wekelijks handmatig uit te voeren.
- **Technisch beheerder:** configureert API- en e-mailtoegang, de lijst met
  toegestane medewerker-ID's, opslag en eventuele scheduler. De beheerder
  controleert de werking en volgt fouten op.
- **Applicatie:** haalt medewerkers en indienstatussen op, toont in
  testmodus wie een herinnering zou ontvangen en verstuurt in geconfigureerde
  verzendmodus herinneringen per e-mail.

## 3. Gebruikersverhalen en acceptatiecriteria

### US-1 — Indieningen automatisch controleren

**Als functioneel eigenaar** wil ik dat de applicatie de afgesproken urenweek
voor de ingestelde doelgroep controleert, zodat ontbrekende indieningen tijdig
worden gesignaleerd zonder iedere medewerker handmatig te controleren.

Acceptatiecriteria:

- Standaard controleert de applicatie de vorige kalenderweek, van maandag tot
  en met zondag.
- De week kan voor een handmatige controle of test worden opgegeven met
  `--week-start` en een maandagdatum.
- Een medewerker met ingediende uren wordt niet als ontvanger geselecteerd.
- Een medewerker zonder ingediende uren verschijnt in de testuitvoer en komt
  in verzendmodus in aanmerking voor een herinneringsmail.
- De controle wordt pas na de afgesproken indieningsdeadline gepland of gestart.
- API-fouten, ongeldige JSON en onbekende statuswaarden leiden tot een fout; de
  applicatie verstuurt dan geen herinneringen op basis van onzekere gegevens.

### US-2 — Herinneringsmails versturen

**Als medewerker** wil ik een duidelijke herinnering ontvangen wanneer mijn
urenweek niet is ingediend, zodat ik mijn registratie kan controleren en mijn
uren alsnog kan indienen.

Acceptatiecriteria:

- E-mailverzending staat standaard uit en wordt alleen geactiveerd met
  `SEND_REMINDERS=true`.
- Verzendmodus vereist een expliciete lijst Simplicate-medewerker-ID's in
  `REMINDER_EMPLOYEE_IDS`. ID's die niet in de opgehaalde medewerkerslijst
  voorkomen, veroorzaken een configuratiefout.
- De mail noemt de medewerker en de weekperiode en vraagt de medewerker de
  urenregistratie te controleren en de urenweek in Simplicate in te dienen.
- De ontvanger is het e-mailadres dat voor de medewerker in Simplicate is
  geregistreerd.
- SMTP-verzendfouten worden als fout afgehandeld en niet als succesvolle
  verzending geregistreerd.
- De applicatie dient geen uren in en verandert geen Simplicate-gegevens.

### US-3 — Eerst controleren zonder te verzenden

**Als technisch beheerder** wil ik de selectie kunnen controleren voordat
e-mails worden verstuurd, zodat onjuiste ontvangers of een onjuiste
weekselectie tijdig worden opgemerkt.

Acceptatiecriteria:

- `SEND_REMINDERS=false` is de standaardinstelling en verstuurt geen e-mail.
- De uitvoer vermeldt de gecontroleerde week, het aantal ontbrekende
  indieningen en per geselecteerde medewerker de naam en het e-mailadres.
- Een controle zonder verzending maakt geen verzendregistratie aan en vereist
  geen verbinding met de SMTP-server.

### US-4 — Dubbele herinneringen voorkomen

**Als medewerker** wil ik niet meer dan één herinnering voor dezelfde week
ontvangen, zodat een herhaalde taakuitvoering geen dubbele e-mail veroorzaakt.

Acceptatiecriteria:

- De applicatie registreert succesvolle verzendingen per medewerker-ID en
  weekperiode in SQLite.
- Een reeds succesvol verzonden herinnering voor dezelfde medewerker en week
  wordt niet opnieuw verstuurd.
- De database staat op een persistente, beschrijfbare locatie.

### US-5 — De controle handmatig of volgens schema uitvoeren

**Als technisch beheerder** wil ik de controle handmatig kunnen starten of
automatisch laten uitvoeren, zodat de uitvoering past bij de werkwijze van de
organisatie.

Acceptatiecriteria:

- De applicatie kan als command-line taak worden gestart.
- Een scheduler kan dezelfde taak starten op een afgesproken dag en tijd in de
  tijdzone `Europe/Amsterdam`.
- De taak gebruikt bij iedere uitvoering dezelfde persistente database en
  configuratie.
- De uitvoer, exitstatus en fouten zijn beschikbaar in de logging of monitoring
  van de uitvoeringsomgeving.

## 4. Functioneel ontwerp

### 4.1 Verwerkingsstappen

1. De beheerder configureert de Simplicate-API en, wanneer e-mailverzending is
   ingeschakeld, de SMTP-server.
2. De applicatie bepaalt de te controleren week: standaard de vorige
   kalenderweek, of de maandag die met `--week-start` is opgegeven.
3. De applicatie haalt de medewerkers op met `GET /hrm/employee`.
4. In verzendmodus wordt de medewerkerslijst beperkt tot de ID's in
   `REMINDER_EMPLOYEE_IDS`. Een opgegeven ID dat niet in de lijst voorkomt,
   resulteert in een configuratiefout.
5. De applicatie vraagt voor iedere medewerker de indienstatus op met
   `GET /hours/submission`.
6. Bij een API-fout of een niet-herkende status stopt de uitvoering met een
   foutmelding.
7. Zonder verzendmodus toont de applicatie de medewerkers zonder ingediende
   urenweek, maar verstuurt zij geen e-mail.
8. In verzendmodus voorkomt de SQLite-registratie dubbele verzending. Na een
   succesvolle e-mail wordt de verzending geregistreerd. Bij een
   verzendfout wordt de tijdelijke claim vrijgegeven en eindigt de uitvoering
   met een fout.

### 4.2 Herinneringsbericht

- **Kanaal:** e-mail via de geconfigureerde SMTP-server.
- **Afzender:** de waarde van `REMINDER_FROM`.
- **Ontvanger:** het e-mailadres van de geselecteerde medewerker in Simplicate.
- **Onderwerp:** vermeldt dat het om een urenherinnering gaat en noemt de
  startdatum van de week.
- **Bericht:** spreekt de medewerker aan, noemt de weekperiode en vraagt de
  urenregistratie te controleren en de week in Simplicate in te dienen.
- **Actie:** de medewerker dient de uren zelf in; de applicatie voert die actie
  niet uit.

Voorbeeld:

> **Onderwerp:** Herinnering urenregistratie: week van 02-11-2026
>
> Beste Lin,
>
> Volgens de registratie in Simplicate is je urenweek van 02-11-2026 tot en met
> 08-11-2026 nog niet ingediend. Controleer je urenregistratie en dien de
> urenweek in via Simplicate.
>
> Alvast bedankt.

### 4.3 Configuratie

Voor lokale uitvoering wordt configuratie geladen uit `.env`. In een
uitvoeringsomgeving kan een daarvoor bestemde secret- of
configuratievoorziening worden gebruikt.

- `SIMPLICATE_SUBDOMAIN`, `SIMPLICATE_API_KEY`,
  `SIMPLICATE_API_SECRET`: toegang tot Simplicate.
- `TIMEZONE`: tijdzone voor de uitvoering; standaard `Europe/Amsterdam`.
- `DATABASE_PATH`: locatie van de SQLite-database; standaard
  `var/reminders.sqlite3`.
- `SEND_REMINDERS`: schakelt e-mailverzending in; standaard `false`.
- `REMINDER_EMPLOYEE_IDS`: toegestane medewerker-ID's; verplicht wanneer
  verzending is ingeschakeld.
- `REMINDER_FROM`, `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USERNAME`,
  `SMTP_PASSWORD`, `SMTP_AUTHENTICATION`, `SMTP_STARTTLS`: e-mailconfiguratie.

Lokale `.env`-bestanden, toegangsgegevens en persoonsgegevens maken geen deel
uit van de broncode of versiebeheer.

## 5. Test- en acceptatieplan

### 5.1 Geautomatiseerde tests

Voer vanuit de map `hours_reminder/` de tests uit:

```sh
bundle exec ruby -Itest test/weekly_hours_reminder_test.rb
```

De tests controleren de weekberekening, selectie in testmodus, het voorkomen
van dubbele verzending, de basiswerking van de API-client, afhandeling van
onbekende statusantwoorden en de opbouw van e-mailberichten met een testmailer.
Deze tests bevestigen niet dat de live Simplicate-API of de bedrijfs-SMTP-server
correct is geconfigureerd.

### 5.2 Validatie van de Simplicate-integratie

1. De technisch beheerder configureert een actieve API-key en bijbehorende
   secret met de benodigde leesrechten.
2. De controle wordt uitgevoerd zonder e-mailverzending voor een bekende
   maandagdatum:

   ```sh
   bundle exec ruby bin/send_weekly_reminders --week-start 2026-11-02
   ```

3. De uitvoering levert geen HTTP 401- of 403-fout op en toont de geselecteerde
   week en de medewerkers zonder ingediende uren.
4. Er vindt geen SMTP-verkeer plaats en er wordt geen e-mail verstuurd.
5. Een steekproef van de opgehaalde indienstatussen wordt vergeleken met de
   gegevens in Simplicate. Daarbij worden de queryparameters en de interpretatie
   van de API-respons bevestigd.

Een HTTP 401 duidt op geweigerde authenticatie; een HTTP 403 duidt op
onvoldoende toegangsrechten. In beide gevallen is de integratie niet
gevalideerd.

### 5.3 Validatie van e-mailverzending

Voor een gecontroleerde verzendtest wordt een testmedewerker gebruikt van wie
het e-mailadres onder beheer van het testteam valt. De huidige implementatie
gebruikt het e-mailadres uit Simplicate; `REMINDER_EMPLOYEE_IDS` beperkt de
medewerkersselectie, maar wijzigt de ontvanger niet.

De test omvat:

1. Bevestiging van de testmedewerker, weekperiode en berichtinhoud.
2. Configuratie en controle van de SMTP-verbinding.
3. Een eenmalige verzending naar de goedgekeurde testmedewerker.
4. Controle van ontvangst, afzender, onderwerp en weekperiode.
5. Een tweede uitvoering voor dezelfde medewerker en week, waarbij geen
   tweede herinnering wordt verstuurd.

### 5.4 Ingebruikname

Voor ingebruikname worden de doelgroep, indieningsdeadline en uitvoermoment
door de organisatie vastgesteld. De technisch beheerder configureert de
toegang, e-mailserver, medewerker-ID's, persistente database en scheduler.
De eerste uitvoering vindt plaats in testmodus; verzending wordt pas
ingeschakeld nadat de API-integratie en de geselecteerde ontvangers zijn
gevalideerd.

De uitvoeringsomgeving moet fouten signaleren en de uitvoer en exitstatus
bewaren. Ook worden verantwoordelijkheden voor foutopvolging en afspraken
voor opslag, back-up en bewaartermijnen van de SQLite-database vastgesteld.

## 6. Openstaande punten

- De HTTP 401-fout bij `GET /hrm/employee` oplossen en de API-toegang valideren.
- De queryparameters en respons van `/hours/submission` in de eigen
  Simplicate-omgeving bevestigen.
- De doelgroep, indieningsdeadline en het gewenste uitvoermoment vaststellen.
- De SMTP-server en het afzenderadres configureren en een gecontroleerde
  verzendtest uitvoeren.
- De uitvoeringsomgeving, monitoring, databaseback-up en bewaartermijn bepalen.
- Vaststellen of de ingebouwde meldingsmogelijkheden van Simplicate aanvullend
  of in plaats van deze applicatie worden gebruikt.

## 7. Uitvoeringscommando's

Voer de commando's uit vanuit de map `hours_reminder/`.

Geautomatiseerde tests:

```sh
bundle exec ruby -Itest test/weekly_hours_reminder_test.rb
```

Controle zonder verzending voor een specifieke week:

```sh
bundle exec ruby bin/send_weekly_reminders --week-start 2026-11-02
```

Controle zonder verzending voor de vorige kalenderweek:

```sh
bundle exec ruby bin/send_weekly_reminders
```

Een scheduler voert hetzelfde script uit als bij handmatige uitvoering, met
dezelfde configuratie en persistente database.
