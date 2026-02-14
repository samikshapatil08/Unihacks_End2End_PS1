"""
Serializers for all API responses and requests.
"""
from rest_framework import serializers
from django.contrib.auth.models import User
from .models import (
    Organization,
    UserProfile,
    Post,
    Comment,
    AudioPost,
    AIPersonaAnalysis,
    PersonaChatMessage,
)


# --- Auth & profile ---

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']
        read_only_fields = fields


class OrganizationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ['id', 'name', 'created_at']


class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    organization = OrganizationSerializer(read_only=True)

    class Meta:
        model = UserProfile
        fields = ['id', 'user', 'organization']


# --- Posts & comments ---

class CommentSerializer(serializers.ModelSerializer):
    user_username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Comment
        fields = ['id', 'post', 'user', 'user_username', 'text', 'created_at']
        read_only_fields = ['id', 'post', 'user', 'created_at']


class CommentCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['text']


class PostSerializer(serializers.ModelSerializer):
    author_username = serializers.CharField(source='author.username', read_only=True)
    comments = CommentSerializer(source='comment_set', many=True, read_only=True)

    class Meta:
        model = Post
        fields = [
            'id', 'author', 'author_username', 'organization',
            'post_type', 'content', 'audio_file', 'tags', 'created_at',
            'comments',
        ]
        read_only_fields = ['id', 'author', 'organization', 'created_at']


class PostListSerializer(serializers.ModelSerializer):
    author_username = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = Post
        fields = [
            'id', 'author', 'author_username', 'post_type',
            'content', 'tags', 'created_at',
        ]


class PostCreateUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['post_type', 'content', 'tags']


# --- Audio, AI, persona chat ---

class AudioPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = AudioPost
        fields = [
            'id', 'post', 'author', 'organization',
            'audio_file', 'transcript', 'created_at',
        ]
        read_only_fields = ['id', 'author', 'organization', 'created_at']


class AudioPostListSerializer(serializers.ModelSerializer):
    """Read-only serializer for GET responses (includes post id)."""
    author_username = serializers.CharField(source='author.username', read_only=True)

    class Meta:
        model = AudioPost
        fields = [
            'id', 'post', 'author', 'author_username',
            'audio_file', 'transcript', 'created_at',
        ]


class AIPersonaAnalysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = AIPersonaAnalysis
        fields = ['id', 'post', 'persona_name', 'analysis_text', 'created_at']
        read_only_fields = ['id', 'post', 'created_at']


class PersonaChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = PersonaChatMessage
        fields = [
            'id', 'post', 'persona_name', 'sender_type',
            'message_text', 'created_at',
        ]
        read_only_fields = ['id', 'created_at']
