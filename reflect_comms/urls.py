"""
URL configuration for reflect_comms project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

def api_root(request):
    return JsonResponse({
        "message": "Reflect API",
        "docs": "Use /api/ for all endpoints.",
        "endpoints": {
            "admin": "/admin/",
            "auth": "/api/auth/register/, /api/auth/login/, /api/auth/me/",
            "posts": "/api/posts/",
            "profile": "/api/profile/",
            "organization": "/api/organization/",
        },
    })

urlpatterns = [
    path('', api_root),
    path('admin/', admin.site.urls),
    path('api/', include('reflect.urls')),
]
