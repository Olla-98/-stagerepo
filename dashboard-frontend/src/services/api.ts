export class ApiError extends Error {
  readonly status: number

  constructor(
    message: string,
    status: number,
  ) {
    super(message)
    this.name = 'ApiError'
    this.status = status
  }
}

interface ApiRequestOptions extends RequestInit {
  token?: string | null
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

  if (!response.ok) {
    let message = `Request failed (${response.status})`

    try {
      const body = (await response.json()) as { error?: string; errors?: string[] }
      message = body.error ?? body.errors?.join(', ') ?? message
    } catch {
      // Keep the HTTP status message when the server does not return JSON.
    }

    throw new ApiError(message, response.status)
  }

  if (response.status === 204) {
    return undefined as T
  }

  return (await response.json()) as T
}
