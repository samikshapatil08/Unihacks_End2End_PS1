from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.contrib.auth.models import User
from django.shortcuts import get_object_or_404
from django.db.models import Q

from .models import Post, Comment, AIFeedback, Organization, UserProfile, PersonaChat
from .serializers import (
    PostSerializer, CommentSerializer, AIFeedbackSerializer,
    OrganizationSerializer, UserProfileSerializer, UserSerializer,
    RegisterSerializer, PersonaChatSerializer
)

# --- AUTHENTICATION ---

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        return Response({"username": user.username, "message": "User created successfully"}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def me(request):
    serializer = UserSerializer(request.user)
    return Response(serializer.data)

# --- ORGANIZATION ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def my_organization(request):
    try:
        org = request.user.userprofile.organization
        serializer = OrganizationSerializer(org)
        return Response(serializer.data)
    except AttributeError:
        return Response({"error": "User has no organization"}, status=status.HTTP_404_NOT_FOUND)

# --- POSTS / REFLECTIONS ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def feed(request):
    try:
        org = request.user.userprofile.organization
        posts = Post.objects.filter(organization=org).order_by('-created_at')
        
        # Filtering
        tag = request.query_params.get('tag')
        if tag:
            posts = posts.filter(content__icontains=tag)
            
        serializer = PostSerializer(posts, many=True)
        return Response(serializer.data)
    except AttributeError:
        return Response({"error": "User profile not found"}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_post(request):
    serializer = PostSerializer(data=request.data)
    if serializer.is_valid():
        try:
            org = request.user.userprofile.organization
            serializer.save(author=request.user, organization=org)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except AttributeError:
            return Response({"error": "User has no profile"}, status=status.HTTP_400_BAD_REQUEST)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PATCH', 'DELETE'])
@permission_classes([IsAuthenticated])
def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)
    
    # Check org permission
    try:
        if post.organization != request.user.userprofile.organization:
             return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)
    except AttributeError:
        return Response({"error": "User has no profile"}, status=status.HTTP_400_BAD_REQUEST)

    if request.method == 'GET':
        serializer = PostSerializer(post)
        return Response(serializer.data)

    elif request.method == 'PATCH':
        if post.author != request.user:
            return Response({"error": "You can only edit your own posts"}, status=status.HTTP_403_FORBIDDEN)
            
        serializer = PostSerializer(post, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        if post.author != request.user:
            return Response({"error": "You can only delete your own posts"}, status=status.HTTP_403_FORBIDDEN)
        post.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

# --- COMMENTS ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_comments(request, post_id):
    post = get_object_or_404(Post, pk=post_id)
    # Check org
    if post.organization != request.user.userprofile.organization:
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)
        
    comments = post.comment_set.all()
    serializer = CommentSerializer(comments, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_comment(request, post_id):
    post = get_object_or_404(Post, pk=post_id)
    # Check org
    if post.organization != request.user.userprofile.organization:
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)

    serializer = CommentSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save(user=request.user, post=post)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# --- AUDIO DISCUSSIONS ---
# (Handled via create_post and post_detail already, using audio_file field)

# --- AI PERSONA ANALYSIS ---

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def ai_analysis(request, post_id):
    post = get_object_or_404(Post, pk=post_id)
    if post.organization != request.user.userprofile.organization:
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)

    if request.method == 'GET':
        feedbacks = AIFeedback.objects.filter(post=post)
        serializer = AIFeedbackSerializer(feedbacks, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        # Mock AI Analysis logic
        feedbacks_data = [
            {"persona": "Mentor", "feedback": "Good insight, consider expanding."},
            {"persona": "Critic", "feedback": "Needs clearer reasoning."},
            {"persona": "Optimist", "feedback": "Strong positive direction!"}
        ]
        
        created_feedbacks = []
        for f in feedbacks_data:
            feedback, _ = AIFeedback.objects.get_or_create(
                post=post,
                persona=f["persona"],
                defaults={"feedback": f["feedback"]}
            )
            created_feedbacks.append(feedback)
            
        serializer = AIFeedbackSerializer(created_feedbacks, many=True)
        return Response(serializer.data)

# --- PERSONA CHAT ---

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def persona_chat(request, post_id):
    post = get_object_or_404(Post, pk=post_id)
    if post.organization != request.user.userprofile.organization:
        return Response({"error": "Permission denied"}, status=status.HTTP_403_FORBIDDEN)

    if request.method == 'GET':
        chats = PersonaChat.objects.filter(post=post).order_by('created_at')
        serializer = PersonaChatSerializer(chats, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = PersonaChatSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user, post=post)
            
            # Mock AI response
            PersonaChat.objects.create(
                post=post,
                user=request.user,
                persona=serializer.validated_data.get('persona', 'AI'),
                message=f"I agree with your point about {post.post_type}.",
                is_from_ai=True
            )
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# --- SEARCH ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def search_posts(request):
    query = request.query_params.get('query')
    if not query:
        return Response({"error": "Query parameter required"}, status=status.HTTP_400_BAD_REQUEST)
        
    try:
        org = request.user.userprofile.organization
        posts = Post.objects.filter(organization=org).filter(
            Q(content__icontains=query) | Q(post_type__icontains=query)
        )
        serializer = PostSerializer(posts, many=True)
        return Response(serializer.data)
    except AttributeError:
         return Response({"error": "User profile not found"}, status=status.HTTP_400_BAD_REQUEST)

# --- PROFILE ---

@api_view(['GET', 'PATCH'])
@permission_classes([IsAuthenticated])
def profile(request):
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "Profile not found"}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

    elif request.method == 'PATCH':
        serializer = UserProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
