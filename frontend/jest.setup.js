// Just import testing library, let jest-expo handle RN mocks
require('@testing-library/react-native');

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
}));

// Silence console noise in tests (optional)
global.console = {
  ...console,
  log: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};
