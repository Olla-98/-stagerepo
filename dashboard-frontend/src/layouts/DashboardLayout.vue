<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import DashboardNav from '../components/DashboardNav.vue'
import { useAuth } from '../composables/useAuth'
import { useProjects } from '../composables/useProjects'

const router = useRouter()
const { t } = useI18n()
const { user, logout } = useAuth()
const { clearProjects } = useProjects()
const userName = computed(() => user.value?.name ?? t('account.defaultUser'))

async function signOut() {
  try {
    await logout()
    clearProjects()
    await router.replace({ name: 'login' })
  } catch {
    clearProjects()
    await router.replace({ name: 'login', query: { error: 'logout' } })
  }
}
</script>

<template>
  <div class="dashboard-layout">
    <header class="topbar">
      <RouterLink class="brand" :to="{ name: 'dashboard' }" :aria-label="$t('brand.dashboardLabel')">
        <span class="brand-mark" aria-hidden="true">logo</span>
        <span>{{ $t('brand.name') }}</span>
      </RouterLink>
      <div class="topbar__account">
        <span class="topbar__user">{{ userName }}</span>
        <button class="button button--quiet button--small" type="button" @click="signOut">
          {{ $t('account.logout') }}
        </button>
      </div>
    </header>

    <div class="dashboard-body">
      <DashboardNav />
      <main class="dashboard-main">
        <RouterView />
      </main>
    </div>
  </div>
</template>
