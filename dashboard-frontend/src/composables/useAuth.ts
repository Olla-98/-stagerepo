import { computed, ref } from 'vue'
import { ApiError, apiRequest } from '../services/api'
import type { UserProfile } from '../types'

const tokenKey = 'nerdboard-auth-token'
const storedToken = sessionStorage.getItem(tokenKey)
const accessToken = ref<string | null>(storedToken)
const currentUser = ref<UserProfile | null>(null)
let sessionChecked = false
let restorePromise: Promise<boolean> | null = null

export const isAuthenticated = computed(() => accessToken.value !== null && currentUser.value !== null)

function saveToken(token: string) {
  sessionStorage.setItem(tokenKey, token)
  accessToken.value = token
  sessionChecked = false
}

function clearSession() {
  sessionStorage.removeItem(tokenKey)
  accessToken.value = null
  currentUser.value = null
  sessionChecked = true
}

window.addEventListener('nerdboard:unauthorized', clearSession)

export function useAuth() {
  async function restoreSession(): Promise<boolean> {
    if (!accessToken.value) {
      currentUser.value = null
      sessionChecked = true
      return false
    }

    if (sessionChecked && currentUser.value) {
      return true
    }

    if (!restorePromise) {
      restorePromise = apiRequest<UserProfile>('/me', { token: accessToken.value })
        .then((user) => {
          currentUser.value = user
          sessionChecked = true
          return true
        })
        .catch((error: unknown) => {
          if (error instanceof ApiError && error.status === 401) {
            clearSession()
            return false
          }

          throw error
        })
        .finally(() => {
          restorePromise = null
        })
    }

    return restorePromise
  }

  async function login(email: string, password: string) {
    const result = await apiRequest<{ token: string }>('/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    })
    saveToken(result.token)
    await restoreSession()
  }

  async function register(name: string, email: string, password: string) {
    const result = await apiRequest<{ token: string; user: UserProfile }>('/users', {
      method: 'POST',
      body: JSON.stringify({ user: { name, email, password } }),
    })
    saveToken(result.token)
    currentUser.value = result.user
    sessionChecked = true
  }

  async function logout() {
    const token = accessToken.value

    try {
      if (token) {
        await apiRequest<void>('/logout', { method: 'DELETE', token })
      }
    } finally {
      clearSession()
    }
  }

  return {
    user: computed(() => currentUser.value),
    token: computed(() => accessToken.value),
    isAuthenticated,
    restoreSession,
    login,
    register,
    logout,
  }
}
