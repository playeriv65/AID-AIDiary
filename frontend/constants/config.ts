const ENVIRONMENTS = {
  production: {
    API_URL: 'http://127.0.0.1:8000/api',
    STATIC_URL: 'http://127.0.0.1:8000/static',
    AXIOS_TIMEOUT: 5000,
  },
  test: {
    API_URL: 'http://127.0.0.1:8001/api',
    STATIC_URL: 'http://127.0.0.1:8001/static',
    AXIOS_TIMEOUT: 5000,
  },
};

const ENV = (typeof process !== 'undefined' && process.env?.EXPO_PUBLIC_ENV) || 'production';

export const CONFIG = ENVIRONMENTS[ENV as keyof typeof ENVIRONMENTS] || ENVIRONMENTS.production;