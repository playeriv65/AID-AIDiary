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
  // Check window global (set by Expo during SSR/hydration or Playwright)
  if (typeof window !== 'undefined') {
    const windowEnv = window.__EXPO_PUBLIC_ENV__;
    if (windowEnv) {
      console.log('[Config] Environment from window:', windowEnv);
      return windowEnv;
    }

    // Fallback to localStorage (for manual overrides)
    const storedEnv = localStorage.getItem('__EXPO_PUBLIC_ENV__');
    if (storedEnv) {
      console.log('[Config] Environment from localStorage:', storedEnv);
      return storedEnv;
    }

    // Check if running in Playwright test
    if ((window as any).__PLAYWRIGHT_TEST__) {
      console.log('[Config] Environment from Playwright flag');
      return 'test';
    }
  }

  // Check process.env (for Node.js/Playwright context)
  if (typeof process !== 'undefined' && process.env?.EXPO_PUBLIC_ENV) {
    return process.env.EXPO_PUBLIC_ENV;
  }

  // Default to test environment for E2E tests
  if (typeof process !== 'undefined' && process.env?.PLAYWRIGHT_TEST) {
    return 'test';
  }

  console.log('[Config] Environment default to production');
  return 'production';
}

const ENV = detectEnvironment();

export const CONFIG = ENVIRONMENTS[ENV as keyof typeof ENVIRONMENTS] || ENVIRONMENTS.production;
