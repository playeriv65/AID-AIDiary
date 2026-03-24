/**
 * E2E 测试全局设置
 * 在所有测试运行前执行一次，注入测试环境变量
 */

import { FullConfig } from '@playwright/test';
import { checkBackendHealth, verifyTestUserExists } from './fixtures/backend-fixture';

export default async function globalSetup(config: FullConfig): Promise<void> {
  console.log('\n=== E2E 测试全局设置 ===\n');

  const TEST_API_URL = 'http://127.0.0.1:8001';
  console.log(`测试后端地址：${TEST_API_URL}`);
  console.log(`测试用户：testuser / testpass123\n`);

  await checkBackendHealth(config);
  await verifyTestUserExists();

  console.log('\n✅ 全局设置完成\n');
}
