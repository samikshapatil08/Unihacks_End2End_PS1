from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AudioPostViewSet

router = DefaultRouter()
router.register(r'audio', AudioPostViewSet, basename='audio')

urlpatterns = [
    path('', include(router.urls)),
    path('audio/upload/', AudioPostViewSet.as_view({'post': 'create'}), name='audio-upload'),
]
