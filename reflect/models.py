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