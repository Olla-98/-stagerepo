<script setup lang="ts">
import { useRoute } from 'vue-router'

const route = useRoute()
</script>

<template>
  <aside class="sidebar">
    <nav class="side-nav" :aria-label="$t('navigation.label')">
      <RouterLink
        class="side-nav__link"
        exact-active-class="side-nav__link--active"
        :to="{ name: 'dashboard' }"
      >
        <span class="side-nav__indicator" aria-hidden="true"></span>
        {{ $t('navigation.dashboard') }}
      </RouterLink>
      <RouterLink
        v-if="route.name === 'project' && typeof route.params.id === 'string'"
        class="side-nav__link"
        exact-active-class="side-nav__link--active"
        :to="{ name: 'project', params: { id: route.params.id } }"
      >
        <span class="side-nav__indicator" aria-hidden="true"></span>
        {{ $t('navigation.projectDetails') }}
      </RouterLink>
    </nav>

    <div class="sidebar__help">
      <span>{{ $t('navigation.helpQuestion') }}</span>
      <span>{{ $t('navigation.helpContact') }}</span>
    </div>
  </aside>
</template>
