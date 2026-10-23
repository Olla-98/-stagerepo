<script setup lang="ts">
import type { DashboardPage } from '../types'

defineProps<{
  activePage: DashboardPage
  userName: string
}>()

const emit = defineEmits<{
  logout: []
}>()
</script>

<template>
  <div class="dashboard-layout">
    <header class="topbar">
      <RouterLink class="brand" :to="{ name: 'dashboard' }" aria-label="Nerdboard dashboard">
        <span class="brand-mark" aria-hidden="true">logo</span>
        <span>Nerdboard</span>
      </RouterLink>
      <div class="topbar__account">
        <span class="topbar__company">Gully B.V.</span>
        <span class="topbar__user">{{ userName }}</span>
        <button class="button button--quiet button--small" type="button" @click="emit('logout')">
          Uitloggen
        </button>
      </div>
    </header>

    <div class="dashboard-body">
      <aside class="sidebar">
        <nav class="side-nav" aria-label="Hoofdnavigatie">
          <RouterLink
            class="side-nav__link"
            :class="{ 'side-nav__link--active': activePage === 'dashboard' }"
            :aria-current="activePage === 'dashboard' ? 'page' : undefined"
            :to="{ name: 'dashboard' }"
          >
            <span class="side-nav__indicator" aria-hidden="true"></span>
            Dashboard
          </RouterLink>
          <RouterLink
            class="side-nav__link"
            :class="{ 'side-nav__link--active': activePage === 'project' }"
            :aria-current="activePage === 'project' ? 'page' : undefined"
            :to="{ name: 'project', params: { id: 'website' } }"
          >
            <span class="side-nav__indicator" aria-hidden="true"></span>
            Projectdetails
          </RouterLink>
        </nav>

        <div class="sidebar__help">
          <span>Vragen over je dashboard?</span>
          <span>Neem contact op met info@nerdsandcompany.nl.</span>
        </div>
      </aside>

      <main class="dashboard-main">
        <slot />
      </main>
    </div>
  </div>
</template>
