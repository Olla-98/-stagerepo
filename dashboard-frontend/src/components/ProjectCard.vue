<script setup lang="ts">
import { toRef } from 'vue'
import { RouterLink } from 'vue-router'
import { useProjectHours } from '../composables/useProjectHours'
import type { ProjectSummary } from '../composables/projectState'

const props = defineProps<{
  project: ProjectSummary
}>()

const { progress } = useProjectHours(toRef(props, 'project'))
</script>

<template>
  <RouterLink class="project-card project-card--link" :to="{ name: 'project', params: { id: project.id } }">
    <h3>{{ project.name }}</h3>
    <div class="project-card__hours">
      <span>{{ $t('hours.usedFrom', { recorded: project.recorded, budget: project.budget }) }}</span>
      <span>{{ $t('hours.remainingShort', { remaining: project.remaining }) }}</span>
    </div>
    <div
      class="hours-progress hours-progress--compact"
      role="progressbar"
      :aria-valuenow="Math.round(progress)"
      aria-valuemin="0"
      aria-valuemax="100"
      :aria-label="$t('hours.usedForProject', { name: project.name })"
    >
      <span
        :style="{ width: `${progress}%` }"
      ></span>
    </div>
    <span class="text-button">
      {{ $t('project.viewDetails') }} <span aria-hidden="true">→</span>
    </span>
  </RouterLink>
</template>
