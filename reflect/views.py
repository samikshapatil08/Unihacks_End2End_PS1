from django.db.models import Q
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User

from .models import (
    Post,
    Comment,
    AIFeedback,
    Organization,
    UserProfile,
    AudioPost,
    AIPersonaAnalysis,
    PersonaChatMessage,
)
from .serializers import (
    UserSerializer,
    OrganizationSerializer,
    UserProfileSerializer,
    PostSerializer,
    PostListSerializer,
    PostCreateUpdateSerializer,
    CommentSerializer,
    CommentCreateSerializer,
    AudioPostListSerializer,
    AIPersonaAnalysisSerializer,
    PersonaChatMessageSerializer,
)
from .ai_service import generate_persona_analysis, generate_persona_chat_reply

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
            "id": post.id,
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
    """Legacy: POST /api/register/ (unauthenticated)."""
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


# --- Auth (required paths: /api/auth/register/, login/, me/) ---

@api_view(['POST'])
@permission_classes([AllowAny])
def auth_register(request):
    """POST /api/auth/register/ - Register and return tokens."""
    username = (request.data.get("username") or "").strip()
    password = request.data.get("password")

    if not username or not password:
        return Response({"error": "Username and password required"}, status=400)
    if len(username) > 150:
        return Response({"error": "Username too long"}, status=400)

    if User.objects.filter(username=username).exists():
        return Response({"error": "User already exists"}, status=400)

    user = User.objects.create_user(username=username, password=password)
    org = Organization.objects.first()
    if not org:
        org = Organization.objects.create(name="Default Org")
    UserProfile.objects.create(user=user, organization=org)

    refresh = RefreshToken.for_user(user)
    return Response({
        "message": "User created successfully",
        "user": UserSerializer(user).data,
        "access": str(refresh.access_token),
        "refresh": str(refresh),
    }, status=201)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def auth_me(request):
    """GET /api/auth/me/ - Current user and profile (authenticated)."""
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=404)
    data = UserProfileSerializer(profile).data
    return Response(data)


# --- Organization ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def organization_me(request):
    """GET /api/organization/me/ - Current user's organization."""
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=404)
    serializer = OrganizationSerializer(profile.organization)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def organization_create(request):
    """POST /api/organization/create/ - Create org and assign current user to it."""
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=404)

    name = (request.data.get("name") or "").strip()
    if not name:
        return Response({"error": "name is required"}, status=400)
    if len(name) > 30:
        return Response({"error": "name too long"}, status=400)

    org = Organization.objects.create(name=name)
    profile.organization = org
    profile.save(update_fields=['organization'])
    return Response(OrganizationSerializer(org).data, status=201)


def generate_fake_feedback(content):

    return [
        {"persona": "Mentor", "feedback": "Good insight, consider expanding."},
        {"persona": "Critic", "feedback": "Needs clearer reasoning."},
        {"persona": "Optimist", "feedback": "Strong positive direction!"}
    ]


def _get_user_org(request):
    """Return (user_profile, organization) or (None, None) with error response."""
    try:
        profile = request.user.userprofile
        return profile, profile.organization
    except UserProfile.DoesNotExist:
        return None, None


def _post_for_org(post_id, organization):
    """Return Post if it belongs to organization, else None."""
    return Post.objects.filter(id=post_id, organization=organization).first()


# --- Posts (REST: list, create, detail get/patch/delete) ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def post_list(request):
    """GET /api/posts/ - List posts for user's organization (feed)."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    posts = Post.objects.filter(organization=org).order_by('-created_at')
    serializer = PostListSerializer(posts, many=True)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def post_create(request):
    """POST /api/posts/create/ - Create a post."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    ser = PostCreateUpdateSerializer(data=request.data)
    if not ser.is_valid():
        return Response(ser.errors, status=400)

    post = Post.objects.create(
        author=request.user,
        organization=org,
        post_type=ser.validated_data.get('post_type', 'text'),
        content=ser.validated_data.get('content', ''),
        tags=ser.validated_data.get('tags', ''),
    )
    # Legacy: generate fake AI feedback for compatibility
    for f in generate_fake_feedback(post.content):
        AIFeedback.objects.create(post=post, persona=f["persona"], feedback=f["feedback"])
    return Response(PostSerializer(post).data, status=201)


@api_view(['GET', 'PATCH', 'DELETE'])
@permission_classes([IsAuthenticated])
def post_detail(request, pk):
    """GET /api/posts/{id}/ - Retrieve. PATCH/DELETE only for own post."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    post = _post_for_org(pk, org)
    if not post:
        return Response({"error": "Not found"}, status=404)

    if request.method == 'GET':
        return Response(PostSerializer(post).data)

    if request.method == 'DELETE':
        if post.author_id != request.user.id:
            return Response({"error": "Can only delete your own post"}, status=403)
        post.delete()
        return Response(status=204)

    # PATCH
    if post.author_id != request.user.id:
        return Response({"error": "Can only update your own post"}, status=403)
    ser = PostCreateUpdateSerializer(post, data=request.data, partial=True)
    if not ser.is_valid():
        return Response(ser.errors, status=400)
    ser.save()
    return Response(PostSerializer(post).data)


# --- Comments ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def comment_list(request, post_id):
    """GET /api/posts/{id}/comments/ - List comments for post (org-scoped)."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)
    comments = Comment.objects.filter(post=post).order_by('created_at')
    return Response(CommentSerializer(comments, many=True).data)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def comment_create(request, post_id):
    """POST /api/posts/{id}/comments/create/ - Add comment."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)

    ser = CommentCreateSerializer(data=request.data)
    if not ser.is_valid():
        return Response(ser.errors, status=400)
    text = (ser.validated_data.get('text') or '').strip()
    if not text:
        return Response({"text": ["This field may not be blank."]}, status=400)

    comment = Comment.objects.create(post=post, user=request.user, text=text)
    return Response(CommentSerializer(comment).data, status=201)


# --- Audio discussions ---

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def audio_upload(request):
    """POST /api/audio/upload/ - Create an audio discussion. Requires multipart with audio_file."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    audio_file = request.FILES.get('audio_file')
    if not audio_file:
        return Response({"error": "audio_file is required"}, status=400)

    post_id = request.data.get('post')
    post = _post_for_org(post_id, org) if post_id else None

    instance = AudioPost.objects.create(
        post=post,
        author=request.user,
        organization=org,
        audio_file=audio_file,
        transcript=request.data.get('transcript', ''),
    )
    serializer = AudioPostListSerializer(instance)
    return Response(serializer.data, status=201)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def audio_detail(request, pk):
    """GET /api/audio/{id}/ - Retrieve one audio post. Org-scoped."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    audio = AudioPost.objects.filter(id=pk, organization=org).first()
    if not audio:
        return Response({"error": "Not found"}, status=404)
    serializer = AudioPostListSerializer(audio)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def post_audio_list(request, post_id):
    """GET /api/posts/{id}/audio/ - List audio discussions for a post (org-scoped)."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)
    audios = AudioPost.objects.filter(post=post, organization=org).order_by('-created_at')
    return Response(AudioPostListSerializer(audios, many=True).data)


# --- AI persona analysis ---

@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def ai_analysis(request, post_id):
    """
    GET  /api/posts/{id}/ai-analysis/ - List AI analyses for a post.
    POST /api/posts/{id}/ai-analysis/ - Request new AI persona analysis.
    """
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)

    if request.method == 'GET':
        analyses = AIPersonaAnalysis.objects.filter(post=post).order_by('-created_at')
        serializer = AIPersonaAnalysisSerializer(analyses, many=True)
        return Response(serializer.data)

    # POST - optionally return existing to avoid duplicate AI calls
    persona_name = (request.data.get('persona_name') or 'Analyst').strip()
    if len(persona_name) > 100:
        return Response({"error": "persona_name too long"}, status=400)

    existing = AIPersonaAnalysis.objects.filter(post=post, persona_name=persona_name).order_by('-created_at').first()
    if existing:
        return Response(AIPersonaAnalysisSerializer(existing).data, status=200)

    analysis_text, err = generate_persona_analysis(post.content, persona_name)
    if err:
        return Response({"error": "AI service error", "detail": err}, status=502)

    analysis_text = analysis_text or "No analysis generated."
    instance = AIPersonaAnalysis.objects.create(
        post=post,
        persona_name=persona_name,
        analysis_text=analysis_text,
    )
    serializer = AIPersonaAnalysisSerializer(instance)
    return Response(serializer.data, status=201)


# --- Persona chat ---

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def persona_chat_send(request):
    """POST /api/persona-chat/send/ - Send a message and get AI reply. Body: post_id, persona_name, message_text."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    post_id = request.data.get('post_id')
    persona_name = request.data.get('persona_name')
    message_text = (request.data.get('message_text') or '').strip()

    if not post_id:
        return Response({"error": "post_id is required"}, status=400)
    if not persona_name or len(persona_name) > 100:
        return Response({"error": "persona_name is required and max 100 chars"}, status=400)
    if not message_text:
        return Response({"error": "message_text is required"}, status=400)

    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)

    # History before adding current user message (so AI gets context + we pass current message separately)
    history = list(
        PersonaChatMessage.objects.filter(post=post, persona_name=persona_name)
        .order_by('created_at')
        .values('sender_type', 'message_text')
    )

    # Store user message
    PersonaChatMessage.objects.create(
        post=post,
        persona_name=persona_name,
        sender_type=PersonaChatMessage.SENDER_USER,
        message_text=message_text,
    )

    reply_text, err = generate_persona_chat_reply(
        post.content, persona_name, history, message_text
    )
    if err:
        reply_text = f"[AI temporarily unavailable: {err}]"

    ai_msg = PersonaChatMessage.objects.create(
        post=post,
        persona_name=persona_name,
        sender_type=PersonaChatMessage.SENDER_AI,
        message_text=reply_text,
    )

    messages = PersonaChatMessage.objects.filter(
        post=post, persona_name=persona_name
    ).order_by('created_at')
    serializer = PersonaChatMessageSerializer(messages, many=True)
    return Response({"messages": serializer.data})


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def persona_chat_list(request, post_id):
    """GET /api/persona-chat/{post_id}/ - List persona chat messages for a post. Query: ?persona_name= optional."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)

    post = _post_for_org(post_id, org)
    if not post:
        return Response({"error": "Post not found"}, status=404)

    qs = PersonaChatMessage.objects.filter(post=post).order_by('created_at')
    persona_name = request.query_params.get('persona_name')
    if persona_name:
        qs = qs.filter(persona_name=persona_name)
    serializer = PersonaChatMessageSerializer(qs, many=True)
    return Response({"messages": serializer.data})


# --- Search & filter ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def post_search(request):
    """GET /api/posts/search/?query= - Search posts by content (org-scoped)."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    query = (request.query_params.get('query') or '').strip()
    if not query:
        return Response({"error": "query parameter required"}, status=400)
    posts = Post.objects.filter(organization=org).filter(
        Q(content__icontains=query) | Q(tags__icontains=query)
    ).order_by('-created_at')
    return Response(PostListSerializer(posts, many=True).data)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def post_filter(request):
    """GET /api/posts/filter/?tag= - Filter posts by tag (org-scoped)."""
    profile, org = _get_user_org(request)
    if not org:
        return Response({"error": "User profile not found"}, status=400)
    tag = (request.query_params.get('tag') or '').strip()
    if not tag:
        return Response({"error": "tag parameter required"}, status=400)
    posts = Post.objects.filter(organization=org).filter(
        Q(tags__icontains=tag)
    ).order_by('-created_at')
    return Response(PostListSerializer(posts, many=True).data)


# --- Profile ---

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def profile_me(request):
    """GET /api/profile/ - Current user profile."""
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=404)
    return Response(UserProfileSerializer(profile).data)


@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def profile_update(request):
    """PATCH /api/profile/update/ - Update profile (user fields: email, first_name, last_name)."""
    try:
        profile = request.user.userprofile
    except UserProfile.DoesNotExist:
        return Response({"error": "User profile not found"}, status=404)

    user = request.user
    allowed = {'email', 'first_name', 'last_name'}
    data = {k: v for k, v in (request.data or {}).items() if k in allowed}
    for key, value in data.items():
        if key == 'email' and value is not None:
            user.email = value
        elif key == 'first_name' and value is not None:
            user.first_name = value
        elif key == 'last_name' and value is not None:
            user.last_name = value
    user.save(update_fields=['email', 'first_name', 'last_name'])
    return Response(UserProfileSerializer(profile).data)
