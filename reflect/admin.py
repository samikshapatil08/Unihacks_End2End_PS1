from django.contrib import admin
from .models import (
    Organization,
    UserProfile,
    Post,
    Comment,
    AIFeedback,
    AudioPost,
    AIPersonaAnalysis,
    PersonaChatMessage,
)

admin.site.register(Organization)
admin.site.register(UserProfile)
admin.site.register(Post)
admin.site.register(Comment)
admin.site.register(AIFeedback)
admin.site.register(AudioPost)
admin.site.register(AIPersonaAnalysis)
admin.site.register(PersonaChatMessage)