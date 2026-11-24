import { computed, type Ref } from 'vue'
import { ApiError, apiRequest } from '../services/api'
import type { Project } from '../types'

export async function useProjectHours() {
  const tokenKey = 'nerdboard-auth-token'
  const storedToken = sessionStorage.getItem(tokenKey)

  const result = await apiRequest<{ id: string, name: string, organization_id: string, budget: number, geregistreerde_uren: number, resterende_uren: number }>('/projects', {
        method: 'GET'
      });

  return result;

  // const remaining = computed(
  //   () => project.value.budget - project.value.recorded,
  // )

  // const progress = computed(() => {
  //   const { budget, recorded } = project.value

  //   if (budget === 0) {
  //     return 0
  //   }

  //   return Math.min((recorded / budget) * 100, 100)
  // })

  // return { remaining, progress }
}
