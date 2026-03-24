/**
 * 后端健康检查 Fixture
 * 确保测试后端在开始 E2E 测试前可用
 */

import { FullConfig } from '@playwright/test';

export async function checkBackendHealth(config: FullConfig): Promise<void> {
  const TEST_API_URL = 'http://127.0.0.1:8001';
  const HEALTH_ENDPOINT = '/';
  const MAX_RETRIES = 3;
  const RETRY_DELAY = 2000;

  console.log(`🔍 检查测试后端健康状态 (${TEST_API_URL})...`);

  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    try {
      const response = await fetch(`${TEST_API_URL}${HEALTH_ENDPOINT}`, {
        method: 'GET',
        signal: AbortSignal.timeout(3000),
      });

      if (response.ok) {
        const data = await response.json();
        console.log(
          `✅ 测试后端健康检查通过 (${response.status}): ${data.message || data.status || 'OK'}`
        );
        return;
      } else {
        console.warn(`⚠️  后端返回非 200 状态码: ${response.status}`);
      }
    } catch (error: any) {
      console.warn(`⚠️  健康检查失败 (尝试 ${attempt}/${MAX_RETRIES}): ${error.message}`);

      if (attempt < MAX_RETRIES) {
        console.log(`⏱️  ${RETRY_DELAY}ms 后重试...`);
        await new Promise((resolve) => setTimeout(resolve, RETRY_DELAY));
      }
    }
  }

  // 所有重试失败
  const errorMessage = [
    '❌ 测试后端健康检查失败',
    '',
    `测试后端未在 ${TEST_API_URL} 运行`,
    '',
    '解决方案:',
    '1. 启动测试后端：cd backend && docker compose -f docker-compose.test.yml up -d',
    '2. 验证后端状态：curl http://127.0.0.1:8001/',
    '3. 检查 Docker 日志：docker compose -f docker-compose.test.yml logs backend',
    '',
  ].join('\n');

  console.error(errorMessage);
  throw new Error(errorMessage);
}

export async function verifyTestUserExists(): Promise<boolean> {
  try {
    const response = await fetch('http://127.0.0.1:8001/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username: 'testuser', password: 'testpass123' }),
    });

    if (response.ok) {
      console.log('✅ 测试用户 testuser 可用');
      return true;
    } else {
      console.warn('⚠️  测试用户 testuser 登录失败');
      return false;
    }
  } catch (error: any) {
    console.warn(`⚠️  无法验证测试用户：${error.message}`);
    return false;
  }
}
