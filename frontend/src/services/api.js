import axios from 'axios'

const http = axios.create({
  baseURL: '/api',
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
  },
  withCredentials: true,
  withXSRFToken: true,
  xsrfCookieName: 'XSRF-TOKEN',
  xsrfHeaderName: 'X-XSRF-TOKEN',
})

export async function initCsrf() {
  await axios.get('/sanctum/csrf-cookie', {
    withCredentials: true,
  })
}

export async function login(email, password) {
  await initCsrf()

  const response = await http.post('/v1/auth/login', {
    email,
    password,
  })

  return response.data
}

export async function getCurrentUser() {
  const response = await http.get('/v1/auth/me')

  return response.data
}

export async function logout() {
  const response = await http.post('/v1/auth/logout')

  return response.data
}

export async function checkAdmin() {
  const response = await http.get('/v1/admin/check')

  return response.data
}

export async function getMuseumSpaces() {
  const response = await http.get('/v1/spaces')

  return response.data
}

export async function getTours() {
  const response = await http.get('/v1/tours')

  return response.data
}

export default http
