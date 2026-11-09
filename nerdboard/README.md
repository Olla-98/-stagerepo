# Nerdboard backend

Rails API for the Nerdboard dashboard. Simplicate credentials stay on this
server; the Vue frontend only receives the project data returned by Rails.

## Local setup

1. Open the Simplicate account where the projects are managed. Create an API
   token in **Settings → General → API**. Keep both the API key and secret
   private.
2. Find the account prefix in your Simplicate URL. For
   `https://nerds.simplicate.com/site/login`, set `SIMPLICATE_SUBDOMAIN=nerds`.
   The website login may use `.simplicate.com`, but the official API endpoint
   uses `.simplicate.nl`: `https://nerds.simplicate.nl/api/v2/...`. Do not put
   `https://`, `.simplicate.com`, or the `/site/login` path in the variable.
   This is the Simplicate account where the API token was created, not
   Nerdboard's website address.
3. Copy `.env.example` to `.env` inside `nerdboard`, then fill in the
   subdomain, API key and secret. `.env` is ignored by Git and must never be
   committed or added to the frontend.

   ```sh
   cp .env.example .env
   ```

4. From the `nerdboard` directory, install dependencies and test the API while
   listing organizations visible to the API token:

   ```sh
   bundle install
   bin/rails simplicate:organizations
   ```

   A successful test prints `Verbinding gelukt` followed by organization IDs
   and names. Copy the ID for the client organization whose projects should
   appear into `SIMPLICATE_ORGANIZATION_ID` in `.env`. It is the ID printed next
   to that organization, not a Nerdboard user ID. If this command only prints
   an error and exits, use the message below to troubleshoot; the command does
   not open a terminal prompt.
5. Prepare the database and start the API:

   ```sh
   bin/rails db:prepare
   bin/rails server
   ```

6. In another terminal, start the frontend from `dashboard-frontend`:

   ```sh
   npm install
   npm run dev
   ```

   Vite proxies local API calls to `http://localhost:3000`. To use another
   backend host, set `VITE_API_BASE_URL` for the frontend; never set the
   Simplicate key or secret as a `VITE_` variable.

The Simplicate subdomain identifies the Simplicate account that owns the API
token and contains the projects. The organization ID identifies a client
organization within that account. The API token inherits the permissions of
the Simplicate user who created it, so that user must have access to the
organizations and projects. If each customer instead owns a separate
Simplicate account, this single-account setup is not sufficient; each tenant
would need its own credentials and account mapping.

Set `FRONTEND_ORIGINS` to a comma-separated list of allowed frontend origins
when the frontend is hosted on another origin. It defaults to
`http://localhost:5173`.

The API reads projects from Simplicate and filters them by the configured
organization ID. Project budget and spent hours come from the project's
`budget.hours.amount` fields. The detailed phase breakdown is not available
from the project-list endpoint and is therefore not fabricated.

Run backend tests with `bin/rails test`.

## Test the complete connection

1. In Terminal 1:

   ```sh
   cd nerdboard
   cp .env.example .env
   ```

   Open `nerdboard/.env` and set your account prefix, API key and API secret.
   Keep the real values only in `.env`.
2. In Terminal 1, from `nerdboard`, run:

   ```sh
   bin/rails simplicate:organizations
   ```

   This is the first connection test. It should print the API URL, `Verbinding
   gelukt`, then organization IDs and names. Set the desired ID in `.env`.
3. Still in Terminal 1:

   ```sh
   bin/rails db:prepare
   bin/rails server
   ```

4. In Terminal 2, from the repository root:

   ```sh
   cd dashboard-frontend
   npm run dev
   ```

   Open the Vite URL shown in Terminal 2. Register a dashboard account or log
   in. The dashboard should show projects from the configured organization.
5. To verify the protected project API directly, log in through the app and
   inspect the browser's **Developer Tools → Network → `projects`** request.
   It should return HTTP `200` and a JSON array. Do not copy or share the
   `Authorization` header or any API credentials.

Troubleshooting the organization command:

- `HTTP-status 401`: the key/secret pair is wrong, inactive, or has extra
  whitespace. Verify them in `.env` and restart the Rails command.
- `HTTP-status 403`: the Simplicate user who created the token may lack API
  access to organizations; check that user's Simplicate permissions.
- `HTTP-status 404` or a connection/host error: check that
  `SIMPLICATE_SUBDOMAIN=nerds` contains only the account prefix. The API host
  must be `nerds.simplicate.nl`, even if the browser login URL ends in
  `.simplicate.com`.
- No organizations: check that the token's user can view the client
  organizations in Simplicate.
- Dashboard `401`: the Nerdboard login token is missing/expired; log in again.
- Dashboard `502`/`503`: read the Rails server output in Terminal 1. `503`
  usually means a missing Simplicate setting; `502` means the Simplicate API
  request failed.
