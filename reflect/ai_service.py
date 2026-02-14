"""
AI service for persona analysis and persona chat.
Uses environment variable AI_API_KEY (e.g. OpenAI). No credentials in code.
"""
import os
import json

# Optional: use requests if available for HTTP calls
try:
    import requests
    HAS_REQUESTS = True
except ImportError:
    HAS_REQUESTS = False


def get_ai_api_key():
    """Read API key from environment. Set AI_API_KEY on Render."""
    return os.environ.get('AI_API_KEY') or os.environ.get('OPENAI_API_KEY')


def call_ai_completion(messages, max_tokens=500):
    """
    Call an OpenAI-compatible chat API.
    Expects AI_API_KEY or OPENAI_API_KEY in environment.
    Returns (content_string, error_message). One will be None.
    """
    api_key = get_ai_api_key()
    if not api_key:
        return None, "AI_API_KEY (or OPENAI_API_KEY) not configured"

    if not HAS_REQUESTS:
        return None, "requests package required for AI calls (add to requirements.txt)"

    url = os.environ.get('AI_API_URL', 'https://api.openai.com/v1/chat/completions')
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json',
    }
    payload = {
        'model': os.environ.get('AI_MODEL', 'gpt-4o-mini'),
        'messages': messages,
        'max_tokens': max_tokens,
    }

    try:
        resp = requests.post(url, headers=headers, json=payload, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        content = data.get('choices', [{}])[0].get('message', {}).get('content', '')
        return (content.strip() or None), None
    except requests.RequestException as e:
        return None, str(e)
    except (IndexError, KeyError, json.JSONDecodeError) as e:
        return None, str(e)


def generate_persona_analysis(post_content, persona_name="Analyst"):
    """
    Generate persona analysis for a post. Returns (analysis_text, error).
    """
    messages = [
        {
            "role": "system",
            "content": f"You are a {persona_name}. Provide a brief, constructive analysis of the following post in 2-4 sentences.",
        },
        {"role": "user", "content": post_content or "(No text content)"},
    ]
    content, err = call_ai_completion(messages, max_tokens=300)
    return content, err


def generate_persona_chat_reply(post_content, persona_name, conversation_history, user_message):
    """
    Generate AI reply for persona chat given post context and conversation.
    conversation_history: list of {"sender_type": "user"|"ai", "message_text": "..."}
    Returns (reply_text, error).
    """
    context = f"Post content: {post_content or '(No content)'}"
    messages = [
        {
            "role": "system",
            "content": f"You are the persona '{persona_name}' discussing the post. Stay in character. Reply briefly (1-3 sentences). Context: {context}",
        },
    ]
    for msg in conversation_history[-10:]:  # last 10 messages
        role = "user" if msg.get("sender_type") == "user" else "assistant"
        messages.append({"role": role, "content": msg.get("message_text", "")})
    messages.append({"role": "user", "content": user_message})

    return call_ai_completion(messages, max_tokens=200)
