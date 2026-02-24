// Just import testing library, let jest-expo handle RN mocks
require('@testing-library/react-native');

// Optional: silence console noise in tests
global.console = {
  ...console,
  log: jest.fn(),
  warn: jest.fn(),
  error: jest.fn(),
};
