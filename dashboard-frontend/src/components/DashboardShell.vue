<script setup lang="ts">
import type { DashboardPage } from '../types'

defineProps<{
  activePage: DashboardPage
  userName: string
}>()

const emit = defineEmits<{
  navigate: [page: DashboardPage]
  logout: []
}>()
</script>

<template>
  <div class="dashboard-layout">
    <header class="topbar">
      <button
        class="brand brand-button"
        type="button"
        aria-label="Nerdboard dashboard"
        @click="emit('navigate', 'dashboard')"
      >
        <span class="brand-mark" aria-hidden="true">logo</span>
        <span>Nerdboard</span>
      </button>
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
          <button
            class="side-nav__link"
            :class="{ 'side-nav__link--active': activePage === 'dashboard' }"
            type="button"
            :aria-current="activePage === 'dashboard' ? 'page' : undefined"
            @click="emit('navigate', 'dashboard')"
          >
            <span class="side-nav__indicator" aria-hidden="true"></span>
            Dashboard
          </button>
          <button
            class="side-nav__link"
            :class="{ 'side-nav__link--active': activePage === 'project' }"
            type="button"
            :aria-current="activePage === 'project' ? 'page' : undefined"
            @click="emit('navigate', 'project')"
          >
            <span class="side-nav__indicator" aria-hidden="true"></span>
            Projectdetails
          </button>
          <button
            class="side-nav__link"
            :class="{ 'side-nav__link--active': activePage === 'profile' }"
            type="button"
            :aria-current="activePage === 'profile' ? 'page' : undefined"
            @click="emit('navigate', 'profile')"
          >
            <span class="side-nav__indicator" aria-hidden="true"></span>
            Profiel
          </button>
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
