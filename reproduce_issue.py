import os
import django
from rest_framework.test import APIRequestFactory

# Setup Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'reflect_comms.settings')
django.setup()

from reflect.serializers import CommentSerializer, PersonaChatSerializer
from reflect.models import Post, Organization, User

def test_serializers():
    print("Testing serializers...")
    
    # Mock data references (we don't need real DB objects for serializer validation check 
    # if we only check 'is_valid' excluding relations existence or if we mock them)
    # Actually ModelSerializer checks for existence of related objects if passed.
    # But here we are NOT passing 'post' in data. 
    # If 'post' is required, is_valid() should fail with "This field is required".
    
    # Test CommentSerializer
    print("\n--- CommentSerializer ---")
    data = {'text': 'Test comment'}
    # user is read_only, created_at is read_only. post is NOT read_only.
    serializer = CommentSerializer(data=data)
    if serializer.is_valid():
        print("CommentSerializer is valid")
    else:
        print(f"CommentSerializer errors: {serializer.errors}")
        
    # Test PersonaChatSerializer
    print("\n--- PersonaChatSerializer ---")
    data = {'persona': 'Test', 'message': 'Hello'}
    # post is NOT read_only.
    serializer = PersonaChatSerializer(data=data)
    if serializer.is_valid():
        print("PersonaChatSerializer is valid")
    else:
        print(f"PersonaChatSerializer errors: {serializer.errors}")

if __name__ == '__main__':
    test_serializers()
