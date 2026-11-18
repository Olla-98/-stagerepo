import { apiRequest } from '../services/api'
import i18n from '../i18n'
import type { Project } from '../types'
import {
  clearProjectState,
  projects,
  projectsError,
  projectsLoaded,
  projectsLoading,
} from './projectState'
import { useAuth } from './useAuth'

export function useProjects() {
  async function loadProjects() {
    const { token } = useAuth()
    projectsLoading.value = true
    projectsError.value = ''

    try {
      const projectList = await apiRequest<Project[]>('/projects', {
        token: token.value,
      })
      projects.value = projectList.map((project) => ({
        ...project,
        remaining: project.budget - project.recorded,
      }))
    } catch (loadError) {
      if (loadError instanceof TypeError) {
        projectsError.value = i18n.global.t('dashboard.connectionError')
      } else {
        projectsError.value = i18n.global.t('dashboard.loadError')
      }
    } finally {
      projectsLoading.value = false
      projectsLoaded.value = true
    }
  }

  return {
    projects,
    loading: projectsLoading,
    loaded: projectsLoaded,
    error: projectsError,
    loadProjects,
    clearProjects: clearProjectState,
  }
}
