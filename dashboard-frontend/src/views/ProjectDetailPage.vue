<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import HoursSummary from '../components/HoursSummary.vue'
import { useProjectHours } from '../composables/useProjectHours'
import { projects } from '../data/projects'

const route = useRoute()
const project = computed(() => projects.find((item) => item.id === route.params.id)!)
const { remaining, progress } = useProjectHours(project)
</script>

<template>
  <section class="page-section" aria-labelledby="project-heading">
    <RouterLink class="back-button" :to="{ name: 'dashboard' }">
      <span aria-hidden="true">←</span> {{ $t('project.backToDashboard') }}
    </RouterLink>

    <div class="page-heading page-heading--detail">
      <div>
        <p class="eyebrow">{{ $t('project.eyebrow') }}</p>
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
          <p class="eyebrow">{{ $t('project.hoursOverview') }}</p>
          <h2 id="detail-hours-heading">{{ $t('project.hoursTitle') }}</h2>
        </div>
        <span class="detail-hours-card__updated">{{ $t('project.updated', { date: project.updatedAt }) }}</span>
      </div>

      <HoursSummary
        class="hours-grid--detail"
        :budget="project.budget"
        :recorded="project.recorded"
        :remaining="remaining"
        :budget-label="$t('hours.projectBudget')"
      />
      <div
        class="hours-progress"
        role="progressbar"
        :aria-valuenow="Math.round(progress)"
        aria-valuemin="0"
        aria-valuemax="100"
        :aria-label="$t('hours.usedForProject', { name: project.name })"
      >
        <span :style="{ width: `${progress}%` }"></span>
      </div>
      <p class="overview-card__caption">{{ $t('hours.projectPercentUsed', { percent: Math.round(progress) }) }}</p>
    </section>

    <section class="detail-lower-grid">
      <div class="detail-panel">
        <p class="eyebrow">{{ $t('project.workDistribution') }}</p>
        <h2>{{ $t('project.hoursByPhase') }}</h2>
        <ul class="phase-list">
          <li v-for="phase in project.phases" :key="phase.name" class="phase-row">
            <span>{{ phase.name }}</span>
            <span class="phase-row__track" aria-hidden="true">
              <span :style="{ width: `${project.recorded ? (phase.hours / project.recorded) * 100 : 0}%` }"></span>
            </span>
            <strong>{{ phase.hours }} {{ $t('hours.unit') }}</strong>
          </li>
        </ul>
      </div>

      <aside class="detail-panel detail-panel--note">
        <p class="eyebrow">{{ $t('project.projectInformation') }}</p>
        <h2>{{ $t('project.viewOnly') }}</h2>
        <p>{{ $t('project.viewOnlyDescription') }}</p>
        <p class="sync-note">{{ $t('project.backendNote') }}</p>
      </aside>
    </section>
  </section>
</template>
