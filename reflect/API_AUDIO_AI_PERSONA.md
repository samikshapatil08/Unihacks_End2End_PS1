# Audio, AI Analysis & Persona Chat – API & Deployment

## New API Endpoints (all under `/api/`, JWT required)

### Audio discussions

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/audio/upload/` | Upload an audio file (multipart). Optional: `post`, `transcript`. |
| GET | `/api/audio/{id}/` | Get one audio post by id (org-scoped). |

### AI persona analysis

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/posts/{id}/ai-analysis/` | List AI analyses for post `id`. |
| POST | `/api/posts/{id}/ai-analysis/` | Create new AI analysis for post (optional body: `persona_name`). |

### Persona chat

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/persona-chat/send/` | Send a message and get AI reply. Body: `post_id`, `persona_name`, `message_text`. |
| GET | `/api/persona-chat/{post_id}/` | List chat messages for post. Optional query: `?persona_name=...`. |

All endpoints require `Authorization: Bearer <access_token>` and are scoped to the user’s organization.

---

## Example requests and responses

### 1. POST `/api/audio/upload/`

**Request** (multipart/form-data):

- `audio_file` (required): audio file
- `post` (optional): post id (must belong to user’s org)
- `transcript` (optional): text

**Response** (201):

```json
{
  "id": 1,
  "post": 5,
  "author": 2,
  "author_username": "alice",
  "audio_file": "/media/audio_discussions/2026/02/recording.mp3",
  "transcript": "",
  "created_at": "2026-02-14T12:00:00Z"
}
```

### 2. GET `/api/audio/{id}/`

**Response** (200): same shape as above (single object).

### 3. GET `/api/posts/{id}/ai-analysis/`

**Response** (200):

```json
[
  {
    "id": 1,
    "post": 3,
    "persona_name": "Analyst",
    "analysis_text": "The post raises a clear point about...",
    "created_at": "2026-02-14T12:00:00Z"
  }
]
```

### 4. POST `/api/posts/{id}/ai-analysis/`

**Request** (JSON, optional):

```json
{ "persona_name": "Mentor" }
```

**Response** (201): single analysis object, same fields as in the list above.

### 5. POST `/api/persona-chat/send/`

**Request** (JSON):

```json
{
  "post_id": 3,
  "persona_name": "Mentor",
  "message_text": "What do you think about the main idea?"
}
```

**Response** (200):

```json
{
  "messages": [
    {
      "id": 1,
      "post": 3,
      "persona_name": "Mentor",
      "sender_type": "user",
      "message_text": "What do you think about the main idea?",
      "created_at": "2026-02-14T12:00:00Z"
    },
    {
      "id": 2,
      "post": 3,
      "persona_name": "Mentor",
      "sender_type": "ai",
      "message_text": "The main idea is strong because...",
      "created_at": "2026-02-14T12:00:01Z"
    }
  ]
}
```

### 6. GET `/api/persona-chat/{post_id}/`

**Query**: `?persona_name=Mentor` (optional).

**Response** (200): `{ "messages": [ ... ] }` with same message shape as above.

---

## Database migrations (Supabase PostgreSQL)

1. Ensure dependencies are installed (including `requests`, `python-decouple` in `requirements.txt`).
2. From project root (where `manage.py` is):

   ```bash
   python manage.py migrate
   ```

3. New migration: `reflect/migrations/0005_audiopost_aipersonaanalysis_personachatmessage.py`.  
   It only **adds** tables; it does not alter or remove existing ones, so it is safe for production.

---

## Render deployment

- **Environment variables** (in Render dashboard):
  - `AI_API_KEY` or `OPENAI_API_KEY`: API key for the AI provider.
  - Optional: `AI_API_URL` (default: `https://api.openai.com/v1/chat/completions`), `AI_MODEL` (default: `gpt-4o-mini`).
  - Existing: `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`, `SECRET_KEY`, etc.

- **Media files**: Uploaded audio is stored under `MEDIA_ROOT`. On Render, the filesystem is ephemeral unless you use a persistent disk or external storage (e.g. S3). For production, consider configuring Django to use a cloud storage backend (e.g. `django-storages` + S3) and set `DEFAULT_FILE_STORAGE` and related env vars.

- **Run migrations**: In Render, set the build command so that migrations run (e.g. `python manage.py migrate --noinput`) before or as part of the start command, or run them manually once after deploy.

---

## Feed change (minimal)

The existing **GET `/api/feed/`** response now includes `id` for each post so the client can call:

- `GET/POST /api/posts/{id}/ai-analysis/`
- `GET /api/persona-chat/{post_id}/` and `POST /api/persona-chat/send/` with `post_id`.

No other feed fields or endpoints were changed.
