import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/persona_model.dart';

class MockDataService {
  static List<PostModel> getMockPosts() {
    return [
      PostModel(
        id: '1',
        authorName: 'Sarah Chen',
        authorRole: 'Product Designer',
        title: 'Reflections on User Research Sessions',
        content: 'After spending three weeks conducting interviews...',
        timeAgo: '2h ago',
        tags: ['Research', 'Product'],
        reactionCount: 24,
        commentCount: 3,
      ),
      PostModel(
        id: '2',
        authorName: 'Michael Rodriguez',
        authorRole: 'Engineering Lead',
        title: 'Learning from Our Recent Outage',
        content: "Yesterday's incident taught me more about resilience...",
        timeAgo: '5h ago',
        tags: ['Leadership', 'Engineering'],
        reactionCount: 42,
        commentCount: 15,
      ),
    ];
  }

  static List<PersonaModel> getPersonas() {
    return [
      PersonaModel(
        id: 'pm',
        name: 'Product Manager',
        description: 'Focuses on user impact and business value.',
        insight: 'Highlights a critical gap in our user research methodology.',
      ),
      PersonaModel(
        id: 'eng',
        name: 'Engineering Lead',
        description: 'Focuses on technical implications and analytics.',
        insight: 'Consider building better analytics to capture hesitation.',
      ),
      PersonaModel(
        id: 'psych',
        name: 'Team Psychologist',
        description: 'Focuses on emotional intelligence and safety.',
        insight: 'Sarah awareness of non-verbal communication extends to teams.',
      ),
    ];
  }
}