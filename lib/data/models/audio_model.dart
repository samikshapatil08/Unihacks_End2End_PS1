/// API response: id, author (nested), organization, audio_file (URL), transcript, created_at
class AudioModel {
  final String id;
  final String title;
  final String duration;
  final String authorName;
  final String? transcript;
  final String? timeAgo;
  final String? audioFileUrl;

  AudioModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.authorName,
    this.transcript,
    this.timeAgo,
    this.audioFileUrl,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final authorName = author?['username'] as String? ??
        '${author?['first_name'] ?? ''} ${author?['last_name'] ?? ''}'.trim() ??
        'Unknown';
    final transcript = json['transcript'] as String?;
    final createdAt = json['created_at'] as String?;
    final timeAgo = _formatTimeAgo(createdAt);
    final title = transcript != null && transcript.length > 50
        ? '${transcript.substring(0, 50)}...'
        : (transcript ?? 'Audio');
    return AudioModel(
      id: json['id']?.toString() ?? '',
      title: title,
      duration: '0:00',
      authorName: authorName,
      transcript: transcript,
      timeAgo: timeAgo,
      audioFileUrl: json['audio_file'] as String?,
    );
  }

  static String? _formatTimeAgo(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${diff.inDays ~/ 7}w ago';
    } catch (_) {
      return null;
    }
  }
}
