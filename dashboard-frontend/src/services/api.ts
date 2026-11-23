export class ApiError extends Error {
  readonly status: number
  readonly errorCodes: string[]

  constructor(
    message: string,
    status: number,
    errorCodes: string[] = [],
  ) {
    super(message)
    this.name = 'ApiError'
    this.status = status
    this.errorCodes = errorCodes
  }
}

interface ApiErrorResponse {
  error?: string
  errors?: string[]
  error_codes?: string[]
}

interface ApiRequestOptions extends RequestInit {
  token?: string
}

export async function apiRequest<T>(
  path: string,
  { token, headers, ...options }: ApiRequestOptions = {},
): Promise<T> {
  const response = await fetch(`/api${path}`, {
    ...options,
    headers: {
      ...(options.body ? { 'Content-Type': 'application/json' } : {}),
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
  })

  if (response.status === 401 && token) {
    window.dispatchEvent(new Event('nerdboard:unauthorized'))
  }

  if (!response.ok) {
    let message = `Request failed (${response.status})`
    let errorCodes: string[] = []

    try {
      const body = (await response.json()) as ApiErrorResponse
      message = body.error ?? body.errors?.join(', ') ?? message
      errorCodes = body.error_codes ?? []
    } catch {
      // Keep the HTTP status message when the server does not return JSON.
    }

    throw new ApiError(message, response.status, errorCodes)
  }

  if (response.status === 204) {
    return undefined as T
  }

  return (await response.json()) as T
}
