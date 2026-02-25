module.exports = {
  preset: 'jest-expo',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testMatch: ['**/__tests__/**/*.test.[jt]s?(x)'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
    '^@adheil_gupta/react-native-latex-renderer$':
      '<rootDir>/__mocks__/@adheil_gupta-react-native-latex-renderer.js',
  },
};
