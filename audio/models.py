from django.db import models
from django.conf import settings
from organizations.models import Organization

class AudioPost(models.Model):
    author = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='audio_posts')
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE, related_name='audio_posts')
    audio_file = models.FileField(upload_to='audio_recordings/')
    transcript = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Audio by {self.author.username} at {self.created_at}"
