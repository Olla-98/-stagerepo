<script setup lang="ts">
import { toRef } from 'vue'
import { RouterLink } from 'vue-router'
import { useProjectHours } from '../composables/useProjectHours'
import type { Project } from '../types'

const props = defineProps<{
  project: Project
}>()

const { remaining, progress } = useProjectHours(toRef(props, 'project'))
</script>

<template>
  <article class="project-card">
    <div class="project-card__top">
      <span class="status-pill" :class="`status-pill--${project.status.toLowerCase().replace(' ', '-')}`">
        {{ $t(`status.${project.status}`) }}
      </span>
      <span class="project-card__date">{{ $t('project.updated', { date: project.updatedAt }) }}</span>
    </div>

    <h3>{{ project.name }}</h3>
    <p class="project-card__description">{{ project.description }}</p>

    <div class="project-card__hours">
      <i18n-t keypath="hours.usedFrom" tag="span">
        <template #recorded><strong>{{ project.recorded }}</strong></template>
        <template #budget>{{ project.budget }}</template>
      </i18n-t>
      <i18n-t keypath="hours.remainingShort" tag="span">
        <template #remaining><strong>{{ remaining }}</strong></template>
      </i18n-t>
    </div>
    <div
      class="hours-progress hours-progress--compact"
      role="progressbar"
      :aria-valuenow="Math.round(progress)"
      aria-valuemin="0"
      aria-valuemax="100"
      :aria-label="$t('hours.usedForProject', { name: project.name })"
    >
      <span :style="{ width: `${progress}%` }"></span>
    </div>

    <RouterLink class="text-button" :to="{ name: 'project', params: { id: project.id } }">
      {{ $t('project.viewDetails') }} <span aria-hidden="true">→</span>
    </RouterLink>
  </article>
</template>
