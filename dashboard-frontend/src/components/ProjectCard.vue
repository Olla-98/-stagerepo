<script setup lang="ts">
import { computed } from 'vue'
import type { Project } from '../types'

const props = defineProps<{
  project: Project
}>()

const emit = defineEmits<{
  open: []
}>()

const remaining = computed(() => props.project.budget - props.project.recorded)
const progress = computed(() =>
  props.project.budget ? Math.min((props.project.recorded / props.project.budget) * 100, 100) : 0,
)
</script>

<template>
  <article class="project-card">
    <div class="project-card__top">
      <span class="status-pill" :class="`status-pill--${project.status.toLowerCase().replace(' ', '-')}`">
        {{ project.status }}
      </span>
      <span class="project-card__date">Bijgewerkt {{ project.updatedAt }}</span>
    </div>

    <h3>{{ project.name }}</h3>
    <p class="project-card__description">{{ project.description }}</p>

    <div class="project-card__hours">
      <span><strong>{{ project.recorded }}</strong> van {{ project.budget }} uur gebruikt</span>
      <span><strong>{{ remaining }}</strong> uur over</span>
    </div>
    <div
      class="hours-progress hours-progress--compact"
      role="progressbar"
      :aria-valuenow="Math.round(progress)"
      aria-valuemin="0"
      aria-valuemax="100"
      :aria-label="`Uren gebruikt voor ${project.name}`"
    >
      <span :style="{ width: `${progress}%` }"></span>
    </div>

    <button class="text-button" type="button" @click="emit('open')">
      Bekijk details <span aria-hidden="true">→</span>
    </button>
  </article>
</template>
