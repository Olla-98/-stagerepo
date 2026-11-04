import { apiRequest } from '../services/api'
import type { ProjectSummary } from './projectState'
import { useAuth } from './useAuth'
import { projects, projectsError as error, projectsLoading as loading } from './projectState'
const { token } = useAuth()

export function useProjects() {
  async function loadProjects() {
    loading.value = true
    error.value = ''

    try {
      projects.value = await apiRequest<ProjectSummary[]>('/projects', { token: token.value ?? undefined })
    } catch (requestError) {
      error.value = requestError instanceof Error ? requestError.message : 'Projecten laden is mislukt.'
    } finally {
      loading.value = false
    }
  }

  return { projects, loading, error, loadProjects }
}
