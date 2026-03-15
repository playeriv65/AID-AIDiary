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

declare global {
  interface Window {
    __EXPO_PUBLIC_ENV__?: string;
  }
}

function detectEnvironment(): string {
  if (typeof window !== 'undefined') {
    const windowEnv = window.__EXPO_PUBLIC_ENV__;
    if (windowEnv) return windowEnv;

    const storedEnv = localStorage.getItem('__EXPO_PUBLIC_ENV__');
    if (storedEnv) return storedEnv;
  }

  if (typeof process !== 'undefined' && process.env?.EXPO_PUBLIC_ENV) {
    return process.env.EXPO_PUBLIC_ENV;
  }

  return 'production';
}

const ENV = detectEnvironment();

export const CONFIG = ENVIRONMENTS[ENV as keyof typeof ENVIRONMENTS] || ENVIRONMENTS.production;
