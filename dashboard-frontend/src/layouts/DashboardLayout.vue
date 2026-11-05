<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import DashboardNav from '../components/DashboardNav.vue'
import { useDemoSession } from '../composables/useDemoSession'

const router = useRouter()
const { t } = useI18n()
const { user, endDemoSession } = useDemoSession()
const userName = computed(() => user.value?.name ?? t('account.defaultUser'))

function logout() {
  endDemoSession()
  return router.replace({ name: 'login' })
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
        <span class="topbar__company">Gully B.V.</span>
        <span class="topbar__user">{{ userName }}</span>
        <button class="button button--quiet button--small" type="button" @click="logout">
          {{ $t('account.logout') }}
        </button>
      </div>
    </header>

    <div class="dashboard-body">
      <DashboardNav />
      <main class="dashboard-main">
        <div class="demo-notice" role="status">
          <span>
            <strong>{{ $t('demo.title') }}</strong> · {{ $t('demo.notice') }}
          </span>
        </div>
        <RouterView />
      </main>
    </div>
  </div>
</template>
