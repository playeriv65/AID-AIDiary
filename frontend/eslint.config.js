// https://docs.expo.dev/guides/using-eslint/
const { defineConfig } = require('eslint/config');
const expoConfig = require('eslint-config-expo/flat');

module.exports = defineConfig([
  expoConfig,
  {
    plugins: {
      'unused-imports': require('eslint-plugin-unused-imports'),
    },
    rules: {
      // 自动删除未使用的 import
      'unused-imports/no-unused-imports': 'warn',
      // 关闭原生的 no-unused-vars，由 TypeScript 处理
      'no-unused-vars': 'off',
      // Import 排序（让 unused-imports 处理）
      'sort-imports': [
        'error',
        {
          ignoreCase: false,
          ignoreDeclarationSort: true, // 不自动排序声明，由 unused-imports 或手动管理
          ignoreMemberSort: false,
          memberSyntaxSortOrder: ['none', 'all', 'multiple', 'single'],
          allowSeparatedGroups: true,
        },
      ],
    },
  },
  {
    // Jest 配置文件和测试文件
    files: [
      '**/__tests__/**/*',
      '**/*.test.*',
      '**/__mocks__/**/*',
      'jest.setup.js',
      'jest.config.js',
    ],
    languageOptions: {
      globals: {
        jest: 'readonly',
        describe: 'readonly',
        it: 'readonly',
        test: 'readonly',
        expect: 'readonly',
        beforeEach: 'readonly',
        afterEach: 'readonly',
        beforeAll: 'readonly',
        afterAll: 'readonly',
        mock: 'readonly',
      },
    },
  },
  {
    ignores: ['dist/*', 'node_modules/*', '.expo/*', 'coverage/*'],
  },
]);
