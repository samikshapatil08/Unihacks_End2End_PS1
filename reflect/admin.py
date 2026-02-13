from django.contrib import admin
from .models import Organization, UserProfile, Post

admin.site.register(Organization)
admin.site.register(UserProfile)
admin.site.register(Post)