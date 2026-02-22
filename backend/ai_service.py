import os
from openai import AsyncOpenAI
from dotenv import load_dotenv

# Load environment variables, particularly OPENAI_API_KEY
load_dotenv()

# Initialize the OpenAI async client
# You can change the base_url here if you want to use a compatible provider like DeepSeek
client = AsyncOpenAI(
    api_key=os.getenv("OPENAI_API_KEY", "your-fallback-key-here"),
    # base_url="https://api.deepseek.com/v1" # Uncomment and change if needed
)

async def generate_polished_entry(content: str) -> dict:
    """
    Takes the raw user journal content and uses an LLM to polish the text and extract mood tags.
    Returns a dictionary containing the polished_text and tags.
    """
    system_prompt = """
    You are an exquisite, empathetic journaling assistant. 
    The user is providing a rough draft of their diary entry. 
    Your job is to:
    1. Beautifully polish their text without changing the original meaning or facts. Fix grammar, enhance vocabulary slightly to make it flow better. Keep the tone intimate and personal.
    2. Suggest 1 to 3 relevant mood or topic tags based on the entry (e.g., 'Grateful', 'Anxious', 'Work', 'Family').
    
    Respond STRICTLY in JSON format as follows:
    {
        "polished_text": "The beautifully rewritten diary entry.",
        "tags": ["Tag1", "Tag2"]
    }
    """
    
    try:
        response = await client.chat.completions.create(
            model="gpt-4o-mini", # You can change this to your preferred model
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": f"Here is my rough draft:\n\n{content}"}
            ],
            response_format={ "type": "json_object" }
        )
        
        result_content = response.choices[0].message.content
        import json
        parsed_result = json.loads(result_content)
        
        return {
            "polished_text": parsed_result.get("polished_text", content),
            "tags": parsed_result.get("tags", [])
        }
        
    except Exception as e:
        print(f"Error during AI generation: {e}")
        # Fallback in case of failure
        return {
            "polished_text": content,
            "tags": ["Error"]
        }
