from django.db import models
from django.contrib.auth.models import User

class Organization(models.Model):
    name = models.CharField(max_length=30)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
    

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    organization = models.ForeignKey(
        Organization,
        on_delete=models.CASCADE
    )

    def __str__(self):
        return self.user.username
    
class Post(models.Model):
    POST_TYPES = (
        ('text', 'Text'),
        ('audio', 'Audio'),
    )

    author = models.ForeignKey(User, on_delete=models.CASCADE)
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    post_type = models.CharField(max_length=20, choices=POST_TYPES)
    content = models.TextField(blank=True)
    audio_file = models.FileField(upload_to='audio/', blank=True, null=True)
    tags = models.CharField(max_length=255, blank=True, default='')  # comma-separated for filter
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.author.username} - {self.post_type}"

class Comment(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

class AIFeedback(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    persona = models.CharField(max_length=100)
    feedback = models.TextField()


class AudioPost(models.Model):
    """Audio discussion attached to an optional post."""
    post = models.ForeignKey(
        Post, on_delete=models.CASCADE, null=True, blank=True,
        related_name='audio_posts'
    )
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    audio_file = models.FileField(upload_to='audio_discussions/%Y/%m/')
    transcript = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class AIPersonaAnalysis(models.Model):
    """AI-generated persona analysis for a post."""
    post = models.ForeignKey(
        Post, on_delete=models.CASCADE, related_name='ai_persona_analyses'
    )
    persona_name = models.CharField(max_length=100)
    analysis_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)


class PersonaChatMessage(models.Model):
    SENDER_USER = 'user'
    SENDER_AI = 'ai'
    SENDER_CHOICES = [
        (SENDER_USER, 'user'),
        (SENDER_AI, 'ai'),
    ]
    post = models.ForeignKey(
        Post, on_delete=models.CASCADE, related_name='persona_chat_messages'
    )
    persona_name = models.CharField(max_length=100)
    sender_type = models.CharField(max_length=10, choices=SENDER_CHOICES)
    message_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)