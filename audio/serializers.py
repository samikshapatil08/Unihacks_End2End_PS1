from rest_framework import serializers
from .models import AudioPost
from accounts.serializers import UserSerializer

class AudioPostSerializer(serializers.ModelSerializer):
    author = UserSerializer(read_only=True)

    class Meta:
        model = AudioPost
        fields = ('id', 'author', 'organization', 'audio_file', 'transcript', 'created_at')
        read_only_fields = ('author', 'organization')
