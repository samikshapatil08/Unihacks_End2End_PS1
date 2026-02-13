from django.shortcuts import render
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth.models import User

from .models import (
    Post,
    Comment,
    AIFeedback,
    Organization,
    UserProfile
)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def feed(request):

    # Safe profile check
    try:
        user_profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=400)

    org = user_profile.organization

    posts = Post.objects.filter(
        organization=org
    ).order_by('-created_at')

    data = []

    for post in posts:

        comments = post.comment_set.all()
        comment_data = []

        for c in comments:
            comment_data.append({
                "user": c.user.username,
                "text": c.text
            })

        ai_feedback = AIFeedback.objects.filter(post=post)

        feedback_data = []

        for f in ai_feedback:
            feedback_data.append({
                "persona": f.persona,
                "feedback": f.feedback
            })

        data.append({
            "author": post.author.username,
            "content": post.content,
            "type": post.post_type,
            "comments": comment_data,
            "ai_feedback": feedback_data
        })

    return Response(data)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_post(request):

    try:
        user_profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=400)

    post = Post.objects.create(
        author=request.user,
        organization=user_profile.organization,
        post_type=request.data.get("post_type"),
        content=request.data.get("content")
    )

    feedbacks = generate_fake_feedback(post.content)

    for f in feedbacks:
        AIFeedback.objects.create(
            post=post,
            persona=f["persona"],
            feedback=f["feedback"]
        )

    return Response({"message": "Post created"})


@api_view(['POST'])
def register(request):

    username = request.data.get("username")
    password = request.data.get("password")

    if not username or not password:
        return Response({"error": "Username and password required"}, status=400)

    if User.objects.filter(username=username).exists():
        return Response({"error": "User already exists"}, status=400)

    user = User.objects.create_user(
        username=username,
        password=password
    )

    # ensure organization exists
    org = Organization.objects.first()

    if not org:
        org = Organization.objects.create(name="Default Org")

    UserProfile.objects.create(
        user=user,
        organization=org
    )

    return Response({"message": "User created successfully"})


def generate_fake_feedback(content):

    return [
        {"persona": "Mentor", "feedback": "Good insight, consider expanding."},
        {"persona": "Critic", "feedback": "Needs clearer reasoning."},
        {"persona": "Optimist", "feedback": "Strong positive direction!"}
    ]
