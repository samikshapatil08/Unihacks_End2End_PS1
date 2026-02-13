from django.urls import path
from .views import *

urlpatterns = [
    path('feed/', feed),
    path('create-post/', create_post),
]
