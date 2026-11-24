import { readonly, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ApiError, apiRequest } from '../services/api'
import type { ProjectSummary } from '../types'
import { useAuth } from './useAuth'

const projectState = ref<ProjectSummary[]>([])
const loadingState = ref(false)
const errorState = ref('')

function clearProjectState() {
  projectState.value = []
  errorState.value = ''
  loadingState.value = false
}

window.addEventListener('nerdboard:session-changed', clearProjectState)
window.addEventListener('nerdboard:unauthorized', clearProjectState)

export function useProjects() {
  const { token } = useAuth()
  const { t } = useI18n()

  async function loadProjects() {
    loadingState.value = true
    errorState.value = ''

    try {
      projectState.value = await apiRequest<ProjectSummary[]>('/projects', { token: token.value ?? undefined })
    } catch (requestError) {
      errorState.value = requestError instanceof ApiError ? requestError.message : t('projects.api.error')
    } finally {
      loadingState.value = false
    }
  }

  function findById(id: string) {
    return projectState.value.find((project) => project.id === id)
  }

  return {
    projects: readonly(projectState),
    loading: readonly(loadingState),
    error: readonly(errorState),
    loadProjects,
    findById,
    clear: clearProjectState,
  }
}
