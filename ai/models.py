from django.db import models
from posts.models import Post

class AIPersonaAnalysis(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='ai_analyses')
    persona_name = models.CharField(max_length=100)
    analysis_text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.persona_name} analysis on {self.post.title}"

class PersonaChatMessage(models.Model):
    SENDER_TYPE_CHOICES = (
        ('user', 'User'),
        ('ai', 'AI'),
    )

    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name='chat_messages')
    persona_name = models.CharField(max_length=100)
    sender_type = models.CharField(max_length=10, choices=SENDER_TYPE_CHOICES)
    message_text = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender_type} message in {self.persona_name} chat"
