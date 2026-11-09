<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import HoursSummary from '../components/HoursSummary.vue'
import ProjectCard from '../components/ProjectCard.vue'
import { useProjects } from '../composables/useProjects'
import type { ProjectStatus } from '../types'

const { projects, loading, loaded, error, loadProjects } = useProjects()
const selectedFilter = ref<'all' | ProjectStatus>('all')
const filters: Array<'all' | ProjectStatus> = [
  'all',
  'Actief',
  'Afgerond',
  'On hold',
]

const filteredProjects = computed(() => {
  if (selectedFilter.value === 'all') {
    return projects.value
  }

  return projects.value.filter((project) => project.status === selectedFilter.value)
})

const totalBudget = computed(() =>
  filteredProjects.value.reduce((total, project) => total + project.budget, 0),
)
const totalRecorded = computed(() =>
  filteredProjects.value.reduce((total, project) => total + project.recorded, 0),
)
const totalRemaining = computed(() => totalBudget.value - totalRecorded.value)

onMounted(loadProjects)
</script>

<template>
  <section class="page-section" aria-labelledby="dashboard-heading">
    <div class="page-heading">
      <div>
        <p class="eyebrow">{{ $t('dashboard.eyebrow') }}</p>
        <h1 id="dashboard-heading">{{ $t('dashboard.heading') }}</h1>
        <p class="page-heading__description">{{ $t('dashboard.description') }}</p>
      </div>
      <div class="updated-label">
        <span class="updated-label__dot" aria-hidden="true"></span>
        {{ $t('dashboard.dataSource') }}
      </div>
    </div>

    <section v-if="loaded && !error && filteredProjects.length" class="overview-card" aria-labelledby="overview-heading">
      <div class="overview-card__title">
        <div>
          <p class="eyebrow">{{ $t('dashboard.hoursOverview') }}</p>
          <h2 id="overview-heading">{{ $t('dashboard.allProjects') }}</h2>
        </div>
        <span class="overview-card__count">{{ $t('dashboard.projectCount', projects.length) }}</span>
      </div>
      <HoursSummary
        :budget="totalBudget"
        :recorded="totalRecorded"
        :remaining="totalRemaining"
      />
      <div
        class="hours-progress"
        role="progressbar"
        :aria-valuenow="usagePercent"
        aria-valuemin="0"
        aria-valuemax="100"
        :aria-label="$t('hours.totalRecorded')"
      >
        <span :style="{ width: `${usagePercent}%` }"></span>
      </div>
      <p class="overview-card__caption">
        {{ $t('hours.totalPercentUsed', { percent: usagePercent }) }}
      </p>
    </section>

    <div class="project-section-heading">
      <div>
        <h2>{{ $t('dashboard.projectsHeading') }}</h2>
        <p>{{ $t('dashboard.projectsPrompt') }}</p>
      </div>
      <span v-if="!loading && !error" class="overview-card__count">
        {{ $t('dashboard.projectCount', projects.length) }}
      </span>
    </div>

    <p v-if="loading" class="empty-state" role="status">{{ $t('dashboard.loading') }}</p>
    <div v-else-if="error" class="empty-state" role="alert">
      <p>{{ error }}</p>
      <button class="text-button" type="button" @click="loadProjects">{{ $t('dashboard.retry') }}</button>
    </div>
    <div v-else-if="filteredProjects.length" class="project-grid">
      <ProjectCard
        v-for="project in projects"
        :key="project.id"
        :project="project"
      />
    </div>
    <p v-else class="empty-state">{{ $t('dashboard.emptyState') }}</p>
  </section>
</template>
