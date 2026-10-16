<script setup lang="ts">
import { computed, ref } from 'vue'
import AuthView from './components/AuthView.vue'
import DashboardShell from './components/DashboardShell.vue'
import DashboardView from './components/DashboardView.vue'
import ProfileView from './components/ProfileView.vue'
import ProjectDetailView from './components/ProjectDetailView.vue'
import { projects } from './data/projects'
import type { DashboardPage, Project, UserProfile } from './types'

const isDemoSession = ref(false)
const activePage = ref<DashboardPage>('dashboard')
const selectedProjectId = ref(projects[0]?.id ?? '')
const notice = ref('')
const user = ref<UserProfile>({
  name: 'Ola',
  email: 'ola@example.nl',
})

const selectedProject = computed(
  () => projects.find((project) => project.id === selectedProjectId.value) ?? projects[0],
)

function openDemo(email: string, name?: string) {
  user.value = {
    name: name?.trim() || email.split('@')[0] || 'Klant',
    email,
  }
  isDemoSession.value = true
  activePage.value = 'dashboard'
  notice.value = 'Dit is de dashboard met voorbeeldgegevens'
}

function navigate(page: DashboardPage) {
  activePage.value = page
  notice.value = ''
}

function showProject(project: Project) {
  selectedProjectId.value = project.id
  activePage.value = 'project'
  notice.value = ''
}

function endDemo() {
  isDemoSession.value = false
  activePage.value = 'dashboard'
  notice.value = ''
}
</script>

<template>
  <AuthView v-if="!isDemoSession" @open-demo="openDemo" />

  <DashboardShell
    v-else
    :active-page="activePage"
    :user-name="user.name"
    @navigate="navigate"
    @logout="endDemo"
  >
    <div class="demo-notice" role="status">
      <span><strong>Voorbeeldweergave</strong> · projecten en uren zijn fictief; dit is geen echte login.</span>
      <span v-if="notice">{{ notice }}</span>
    </div>

    <DashboardView
      v-if="activePage === 'dashboard'"
      :projects="projects"
      @open-project="showProject"
    />

    <ProjectDetailView
      v-else-if="activePage === 'project' && selectedProject"
      :project="selectedProject"
      @back="navigate('dashboard')"
    />

    <ProfileView
      v-else
      :user="user"
      @back-to-dashboard="navigate('dashboard')"
    />
  </DashboardShell>
</template>
