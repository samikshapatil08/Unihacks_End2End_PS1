from rest_framework import viewsets, permissions, parsers
from .models import AudioPost
from .serializers import AudioPostSerializer

class AudioPostViewSet(viewsets.ModelViewSet):
    serializer_class = AudioPostSerializer
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [parsers.MultiPartParser, parsers.FormParser]

    def get_queryset(self):
        user = self.request.user
        if user.organization:
            return AudioPost.objects.filter(organization=user.organization).order_by('-created_at')
        return AudioPost.objects.none()

    def perform_create(self, serializer):
        serializer.save(author=self.request.user, organization=self.request.user.organization)
