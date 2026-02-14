# Generated manually for Supabase PostgreSQL compatibility

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('reflect', '0004_aifeedback'),
    ]

    operations = [
        migrations.CreateModel(
            name='AudioPost',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('audio_file', models.FileField(upload_to='audio_discussions/%Y/%m/')),
                ('transcript', models.TextField(blank=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('author', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('organization', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='reflect.organization')),
                ('post', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='audio_posts', to='reflect.post')),
            ],
        ),
        migrations.CreateModel(
            name='AIPersonaAnalysis',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('persona_name', models.CharField(max_length=100)),
                ('analysis_text', models.TextField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('post', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='ai_persona_analyses', to='reflect.post')),
            ],
        ),
        migrations.CreateModel(
            name='PersonaChatMessage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('persona_name', models.CharField(max_length=100)),
                ('sender_type', models.CharField(choices=[('user', 'user'), ('ai', 'ai')], max_length=10)),
                ('message_text', models.TextField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('post', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='persona_chat_messages', to='reflect.post')),
            ],
        ),
    ]
