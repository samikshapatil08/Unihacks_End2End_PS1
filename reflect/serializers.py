from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Organization, UserProfile, Post, Comment, AIFeedback, PersonaChat

class OrganizationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Organization
        fields = ['id', 'name', 'created_at']

class UserSerializer(serializers.ModelSerializer):
    organization = serializers.CharField(source='userprofile.organization.name', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'organization']

class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    organization = OrganizationSerializer(read_only=True)

    class Meta:
        model = UserProfile
        fields = ['id', 'user', 'organization']

class CommentSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Comment
        fields = ['id', 'post', 'user', 'text', 'created_at']
        read_only_fields = ['user', 'created_at', 'post']

class AIFeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = AIFeedback
        fields = ['id', 'post', 'persona', 'feedback']

class PersonaChatSerializer(serializers.ModelSerializer):
    class Meta:
        model = PersonaChat
        fields = ['id', 'post', 'user', 'persona', 'message', 'is_from_ai', 'created_at']
        read_only_fields = ['user', 'created_at', 'post']

class PostSerializer(serializers.ModelSerializer):
    author = serializers.StringRelatedField(read_only=True)
    organization = serializers.StringRelatedField(read_only=True)
    comments = CommentSerializer(source='comment_set', many=True, read_only=True)
    ai_feedback = AIFeedbackSerializer(source='aifeedback_set', many=True, read_only=True)
    audio_file = serializers.FileField(required=False)

    class Meta:
        model = Post
        fields = ['id', 'author', 'organization', 'post_type', 'content', 'audio_file', 'created_at', 'comments', 'ai_feedback']
        read_only_fields = ['author', 'organization', 'created_at']

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    organization_name = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ['username', 'password', 'organization_name']

    def create(self, validated_data):
        org_name = validated_data.pop('organization_name', 'Default Org')
        user = User.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password']
        )
        
        # Get or create organization (simplified logic for now)
        org, _ = Organization.objects.get_or_create(name=org_name)
        
        UserProfile.objects.create(user=user, organization=org)
        return user
