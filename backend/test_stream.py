import os
import json
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY"),
    base_url="https://open.bigmodel.cn/api/paas/v4/",
)

print("Testing streaming response...\n")

response = client.chat.completions.create(
    model="glm-4-flash",
    messages=[
        {"role": "system", "content": "你是一个友好的日记助手"},
        {"role": "user", "content": "你好，请告诉我你今天做了什么"},
    ],
    stream=True,
)

print("Response chunks:")
for i, chunk in enumerate(response):
    if chunk.choices and len(chunk.choices) > 0:
        delta = chunk.choices[0].delta
        if delta and delta.content:
            content = delta.content
            print(f"[{i}] {content}")

print("\nDone!")
