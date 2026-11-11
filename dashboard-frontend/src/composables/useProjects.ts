import { computed, ref } from 'vue'
import { ApiError, apiRequest } from '../services/api'
import i18n from '../i18n'
import type { Project } from '../types'
import { useAuth } from './useAuth'

const projectList = ref<Project[]>([])
const loading = ref(false)
const loaded = ref(false)
const error = ref<string | null>(null)

export function useProjects() {
  const projects = computed(() => projectList.value)

  async function loadProjects() {
    const { token } = useAuth()
    loading.value = true
    error.value = null

    try {
      projectList.value = await apiRequest<Project[]>('/projects', {
        token: token.value,
      })
    } catch (loadError) {
      if (loadError instanceof TypeError) {
        error.value = i18n.global.t('dashboard.connectionError')
      } else if (
        loadError instanceof ApiError &&
        !loadError.message.startsWith('Request failed')
      ) {
        error.value = loadError.message
      } else {
        error.value = i18n.global.t('dashboard.loadError')
      }
    } finally {
      loading.value = false
      loaded.value = true
    }
  }

  function clearProjects() {
    projectList.value = []
    error.value = null
    loaded.value = false
  }

  return { projects, loading, loaded, error, loadProjects, clearProjects }
}
