import requests
import json
import os
from dotenv import load_dotenv
load_dotenv('key.env')

url = "https://api.chatanywhere.tech/v1/embeddings"

payload = json.dumps({
   "model": "text-embedding-ada-002",
   "input": "The food was delicious and the waiter..."
})
headers = {
   'Authorization': f'Bearer {os.getenv("OPENAI_API_KEY")}',
   'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)