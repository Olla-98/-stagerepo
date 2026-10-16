<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  openDemo: [email: string, name?: string]
}>()

const mode = ref<'login' | 'register'>('login')
const name = ref('')
const email = ref('')
const password = ref('')
const message = ref('')

function submitForm() {
  if (!email.value || !password.value) {
    message.value = 'Vul je e-mailadres en wachtwoord in.'
    return
  }

  if (mode.value === 'register' && !name.value.trim()) { //
    message.value = 'Vul je naam in.'
    return
  }

  emit('openDemo', email.value, mode.value === 'register' ? name.value : undefined)
}
</script>

<template>
  <div class="auth-page">
    <aside class="auth-intro">
      <div class="brand brand--large">
        <span class="brand-mark" aria-hidden="true">Logo</span>
        <span>Nerdboard</span>
      </div>

      <div class="auth-intro__copy">
        <p class="eyebrow">Jouw projecten, zijn altijd zichtbaar in Nerdboard</p>
        <h1>Ola heeft dit project aangemaakt</h1>
        <p>Bekijk op één plek hoe je projecten ervoor staan en hoeveel uren er nog beschikbaar zijn, zonder moeite.</p>
        <ul class="auth-benefits">
          <li>Projectinformatie overzichtelijk bij elkaar. Makkelijk en snel toegankelijk.</li>
          <li>Inzicht in budget, geschreven en resterende uren. Geen zorgen meer over uren.</li>
        </ul>
      </div>

      <p class="auth-intro__foot">Nerds & Company maakt een helder overzicht voor jouw organisatie.</p>
    </aside>

    <main class="auth-main">
      <section class="auth-card" aria-labelledby="auth-heading">
        <p class="eyebrow">Naar je dashboard</p>
        <h2 id="auth-heading">{{ mode === 'login' ? 'Welkom terug' : 'Account aanmaken' }}</h2>
        <p class="auth-card__lead">
          {{ mode === 'login' ? 'Log in om je projecten te bekijken.' : 'Maak een account aan voor je dashboard.' }}
        </p>

        <div class="auth-tabs" role="group" aria-label="Kies inloggen of registreren">
          <button
            id="login-tab"
            class="auth-tab"
            :class="{ 'auth-tab--active': mode === 'login' }"
            type="button"
            :aria-pressed="mode === 'login'"
            @click="mode = 'login'; message = ''"
          >
            Inloggen
          </button>
          <button
            id="register-tab"
            class="auth-tab"
            :class="{ 'auth-tab--active': mode === 'register' }"
            type="button"
            :aria-pressed="mode === 'register'"
            @click="mode = 'register'; message = ''"
          >
            Registreren
          </button>
        </div>

        <form id="auth-form" class="auth-form" @submit.prevent="submitForm">

          <label v-if="mode === 'register'" class="field">
            <span>Naam</span>
            <input v-model="name" autocomplete="name" name="name" placeholder="Je naam" required />
          </label>

          <label class="field">
            <span>E-mailadres</span>
            <input
              v-model="email"
              autocomplete="email"
              name="email"
              type="email"
              placeholder="naam@bedrijf.nl"
              required
            />
          </label>

          <label class="field">
            <span>Wachtwoord</span>
            <input
              v-model="password"
              :autocomplete="mode === 'login' ? 'current-password' : 'new-password'"
              name="password"
              type="password"
              placeholder="Je wachtwoord"
              required
              minlength="8"
            />
          </label>

          <p v-if="message" class="form-message" role="alert">{{ message }}</p> 

          <button class="button button--primary button--wide" type="submit">
            {{ mode === 'login' ? 'Inloggen en demo bekijken' : 'Registreren en demo bekijken' }}
          </button>
        </form>

        <p class="demo-explanation">
          Ik maak gebruik van een demo-account om de werking van Nerdboard te laten zien. De gegevens die je invult worden niet opgeslagen en er wordt geen account aangemaakt. Je kunt de demo zo vaak bekijken als je wilt.
        </p>
      </section>

      <footer class="auth-contact">
        <span class="auth-contact__dot" aria-hidden="true"></span>
        Hulp nodig? Je kan een bericht sturen naar info@nerdsandcompany.nl.
      </footer>
    </main>
  </div>
</template>
