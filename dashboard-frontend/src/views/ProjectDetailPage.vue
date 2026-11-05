<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import HoursSummary from '../components/HoursSummary.vue'
import { useProjectHours } from '../composables/useProjectHours'
import { useProjects } from '../composables/useProjects'

const route = useRoute()
const { projects, loading, error, loadProjects } = useProjects()
const project = computed(() => projects.value.find((item) => item.id === route.params.id))
const projectHours = computed(() => project.value ?? { budget: 0, recorded: 0 })
const { remaining, progress } = useProjectHours(projectHours)

onMounted(() => {
  if (!projects.value.length) {
    void loadProjects()
  }
})
</script>

<template>
  <section class="page-section" aria-labelledby="project-heading">
    <RouterLink class="back-button" :to="{ name: 'dashboard' }">
      <span aria-hidden="true">←</span> {{ $t('project.backToDashboard') }}
    </RouterLink>

    <p v-if="loading" class="empty-state" role="status">{{ $t('dashboard.loading') }}</p>
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
        </div>
      </div>

      <section class="detail-hours-card" aria-labelledby="detail-hours-heading">
        <div class="detail-hours-card__heading">
          <div>
            <p class="eyebrow">{{ $t('project.hoursOverview') }}</p>
            <h2 id="detail-hours-heading">{{ $t('project.hoursTitle') }}</h2>
          </div>
        </div>

        <HoursSummary
          class="hours-grid--detail"
          :budget="project.budget"
          :recorded="project.recorded"
          :remaining="remaining"
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
        <p class="overview-card__caption">
          {{ $t('hours.projectPercentUsed', { percent: Math.round(progress) }) }}
        </p>
      </section>
    </template>
  </section>
</template>
