from rest_framework import viewsets, permissions
from .models import AIPersonaAnalysis, PersonaChatMessage
from .serializers import AIPersonaAnalysisSerializer, PersonaChatMessageSerializer
from posts.models import Post

class AIPersonaAnalysisViewSet(viewsets.ModelViewSet):
    serializer_class = AIPersonaAnalysisSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.organization:
             return AIPersonaAnalysis.objects.filter(post__organization=user.organization)
        return AIPersonaAnalysis.objects.none()
    
    def perform_create(self, serializer):
         # Verify post belongs to user org
        post = serializer.validated_data['post']
        if post.organization != self.request.user.organization:
             from rest_framework.exceptions import PermissionDenied
             raise PermissionDenied("Cannot analyze post from another organization")
        serializer.save()

class PersonaChatMessageViewSet(viewsets.ModelViewSet):
    serializer_class = PersonaChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.organization:
             return PersonaChatMessage.objects.filter(post__organization=user.organization)
        return PersonaChatMessage.objects.none()

    def perform_create(self, serializer):
         # Verify post belongs to user org
        post = serializer.validated_data['post']
        if post.organization != self.request.user.organization:
             from rest_framework.exceptions import PermissionDenied
             raise PermissionDenied("Cannot add message to post from another organization")
        serializer.save()
