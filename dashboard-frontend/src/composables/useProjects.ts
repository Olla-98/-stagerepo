import { computed, ref } from 'vue'
import { apiRequest } from '../services/api'
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
      error.value = loadError instanceof Error
        ? loadError.message
        : 'Projectgegevens konden niet worden opgehaald.'
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
