import requests
import json

# 先登录获取 token
login_data = {"username": "test", "password": "test123"}

login_response = requests.post("http://localhost:8000/api/auth/login", json=login_data)
print("Login status:", login_response.status_code)

if login_response.status_code != 200:
    # 尝试注册
    register_data = {"username": "test", "password": "test123"}
    reg_response = requests.post(
        "http://localhost:8000/api/auth/register", json=register_data
    )
    print("Register status:", reg_response.status_code)
    if reg_response.status_code == 200:
        token = reg_response.json()["access_token"]
    else:
        print("Failed to register/login")
        exit(1)
else:
    token = login_response.json()["access_token"]

print(f"Token: {token[:20]}...")

# 测试流式接口
headers = {"Content-Type": "application/json", "Authorization": f"Bearer {token}"}

data = {"messages": [{"role": "user", "content": "你好，告诉我你今天做了什么"}]}

print("\nTesting stream API...")
response = requests.post(
    "http://localhost:8000/api/ai/chat/stream", json=data, headers=headers, stream=True
)

print(f"Status: {response.status_code}")
print(f"Content-Type: {response.headers.get('Content-Type')}")
print("\nStreaming response:")

for i, line in enumerate(response.iter_lines()):
    if line:
        decoded = line.decode("utf-8")
        print(f"Chunk {i}: {decoded[:100]}...")
        if i >= 5:  # 只显示前 5 个 chunk
            print("... (more chunks)")
            break
