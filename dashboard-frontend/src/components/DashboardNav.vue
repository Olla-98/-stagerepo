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
    </nav>

    <div class="sidebar__help">
      <span>{{ $t('navigation.helpQuestion') }}</span>
      <span>{{ $t('navigation.helpContact') }}</span>
    </div>
  </aside>
</template>
