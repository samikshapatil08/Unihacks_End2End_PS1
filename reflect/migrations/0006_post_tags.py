# Generated manually for Supabase PostgreSQL compatibility

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('reflect', '0005_audiopost_aipersonaanalysis_personachatmessage'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='tags',
            field=models.CharField(blank=True, default='', max_length=255),
        ),
    ]
