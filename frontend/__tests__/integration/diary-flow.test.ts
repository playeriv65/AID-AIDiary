const API_URL = 'http://127.0.0.1:8001/api';

function generateUUID(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

describe('Integration: Diary Flow', () => {
  let authToken: string;

  beforeAll(async () => {
    const loginResponse = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        username: 'testuser',
        password: 'testpass123',
      }),
    });

    if (!loginResponse.ok) {
      throw new Error('Failed to login for integration tests');
    }

    const loginData = await loginResponse.json();
    authToken = loginData.access_token;
  });

  describe('Authentication', () => {
    it('should connect to backend', async () => {
      const response = await fetch(API_URL.replace('/api', '/'));
      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(data.message).toContain('Welcome');
    });

    it('should login with valid credentials', async () => {
      const response = await fetch(`${API_URL}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          username: 'testuser',
          password: 'testpass123',
        }),
      });

      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(data.access_token).toBeDefined();
      expect(data.user).toBeDefined();
      expect(data.user.id).toBeDefined();
    });

    it('should reject invalid credentials', async () => {
      const response = await fetch(`${API_URL}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          username: 'testuser',
          password: 'wrongpassword',
        }),
      });

      expect(response.ok).toBe(false);
    });

    it('should reject request without token', async () => {
      const response = await fetch(`${API_URL}/entries`);
      expect(response.status).toBe(401);
    });

    it('should reject invalid token', async () => {
      const response = await fetch(`${API_URL}/entries`, {
        headers: {
          Authorization: 'Bearer invalid_token',
        },
      });
      expect(response.status).toBe(401);
    });
  });

  describe('Diary CRUD', () => {
    it('should get entries list', async () => {
      const response = await fetch(`${API_URL}/entries`, {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(Array.isArray(data)).toBe(true);
    });

    it('should create a new diary entry', async () => {
      const entryData = {
        id: generateUUID(),
        title: 'Integration Test Entry',
        content: 'This is a test diary entry created by integration tests.',
        category: 'work',
        weather: 'sunny',
      };

      const response = await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify(entryData),
      });

      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(data.title).toBe(entryData.title);
      expect(data.content).toBe(entryData.content);
      expect(data.id).toBe(entryData.id);
    });

    it('should get a single entry by id', async () => {
      const entryId = generateUUID();
      await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          id: entryId,
          title: 'Entry to Fetch',
          content: 'Content to fetch',
        }),
      });

      const getResponse = await fetch(`${API_URL}/entries/${entryId}`, {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(getResponse.ok).toBe(true);
      const entry = await getResponse.json();
      expect(entry.id).toBe(entryId);
      expect(entry.title).toBe('Entry to Fetch');
    });

    it('should update an existing diary entry', async () => {
      const entryId = generateUUID();
      await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          id: entryId,
          title: 'Entry to Update',
          content: 'Original content',
        }),
      });

      const updateResponse = await fetch(`${API_URL}/entries/${entryId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          title: 'Updated Title',
          content: 'Updated content',
        }),
      });

      expect(updateResponse.ok).toBe(true);
      const updated = await updateResponse.json();
      expect(updated.title).toBe('Updated Title');
    });

    it('should delete a diary entry', async () => {
      const entryId = generateUUID();
      await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          id: entryId,
          title: 'Entry to Delete',
          content: 'Will be deleted',
        }),
      });

      const deleteResponse = await fetch(`${API_URL}/entries/${entryId}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(deleteResponse.ok).toBe(true);

      const getResponse = await fetch(`${API_URL}/entries/${entryId}`, {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(getResponse.status).toBe(404);
    });

    it('should search entries by keyword', async () => {
      const uniqueKeyword = `unique_${Date.now()}`;
      const entryId = generateUUID();

      await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          id: entryId,
          title: `Search Test ${uniqueKeyword}`,
          content: `Content with ${uniqueKeyword}`,
        }),
      });

      const searchResponse = await fetch(`${API_URL}/entries?search=${uniqueKeyword}`, {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(searchResponse.ok).toBe(true);
      const results = await searchResponse.json();
      expect(Array.isArray(results)).toBe(true);
      expect(results.some((e: any) => e.id === entryId)).toBe(true);
    });
  });

  describe('AI Chat', () => {
    it('should create a conversation', async () => {
      const response = await fetch(`${API_URL}/conversations`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${authToken}`,
        },
        body: JSON.stringify({
          message: 'Hello, this is a test message',
        }),
      });

      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(data.id).toBeDefined();
    });

    it('should list conversations', async () => {
      const response = await fetch(`${API_URL}/conversations`, {
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
      });

      expect(response.ok).toBe(true);
      const data = await response.json();
      expect(Array.isArray(data)).toBe(true);
    });
  });
});
