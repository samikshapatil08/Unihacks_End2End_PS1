from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AIPersonaAnalysisViewSet, PersonaChatMessageViewSet

# We can use routers or manual paths. Since the requested paths are specific:
# POST   /api/posts/{id}/ai-analysis/
# GET    /api/posts/{id}/ai-analysis/
# POST   /api/persona-chat/
# GET    /api/persona-chat/{post_id}/

urlpatterns = [
    # Adjusting map logic. Since viewset is model-based, we probably want list/create mapped.
    # But filtering by post_id is key.

    # Analysis for a post
    path('posts/<int:post_pk>/ai-analysis/', AIPersonaAnalysisViewSet.as_view({'get': 'list', 'post': 'create'}), name='post-ai-analysis'),
    
    # Chat
    path('persona-chat/', PersonaChatMessageViewSet.as_view({'post': 'create'}), name='persona-chat-create'),
    path('persona-chat/<int:post_pk>/', PersonaChatMessageViewSet.as_view({'get': 'list'}), name='persona-chat-list'),
]
