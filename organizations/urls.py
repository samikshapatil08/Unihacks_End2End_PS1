from django.urls import path
from .views import OrganizationCreateView, OrganizationDetailView

urlpatterns = [
    path('organizations/create/', OrganizationCreateView.as_view(), name='organization-create'),
    path('organizations/details/', OrganizationDetailView.as_view(), name='organization-details'),
]
