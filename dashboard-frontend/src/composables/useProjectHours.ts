import { computed, type Ref } from 'vue'
import type { ProjectHours } from '../types'

export function useProjectHours(project: Ref<ProjectHours>) {
  const remaining = computed(() => project.value.budget - project.value.recorded)
  const progress = computed(() => {
    const { budget, recorded } = project.value
    return budget > 0 ? Math.min((recorded / budget) * 100, 100) : 0
  })

  return { remaining, progress }
}
