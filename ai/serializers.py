from rest_framework import serializers
from .models import AIPersonaAnalysis, PersonaChatMessage

class AIPersonaAnalysisSerializer(serializers.ModelSerializer):
    class Meta:
        model = AIPersonaAnalysis
        fields = '__all__'

class PersonaChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = PersonaChatMessage
        fields = '__all__'
