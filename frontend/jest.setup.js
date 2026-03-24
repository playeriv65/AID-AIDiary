// Just import testing library, let jest-expo handle RN mocks
require('@testing-library/react-native');

const { Platform } = require('react-native');
Platform.OS = 'web';

// Mock localStorage for web tests
const localStorageMock = {
  getItem: jest.fn(() => null),
  setItem: jest.fn(),
  removeItem: jest.fn(),
  clear: jest.fn(),
  length: 0,
  key: jest.fn(() => null),
};
global.localStorage = localStorageMock;
global.sessionStorage = localStorageMock;

// Mock window for web tests
global.window = {
  __EXPO_PUBLIC_ENV__: 'test',
  matchMedia: jest.fn(() => ({
    matches: false,
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    addListener: jest.fn(),
    removeListener: jest.fn(),
  })),
};

// Mock expo-router to prevent navigation issues in Jest
jest.mock('expo-router', () => ({
  useRouter: jest.fn(() => ({
    push: jest.fn(),
    replace: jest.fn(),
    back: jest.fn(),
    navigate: jest.fn(),
  })),
  usePathname: jest.fn(() => '/'),
  useSearchParams: jest.fn(() => new URLSearchParams()),
  useGlobalSearchParams: jest.fn(() => ({})),
  useLocalSearchParams: jest.fn(() => ({})),
  Link: 'Link',
  Stack: { Screen: 'Screen' },
  Tabs: { Screen: 'Screen' },
  router: {
    push: jest.fn(),
    replace: jest.fn(),
    back: jest.fn(),
    navigate: jest.fn(),
  },
}));

// Mock axios to prevent platform detection issues in Jest
jest.mock('axios', () => ({
  create: jest.fn(() => ({
    get: jest.fn(() => Promise.resolve({ data: {} })),
    post: jest.fn(() => Promise.resolve({ data: {} })),
    put: jest.fn(() => Promise.resolve({ data: {} })),
    delete: jest.fn(() => Promise.resolve({ data: {} })),
    patch: jest.fn(() => Promise.resolve({ data: {} })),
    interceptors: {
      request: { use: jest.fn() },
      response: { use: jest.fn() },
    },
  })),
  get: jest.fn(() => Promise.resolve({ data: {} })),
  post: jest.fn(() => Promise.resolve({ data: {} })),
  put: jest.fn(() => Promise.resolve({ data: {} })),
  delete: jest.fn(() => Promise.resolve({ data: {} })),
  patch: jest.fn(() => Promise.resolve({ data: {} })),
  isAxiosError: jest.fn(() => false),
  default: jest.fn(() => Promise.resolve({ data: {} })),
}));

// Mock document for web platform tests
global.document = {
  createElement: jest.fn(() => ({
    textContent: '',
    id: '',
  })),
  head: {
    appendChild: jest.fn(),
    removeChild: jest.fn(),
  },
  getElementById: jest.fn(() => null),
  addEventListener: jest.fn(),
  removeEventListener: jest.fn(),
};

// Mock AsyncStorage (required by AppContext)
jest.mock('@react-native-async-storage/async-storage', () => ({
  setItem: jest.fn(() => Promise.resolve()),
  getItem: jest.fn(() => Promise.resolve(null)),
  removeItem: jest.fn(() => Promise.resolve()),
  multiSet: jest.fn(() => Promise.resolve()),
  multiGet: jest.fn(() => Promise.resolve([])),
  multiRemove: jest.fn(() => Promise.resolve()),
  getAllKeys: jest.fn(() => Promise.resolve([])),
  flushGetRequests: jest.fn(() => Promise.resolve()),
}));

// Mock Colors to provide all theme values
jest.mock('@/constants/theme', () => ({
  Colors: {
    light: {
      background: '#FFFFFF',
      text: '#000000',
      cardBackground: '#F5F5F7',
      icon: '#6B7280',
      primary: '#02BFB8',
      accent: '#02BFB8',
    },
    dark: {
      background: '#1A1C1E',
      text: '#FFFFFF',
      cardBackground: '#2A2C30',
      icon: '#9CA3AF',
      primary: '#02BFB8',
      accent: '#02BFB8',
    },
  },
  FontSizes: {
    xs: 12,
    sm: 14,
    md: 16,
    lg: 18,
    xl: 20,
    xxl: 24,
    xxxl: 28,
  },
  FontWeights: {
    normal: 'normal',
    medium: '500',
    semibold: '600',
    bold: '700',
  },
  LineHeights: {
    relaxed: 1.75,
    normal: 1.5,
    tight: 1.25,
  },
  Spacing: {
    contentHorizontal: 40,
    contentHorizontalMobile: 16,
    cardPadding: 16,
    sectionGap: 24,
    elementGap: 12,
  },
}));

// Silence console noise in tests (optional)
global.console = {
  ...console,
  log: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};
