<script setup lang="ts">
import { computed } from 'vue'
import type { Project } from '../types'

const props = defineProps<{
  project: Project
}>()

const emit = defineEmits<{
  back: []
}>()

const remaining = computed(() => props.project.budget - props.project.recorded)
const progress = computed(() =>
  props.project.budget ? Math.min((props.project.recorded / props.project.budget) * 100, 100) : 0,
)
</script>

<template>
  <section class="page-section" aria-labelledby="project-heading">
    <button class="back-button" type="button" @click="emit('back')">
      <span aria-hidden="true">←</span> Terug naar dashboard
    </button>

    <div class="page-heading page-heading--detail">
      <div>
        <p class="eyebrow">Projectdetails</p>
        <h1 id="project-heading">{{ project.name }}</h1>
        <p class="page-heading__description">{{ project.description }}</p>
      </div>
      <span class="status-pill" :class="`status-pill--${project.status.toLowerCase().replace(' ', '-')}`">
        {{ project.status }}
      </span>
    </div>

    <section class="detail-hours-card" aria-labelledby="detail-hours-heading">
      <div class="detail-hours-card__heading">
        <div>
          <p class="eyebrow">Urenoverzicht</p>
          <h2 id="detail-hours-heading">Projecturen</h2>
        </div>
        <span class="detail-hours-card__updated">Bijgewerkt {{ project.updatedAt }}</span>
      </div>

      <div class="hours-grid hours-grid--detail">
        <div class="hours-stat">
          <span class="hours-stat__label">Urenbudget</span>
          <strong>{{ project.budget }} <small>uur</small></strong>
        </div>
        <div class="hours-stat">
          <span class="hours-stat__label">Geschreven</span>
          <strong>{{ project.recorded }} <small>uur</small></strong>
        </div>
        <div class="hours-stat hours-stat--remaining">
          <span class="hours-stat__label">Resterend</span>
          <strong>{{ remaining }} <small>uur</small></strong>
        </div>
      </div>
      <div
        class="hours-progress"
        role="progressbar"
        :aria-valuenow="Math.round(progress)"
        aria-valuemin="0"
        aria-valuemax="100"
        :aria-label="`Uren gebruikt voor ${project.name}`"
      >
        <span :style="{ width: `${progress}%` }"></span>
      </div>
      <p class="overview-card__caption">{{ Math.round(progress) }}% van het urenbudget gebruikt</p>
    </section>

    <section class="detail-lower-grid">
      <div class="detail-panel">
        <p class="eyebrow">Werkverdeling</p>
        <h2>Uren per fase</h2>
        <ul class="phase-list">
          <li v-for="phase in project.phases" :key="phase.name" class="phase-row">
            <span>{{ phase.name }}</span>
            <span class="phase-row__track" aria-hidden="true">
              <span :style="{ width: `${project.recorded ? (phase.hours / project.recorded) * 100 : 0}%` }"></span>
            </span>
            <strong>{{ phase.hours }} uur</strong>
          </li>
        </ul>
      </div>

      <aside class="detail-panel detail-panel--note">
        <p class="eyebrow">Projectinformatie</p>
        <h2>Alleen inzicht</h2>
        <p>De project en ureninformatie is bedoeld om te bekijken. Aanpassingen zijn niet beschikbaar.</p>
        <p class="sync-note">In de uiteindelijke versie worden deze gegevens via de backend uit Simplicate opgehaald.</p>
      </aside>
    </section>
  </section>
</template>
