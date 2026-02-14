from django.contrib import admin
from .models import *

admin.site.register(Organization)
admin.site.register(UserProfile)
admin.site.register(Post)
admin.site.register(Comment)
admin.site.register(AIFeedback)