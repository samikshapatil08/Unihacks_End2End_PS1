from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import*
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import permission_classes


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def feed(request):

    user_profile = request.user.userprofile
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


    user_profile = request.user.userprofile

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

def generate_fake_feedback(content):

    return [
        {"persona": "Mentor", "feedback": "Good insight, consider expanding."},
        {"persona": "Critic", "feedback": "Needs clearer reasoning."},
        {"persona": "Optimist", "feedback": "Strong positive direction!"}
    ]


from django.contrib.auth.models import User

@api_view(['POST'])
def register(request):

    username = request.data.get("username")
    password = request.data.get("password")

    if User.objects.filter(username=username).exists():
        return Response({"error": "User already exists"}, status=400)

    user = User.objects.create_user(
        username=username,
        password=password
    )

    org = Organization.objects.first()
    UserProfile.objects.create(user=user, organization=org)

    return Response({"message": "User created successfully"})
