<template>
  <div v-if="isLoading">Laden...</div>
  <div v-else>
    <section class="page-section" aria-labelledby="project-heading">
      <RouterLink class="back-button" :to="{ name: 'dashboard' }">
        <span aria-hidden="true">←</span> {{ $t('project.backToDashboard') }}
      </RouterLink>

    <p v-if="loading || !loaded" class="empty-state" role="status">{{ $t('dashboard.loading') }}</p>
    <div v-else-if="error" class="empty-state" role="alert">
      <p>{{ error }}</p>
      <button class="text-button" type="button" @click="loadProjects">{{ $t('dashboard.retry') }}</button>
    </div>
    <p v-else-if="!project" class="empty-state" role="alert">{{ $t('project.notFound') }}</p>
    <template v-else>
      <div class="page-heading page-heading--detail">
        <div>
          <p class="eyebrow">{{ $t('project.eyebrow') }}</p>
          <h1 id="project-heading">{{ project.name }}</h1>
          <!-- <p class="page-heading__description">{{ project.description }}</p> -->
        </div>
        <!-- <span class="status-pill" :class="`status-pill--${project.status.toLowerCase().replace(' ', '-')}`">
          {{ project.status }}
        </span> -->
      </div>

      <section class="detail-hours-card" aria-labelledby="detail-hours-heading">
        <div class="detail-hours-card__heading">
          <div>
            <p class="eyebrow">{{ $t('project.hoursOverview') }}</p>
            <h2 id="detail-hours-heading">{{ $t('project.hoursTitle') }}</h2>
          </div>
          <!-- <span class="detail-hours-card__updated">{{ $t('project.updated', { date: project.updatedAt }) }}</span> -->
        </div>

        <HoursSummary
          class="hours-grid--detail"
          :budget="project.budget"
          :recorded="project.geregistreerde_uren"
          :remaining="project.resterende_uren"
          :budget-label="$t('hours.projectBudget')"
        />
        <div
          class="hours-progress"
          role="progressbar"
          :aria-valuenow="Math.round(50)"
          aria-valuemin="0"
          aria-valuemax="100"
          :aria-label="$t('hours.usedForProject', { name: project.name })"
        >
          <span :style="{ width: `${50}%` }"></span>
        </div>
        <p class="overview-card__caption">{{ $t('hours.projectPercentUsed', { percent: Math.round(50) }) }}</p>
      </section>

      <section class="detail-lower-grid">
        <!-- <div class="detail-panel">
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
        </div> -->

        <aside class="detail-panel detail-panel--note">
          <p class="eyebrow">{{ $t('project.projectInformation') }}</p>
          <h2>{{ $t('project.viewOnly') }}</h2>
          <p>{{ $t('project.viewOnlyDescription') }}</p>
          <p class="sync-note">{{ $t('project.backendNote') }}</p>
        </aside>
      </section>
    </section>
    </div>
</template>

<script setup lang="ts">
  import { useRoute, RouterLink } from 'vue-router'
  import HoursSummary from '../components/HoursSummary.vue'
  import { useProjectHours } from '../composables/useProjectHours'
  import { ref, onMounted } from 'vue'

  const isLoading = ref(true)
  let project: object;

  onMounted(async () => {
    try {
      project = await useProjectHours();
    } finally {
      isLoading.value = false
    }
  })
</script>