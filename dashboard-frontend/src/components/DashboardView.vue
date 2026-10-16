<script setup lang="ts">
import { computed, ref } from 'vue'
import ProjectCard from './ProjectCard.vue'
import type { Project, ProjectStatus } from '../types'

const props = defineProps<{
  projects: Project[]
}>()

const emit = defineEmits<{
  openProject: [project: Project]
}>()

const selectedFilter = ref<'Alle projecten' | ProjectStatus>('Alle projecten')
const filters: Array<'Alle projecten' | ProjectStatus> = [
  'Alle projecten',
  'Actief',
  'Afgerond',
  'On hold',
]

const filteredProjects = computed(() => {
  if (selectedFilter.value === 'Alle projecten') {
    return props.projects
  }

  return props.projects.filter((project) => project.status === selectedFilter.value)
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
        <p class="eyebrow">Gully B.V. · projecten</p>
        <h1 id="dashboard-heading">Altijd een goed begin.</h1>
        <p class="page-heading__description">Bekijk de projectstatus en uren in één overzicht.</p>
      </div>
      <div class="updated-label">
        <span class="updated-label__dot" aria-hidden="true"></span>
        Voorbeeldgegevens
      </div>
    </div>

    <section class="overview-card" aria-labelledby="overview-heading">
      <div class="overview-card__title">
        <div>
          <p class="eyebrow">Urenoverzicht</p>
          <h2 id="overview-heading">Alle projecten</h2>
        </div>
        <span class="overview-card__count">{{ filteredProjects.length }} projecten</span>
      </div>
      <div class="hours-grid">
        <div class="hours-stat">
          <span class="hours-stat__label">Budget</span>
          <strong>{{ totalBudget }} <small>uur</small></strong>
        </div>
        <div class="hours-stat">
          <span class="hours-stat__label">Geschreven</span>
          <strong>{{ totalRecorded }} <small>uur</small></strong>
        </div>
        <div class="hours-stat hours-stat--remaining">
          <span class="hours-stat__label">Resterend</span>
          <strong>{{ totalRemaining }} <small>uur</small></strong>
        </div>
      </div>
      <div
        class="hours-progress"
        role="progressbar"
        :aria-valuenow="totalBudget ? Math.round((totalRecorded / totalBudget) * 100) : 0"
        aria-valuemin="0"
        aria-valuemax="100"
        aria-label="Totaal geregistreerde uren"
      >
        <span :style="{ width: `${totalBudget ? (totalRecorded / totalBudget) * 100 : 0}%` }"></span>
      </div>
      <p class="overview-card__caption">
        {{ totalBudget ? Math.round((totalRecorded / totalBudget) * 100) : 0 }}% van het totale urenbudget gebruikt
      </p>
    </section>

    <div class="project-section-heading">
      <div>
        <h2>Projecten</h2>
        <p>Kies een project om de uren en details te bekijken.</p>
      </div>
      <div class="filter-list" aria-label="Projecten filteren">
        <button
          v-for="filter in filters"
          :key="filter"
          class="filter-chip"
          :class="{ 'filter-chip--active': selectedFilter === filter }"
          type="button"
          :aria-pressed="selectedFilter === filter"
          @click="selectedFilter = filter"
        >
          {{ filter }}
        </button>
      </div>
    </div>

    <div v-if="filteredProjects.length" class="project-grid">
      <ProjectCard
        v-for="project in filteredProjects"
        :key="project.id"
        :project="project"
        @open="emit('openProject', project)"
      />
    </div>
    <p v-else class="empty-state">Er zijn geen projecten met deze status.</p>
  </section>
</template>
