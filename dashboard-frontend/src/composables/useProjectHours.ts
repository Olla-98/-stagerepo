import { computed, type Ref } from 'vue'
import type { Project } from '../types'

export function useProjectHours(project: Ref<Project>) {
  const remaining = computed(
    () => project.value.budget - project.value.recorded,
  )

  const progress = computed(() => {
    const { budget, recorded } = project.value

    if (budget === 0) {
      return 0
    }

    return Math.min((recorded / budget) * 100, 100)
  })

  return { remaining, progress }
}
