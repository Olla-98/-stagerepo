<script setup lang="ts">
import type { UserProfile } from '../types'

defineProps<{
  user: UserProfile
}>()

const emit = defineEmits<{
  backToDashboard: []
}>()
</script>

<template>
  <section class="page-section" aria-labelledby="profile-heading">
    <div class="page-heading">
      <div>
        <p class="eyebrow">Jouw account</p>
        <h1 id="profile-heading">Profiel</h1>
        <p class="page-heading__description">Bekijk de accountgegevens die bij deze demo horen.</p>
      </div>
    </div>

    <section class="profile-card">
      <div class="profile-card__identity">
        <div class="avatar" aria-hidden="true">{{ user.name.charAt(0).toUpperCase() }}</div>
        <div>
          <p class="eyebrow">Klantgebruiker</p>
          <h2>{{ user.name }}</h2>
        </div>
      </div>

      <div class="profile-fields">
        <div class="profile-field">
          <span>Naam</span>
          <strong>{{ user.name }}</strong>
        </div>
        <div class="profile-field">
          <span>E-mailadres</span>
          <strong>{{ user.email }}</strong>
        </div>
        <div class="profile-field">
          <span>Organisatie</span>
          <strong>Gully B.V.</strong>
        </div>
      </div>

      <div class="profile-card__notice">
        Profiel wijzigen, wachtwoord herstellen en account deactiveren zijn niet beschikbaar.
        Dit is een read-only demoomgeving. Voor vragen kun je contact opnemen met <a href="mailto:support@gully.nl">support@gully.nl</a>.
      </div>

      <button class="button button--primary" type="button" @click="emit('backToDashboard')">
        Terug naar dashboard
      </button>
    </section>
  </section>
</template>
