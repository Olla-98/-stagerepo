import { ref } from 'vue'
import type { Project } from '../types'

export interface ProjectSummary extends Project {
  remaining: number
}

export const projects = ref<ProjectSummary[]>([])
export const projectsLoading = ref(false)
export const projectsError = ref('')
export const projectsLoaded = ref(false)

export function clearProjectState() {
  projects.value = []
  projectsError.value = ''
  projectsLoading.value = false
  projectsLoaded.value = false
}
