from django.urls import path
from .views import (
    register, me, my_organization,
    feed, create_post, post_detail, search_posts,
    get_comments, add_comment,
    ai_analysis, persona_chat, profile
)

urlpatterns = [
    # Auth
    path('auth/register/', register, name='register'),
    path('auth/me/', me, name='me'),

    # Organization
    path('organization/me/', my_organization, name='my-organization'),

    # Posts
    path('posts/', feed, name='feed'),
    path('posts/create/', create_post, name='create-post'),
    path('posts/search/', search_posts, name='search-posts'),
    path('posts/<int:pk>/', post_detail, name='post-detail'),

    # Comments
    path('posts/<int:post_id>/comments/', get_comments, name='get-comments'),
    path('posts/<int:post_id>/comments/create/', add_comment, name='add-comment'),

    # AI & Persona
    path('posts/<int:post_id>/ai-analysis/', ai_analysis, name='ai-analysis'),
    path('persona-chat/<int:post_id>/', persona_chat, name='persona-chat'),

    # Profile
    path('profile/', profile, name='profile'),
]
