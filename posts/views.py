from rest_framework import viewsets, permissions, filters
from .models import Post, Comment
from .serializers import PostSerializer, CommentSerializer
from rest_framework.pagination import PageNumberPagination

class StandardResultsSetPagination(PageNumberPagination):
    page_size = 10
    page_size_query_param = 'page_size'
    max_page_size = 100

class PostViewSet(viewsets.ModelViewSet):
    serializer_class = PostSerializer
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = StandardResultsSetPagination
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['tag', 'title']
    ordering_fields = ['created_at']

    def get_queryset(self):
        user = self.request.user
        if user.organization:
            return Post.objects.filter(organization=user.organization).order_by('-created_at')
        return Post.objects.none()

    def perform_create(self, serializer):
        serializer.save(author=self.request.user, organization=self.request.user.organization)

class CommentViewSet(viewsets.ModelViewSet):
    serializer_class = CommentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # We expect a nested structure or filtered by post_id parameter if not nested router
        # But user asks for /api/posts/{id}/comments/
        # So we might need to look at kwargs if using nested routing or just filter
        post_id = self.kwargs.get('post_pk') # If using nested routers
        if post_id:
             return Comment.objects.filter(post_id=post_id, post__organization=self.request.user.organization).order_by('created_at')
        return Comment.objects.none()

    def perform_create(self, serializer):
        post_id = self.kwargs.get('post_pk')
        post = Post.objects.get(pk=post_id)
        # Ensure post belongs to same org
        if post.organization != self.request.user.organization:
             from rest_framework.exceptions import PermissionDenied
             raise PermissionDenied("Cannot comment on post from another organization")
        serializer.save(user=self.request.user, post=post)
