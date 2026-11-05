import { ref } from 'vue'
import type { ProjectHours } from '../types'

export interface ProjectSummary extends ProjectHours {
  id: string
  name: string
  remaining: number
}

export const projects = ref<ProjectSummary[]>([])
export const projectsLoading = ref(false)
export const projectsError = ref('')

export function clearProjectState() {
  projects.value = []
  projectsError.value = ''
}
