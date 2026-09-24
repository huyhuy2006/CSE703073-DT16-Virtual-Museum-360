import axios from 'axios';

const envBaseUrl = import.meta.env.VITE_API_BASE_URL || '/api';

const normalizedBaseUrl = envBaseUrl.endsWith('/v1')
  ? envBaseUrl
  : `${envBaseUrl.replace(/\/$/, '')}/v1`;

const api = axios.create({
  baseURL: normalizedBaseUrl,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('dt16_token');

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (
      error.response?.status === 401
      && !error.config?.url?.includes('/auth/login')
    ) {
      localStorage.removeItem('dt16_token');
      localStorage.removeItem('dt16_user');
    }

    return Promise.reject(error);
  }
);

export function getStoredUser() {
  const rawUser = localStorage.getItem('dt16_user');

  if (!rawUser) {
    return null;
  }

  try {
    return JSON.parse(rawUser);
  } catch {
    localStorage.removeItem('dt16_user');
    return null;
  }
}

export function clearAuth() {
  localStorage.removeItem('dt16_token');
  localStorage.removeItem('dt16_user');
}

export default api;
