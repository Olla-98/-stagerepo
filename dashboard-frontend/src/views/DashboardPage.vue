<script setup lang="ts">
import { computed, ref } from 'vue'
import HoursSummary from '../components/HoursSummary.vue'
import ProjectCard from '../components/ProjectCard.vue'
import { projects } from '../data/projects'
import type { ProjectStatus } from '../types'

const selectedFilter = ref<'all' | ProjectStatus>('all')
const filters: Array<'all' | ProjectStatus> = [
  'all',
  'Actief',
  'Afgerond',
  'On hold',
]

const filteredProjects = computed(() => {
  if (selectedFilter.value === 'all') {
    return projects
  }

  return projects.filter((project) => project.status === selectedFilter.value)
})

const totalBudget = computed(() =>
  filteredProjects.value.reduce((total, project) => total + project.budget, 0),
)
const totalRecorded = computed(() =>
  filteredProjects.value.reduce((total, project) => total + project.recorded, 0),
)
const totalRemaining = computed(() => totalBudget.value - totalRecorded.value)
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
        {{ $t('demo.data') }}
      </div>
    </div>

    <section class="overview-card" aria-labelledby="overview-heading">
      <div class="overview-card__title">
        <div>
          <p class="eyebrow">{{ $t('dashboard.hoursOverview') }}</p>
          <h2 id="overview-heading">{{ $t('dashboard.allProjects') }}</h2>
        </div>
        <span class="overview-card__count">{{ $t('dashboard.projectCount', filteredProjects.length) }}</span>
      </div>
      <HoursSummary
        :budget="totalBudget"
        :recorded="totalRecorded"
        :remaining="totalRemaining"
      />
      <div
        class="hours-progress"
        role="progressbar"
        :aria-valuenow="totalBudget ? Math.round((totalRecorded / totalBudget) * 100) : 0"
        aria-valuemin="0"
        aria-valuemax="100"
        :aria-label="$t('hours.totalRecorded')"
      >
        <span :style="{ width: `${totalBudget ? (totalRecorded / totalBudget) * 100 : 0}%` }"></span>
      </div>
      <p class="overview-card__caption">
        {{ $t('hours.totalPercentUsed', { percent: totalBudget ? Math.round((totalRecorded / totalBudget) * 100) : 0 }) }}
      </p>
    </section>

    <div class="project-section-heading">
      <div>
        <h2>{{ $t('dashboard.projectsHeading') }}</h2>
        <p>{{ $t('dashboard.projectsPrompt') }}</p>
      </div>
      <div class="filter-list" :aria-label="$t('dashboard.filterLabel')">
        <button
          v-for="filter in filters"
          :key="filter"
          class="filter-chip"
          :class="{ 'filter-chip--active': selectedFilter === filter }"
          type="button"
          :aria-pressed="selectedFilter === filter"
          @click="selectedFilter = filter"
        >
          {{ filter === 'all' ? $t('dashboard.filterAll') : $t(`status.${filter}`) }}
        </button>
      </div>
    </div>

    <div v-if="filteredProjects.length" class="project-grid">
      <ProjectCard
        v-for="project in filteredProjects"
        :key="project.id"
        :project="project"
      />
    </div>
    <p v-else class="empty-state">{{ $t('dashboard.emptyState') }}</p>
  </section>
</template>
