from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from rest_framework_simplejwt.views import TokenObtainPairView
from .views import (
    feed,
    create_post,
    register,
    auth_register,
    auth_me,
    organization_me,
    organization_create,
    post_list,
    post_create,
    post_detail,
    comment_list,
    comment_create,
    audio_upload,
    audio_detail,
    post_audio_list,
    ai_analysis,
    persona_chat_send,
    persona_chat_list,
    post_search,
    post_filter,
    profile_me,
    profile_update,
)

urlpatterns = [
    # Legacy (keep for backward compatibility)
    path('feed/', feed),
    path('create-post/', create_post),
    path('register/', register),
    # Auth
    path('auth/register/', auth_register),
    path('auth/login/', TokenObtainPairView.as_view()),
    path('auth/me/', auth_me),
    # Organization
    path('organization/me/', organization_me),
    path('organization/create/', organization_create),
    # Posts (REST)
    path('posts/', post_list),
    path('posts/create/', post_create),
    path('posts/search/', post_search),
    path('posts/filter/', post_filter),
    path('posts/<int:pk>/', post_detail),
    path('posts/<int:post_id>/comments/', comment_list),
    path('posts/<int:post_id>/comments/create/', comment_create),
    path('posts/<int:post_id>/audio/', post_audio_list),
    path('posts/<int:post_id>/ai-analysis/', ai_analysis),
    # Audio discussions (standalone)
    path('audio/upload/', audio_upload),
    path('audio/<int:pk>/', audio_detail),
    # Persona chat
    path('persona-chat/send/', persona_chat_send),
    path('persona-chat/<int:post_id>/', persona_chat_list),
    # Profile
    path('profile/', profile_me),
    path('profile/update/', profile_update),
]

if settings.DEBUG and getattr(settings, 'MEDIA_ROOT', None):
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
