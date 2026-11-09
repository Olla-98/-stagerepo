<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAuth } from '../composables/useAuth'

const router = useRouter()
const route = useRoute()
const { t } = useI18n()
const { login, register } = useAuth()
const mode = ref<'login' | 'register'>('login')
const name = ref('')
const email = ref('')
const password = ref('')
const message = ref('')
const submitting = ref(false)

async function submitForm() {
  message.value = ''

  if (!email.value || !password.value) {
    message.value = t('login.missingCredentials')
    return
  }

  if (mode.value === 'register' && !name.value.trim()) {
    message.value = t('login.missingName')
    return
  }

  submitting.value = true
  try {
    if (mode.value === 'register') {
      await register(name.value.trim(), email.value, password.value)
    } else {
      await login(email.value, password.value)
    }
    await router.push({ name: 'dashboard' })
  } catch (error) {
    message.value = error instanceof Error ? error.message : t('login.requestFailed')
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="auth-page">
    <aside class="auth-intro">
      <div class="brand brand--large">
        <span class="brand-mark" aria-hidden="true">Logo</span>
        <span>{{ $t('brand.name') }}</span>
      </div>

      <div class="auth-intro__copy">
        <p class="eyebrow">{{ $t('login.introEyebrow') }}</p>
        <h1>{{ $t('login.introHeading') }}</h1>
        <p>{{ $t('login.introDescription') }}</p>
        <ul class="auth-benefits">
          <li>{{ $t('login.benefitProjects') }}</li>
          <li>{{ $t('login.benefitHours') }}</li>
        </ul>
      </div>

      <p class="auth-intro__foot">{{ $t('login.introFoot') }}</p>
    </aside>

    <main class="auth-main">
      <section class="auth-card" aria-labelledby="auth-heading">
        <p class="eyebrow">{{ $t('login.eyebrow') }}</p>
        <h2 id="auth-heading">{{ mode === 'login' ? $t('login.welcome') : $t('login.createAccount') }}</h2>
        <p class="auth-card__lead">
          {{ mode === 'login' ? $t('login.loginLead') : $t('login.registerLead') }}
        </p>

        <div class="auth-tabs" role="group" :aria-label="$t('login.chooseMode')">
          <button
            id="login-tab"
            class="auth-tab"
            :class="{ 'auth-tab--active': mode === 'login' }"
            type="button"
            :aria-pressed="mode === 'login'"
            @click="mode = 'login'; message = ''"
          >
            {{ $t('login.loginTab') }}
          </button>
          <button
            id="register-tab"
            class="auth-tab"
            :class="{ 'auth-tab--active': mode === 'register' }"
            type="button"
            :aria-pressed="mode === 'register'"
            @click="mode = 'register'; message = ''"
          >
            {{ $t('login.registerTab') }}
          </button>
        </div>

        <form id="auth-form" class="auth-form" :aria-busy="submitting" @submit.prevent="submitForm">
          <label v-if="mode === 'register'" class="field">
            <span>{{ $t('login.name') }}</span>
            <input v-model="name" autocomplete="name" name="name" :placeholder="$t('login.yourName')" required />
          </label>

          <label class="field">
            <span>{{ $t('login.email') }}</span>
            <input
              v-model="email"
              autocomplete="email"
              name="email"
              type="email"
              :placeholder="$t('login.emailPlaceholder')"
              required
            />
          </label>

          <label class="field">
            <span>{{ $t('login.password') }}</span>
            <input
              v-model="password"
              :autocomplete="mode === 'login' ? 'current-password' : 'new-password'"
              name="password"
              type="password"
              :placeholder="$t('login.passwordPlaceholder')"
              required
              minlength="8"
            />
          </label>

          <p v-if="message" class="form-message" role="alert">{{ message }}</p>

          <button class="button button--primary button--wide" type="submit" :disabled="submitting">
            {{ mode === 'login' ? $t('login.loginSubmit') : $t('login.registerSubmit') }}
          </button>
        </form>

        <p v-if="route.query.error === 'connection'" class="form-message" role="alert">
          {{ $t('login.connectionError') }}
        </p>
        <p v-else-if="route.query.error === 'logout'" class="form-message" role="alert">
          {{ $t('login.logoutError') }}
        </p>
        <p class="demo-explanation">{{ $t('login.secureConnection') }}</p>
      </section>

      <footer class="auth-contact">
        <span class="auth-contact__dot" aria-hidden="true"></span>
        {{ $t('login.contact') }}
      </footer>
    </main>
  </div>
</template>
