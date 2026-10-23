<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import DashboardShell from '../components/DashboardShell.vue'
import { useDemoSession } from '../demoSession'
import type { DashboardPage } from '../types'

const route = useRoute()
const router = useRouter()
const { user, endDemoSession } = useDemoSession()
const activePage = computed<DashboardPage>(() =>
  route.name === 'dashboard' ? 'dashboard' : 'project',
)
const userName = computed(() => user.value?.name ?? 'Klant')

function logout() {
  endDemoSession()
  return router.replace({ name: 'login' })
}
</script>

<template>
  <DashboardShell :active-page="activePage" :user-name="userName" @logout="logout">
    <div class="demo-notice" role="status">
      <span>
        <strong>Voorbeeldweergave</strong> · projecten en uren zijn fictief; dit is geen echte login.
      </span>
    </div>
    <RouterView />
  </DashboardShell>
</template>
