from rest_framework import generics, permissions, status
from rest_framework.response import Response
from .models import Organization
from .serializers import OrganizationSerializer

class OrganizationCreateView(generics.CreateAPIView):
    queryset = Organization.objects.all()
    serializer_class = OrganizationSerializer
    permission_classes = [permissions.IsAuthenticated] # Or AllowAny if open registration of orgs

class OrganizationDetailView(generics.RetrieveAPIView):
    serializer_class = OrganizationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user.organization
