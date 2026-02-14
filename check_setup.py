import os
import django

try:
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'reflect_comms.settings')
    django.setup()
    print("Django setup successful")
except Exception as e:
    print(f"Django setup failed: {e}")
