# Wekelijkse Simplicate-urenreminder

`hours_reminder` is een zelfstandige Ruby-applicatie die controleert of
medewerkers hun uren voor de vorige kalenderweek in Simplicate hebben
ingediend. Medewerkers bij wie een indiening ontbreekt, kunnen per e-mail een
herinnering ontvangen. De controle kan handmatig worden uitgevoerd of volgens
een vast schema worden ingepland.

## Wat de officiële documentatie bevestigt

- Simplicate-urenregistratie wordt gekoppeld aan project, dienst en urensoort:
  [Uren registreren in Simplicate](https://support.simplicate.nl/nl/articles/5109205-uren-registreren-in-simplicate).
- Medewerkers kunnen een urenweek indienen met de knop **Week X indienen**.
  Een week waarin na indiening nieuwe uren zijn geschreven, moet opnieuw worden
  ingediend:
  [Het controleren van uren](https://support.simplicate.nl/nl/articles/5800076-het-controleren-van-uren).
  Zet hiervoor in Simplicate bij **Instellingen → Uren → Controleren** de optie
  **Indienen uren door medewerker** aan. Deze app dient nooit zelf uren in;
  hij leest alleen de status en mailt medewerkers.
- De API v2 documenteert `GET /hours/submission` als het ophalen van de
  indienstatus voor een medewerker op een datum:
  [Simplicate API: hours submission status](https://developer.simplicate.com/docs/api/v2/reference/get-hours-submission).
- Medewerkers zijn op te halen via `GET /hrm/employee`:
  [Simplicate API: employees](https://developer.simplicate.com/docs/api/v2/reference/get-hrm-employee).
- API-toegang loopt uitsluitend via HTTPS en de headers
  `Authentication-Key` en `Authentication-Secret`. API-tokens worden beheerd
  onder **Algemene instellingen → API** in Simplicate en erven de rechten van
  de gebruiker die ze aanmaakt:
  [Simplicate API: getting started](https://developer.simplicate.com/docs/api/v2/getting_started).
  De API is rate-limited; deze app wacht minimaal 1,05 seconde tussen requests.

De urenstatus wordt opgehaald met `q[start_date]`, `q[end_date]` en
`q[employee_id]`. Simplicate retourneert statussen per datum, waaronder
`submitted`, `yet_to_turn_in`, `no_hours` en `no_registrations`. De week geldt
als ingediend wanneer alle dagen `submitted` of geen uren geregistreerd
hebben. Ontbrekende e-mailadressen worden overgeslagen en als waarschuwing
gemeld. Bij ontbrekende of onbekende statusgegevens stopt de controle; er
worden dan geen herinneringen verstuurd op basis van onduidelijke gegevens.

## Lokaal instellen en veilig testen

Vereisten: Ruby 4.0.7 en Bundler.

```sh
bundle install
cp .env.example .env
```

Vul in `.env` de Simplicate-subdomeinnaam en API-key/secret in. De API-account
heeft de benodigde leesrechten nodig. Het lokale `.env`-bestand bevat
toegangsgegevens en wordt niet opgenomen in versiebeheer.
De dry-run gebruikt alle medewerkers die Simplicate teruggeeft. Controleer de
getoonde e-mailadressen. Voor echte verzending is `REMINDER_EMPLOYEE_IDS`
verplicht: vul daar een komma-gescheiden lijst in met de goedgekeurde
Simplicate-medewerker-ID's. Zo worden geen e-mails gestuurd voordat de
ontvangers gecontroleerd zijn.

Voer een controle uit voor de vorige week. `SEND_REMINDERS=false` (de
standaard) betekent dat e-mails alleen worden getoond als dry-run:

```sh
bundle exec ruby bin/send_weekly_reminders
```

Je kunt een specifieke week controleren door de maandagdatum op te geven:

```sh
bundle exec ruby bin/send_weekly_reminders --week-start 2026-11-02
```

Zet pas na controle van API-resultaten en e-mailadressen `SEND_REMINDERS=true`
en vul de SMTP-instellingen in. De database voorkomt dat dezelfde medewerker
voor dezelfde week bij een volgende uitvoering opnieuw een e-mail krijgt.

## Wekelijks automatisch uitvoeren

Plan het commando op de server of in de taakplanner van de hostingomgeving op
de eerste werkdag ná de interne deadline. Bijvoorbeeld: als de deadline
maandagochtend is, plan het dan maandag om 10:00 uur in de tijdzone
`Europe/Amsterdam`. De daadwerkelijke deadline en het tijdstip zijn
bedrijfsafspraken; deze repository kan die niet voor jullie bepalen.

De scheduler moet `bundle exec ruby /pad/naar/hours_reminder/bin/send_weekly_reminders`
uitvoeren vanuit deze map, met dezelfde `.env`/secret-variabelen en een
persistent beschrijfbare `DATABASE_PATH`.

## Tests

```sh
bundle exec ruby -Itest test/weekly_hours_reminder_test.rb
```
