import { ref } from 'vue'

export interface ProjectSummary {
  id: string
  name: string
  budget: number
  recorded: number
  remaining: number
}

export const projects = ref<ProjectSummary[]>([])
export const projectsLoading = ref(false)
export const projectsError = ref('')

export function clearProjectState() {
  projects.value = []
  projectsError.value = ''
}
