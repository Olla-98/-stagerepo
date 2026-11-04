export type ProjectStatus = 'Actief' | 'On hold' | 'Afgerond'

export interface ProjectPhase {
  name: string
  hours: number
}

export interface Project {
  id: string
  name: string
  description: string
  status: ProjectStatus
  budget: number
  recorded: number
  updatedAt: string
  phases: ProjectPhase[]
}

export interface UserProfile {
  name: string | null
  email: string
}
