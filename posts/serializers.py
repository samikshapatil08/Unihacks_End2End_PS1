from rest_framework import serializers
from .models import Post, Comment
from accounts.serializers import UserSerializer

class CommentSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = Comment
        fields = ('id', 'post', 'user', 'content', 'created_at')
        read_only_fields = ('user',)

class PostSerializer(serializers.ModelSerializer):
    author = UserSerializer(read_only=True)
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Post
        fields = ('id', 'author', 'organization', 'title', 'content', 'tag', 'created_at', 'comments')
        read_only_fields = ('author', 'organization')
