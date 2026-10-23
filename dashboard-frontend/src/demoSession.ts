import { computed, ref } from 'vue'
import type { UserProfile } from './types'

const userKey = 'nerdboard-demo-user'

function readStoredUser(): UserProfile | null {
  const name = sessionStorage.getItem(`${userKey}-name`)
  const email = sessionStorage.getItem(`${userKey}-email`)

  if (name && email) {
    return { name, email }
  }

  sessionStorage.removeItem(`${userKey}-name`)
  sessionStorage.removeItem(`${userKey}-email`)
  return null
}

const currentUser = ref<UserProfile | null>(readStoredUser())
const user = computed(() => currentUser.value)
export const isDemoSession = computed(() => currentUser.value !== null)

export function useDemoSession() {
  function startDemoSession(email: string, name?: string) {
    const nextUser = {
      name: name?.trim() || email.split('@')[0] || 'Klant',
      email,
    }

    sessionStorage.setItem(`${userKey}-name`, nextUser.name)
    sessionStorage.setItem(`${userKey}-email`, nextUser.email)
    currentUser.value = nextUser
  }

  function endDemoSession() {
    sessionStorage.removeItem(`${userKey}-name`)
    sessionStorage.removeItem(`${userKey}-email`)
    currentUser.value = null
  }

  return { user, isDemoSession, startDemoSession, endDemoSession }
}
