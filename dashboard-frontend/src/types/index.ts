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
  id: number
  name: string | null
  email: string
  simplicate_organization_id?: string | number | null
}
