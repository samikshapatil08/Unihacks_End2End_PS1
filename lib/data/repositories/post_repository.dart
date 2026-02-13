import '../models/post_model.dart';
import '../../core/services/mock_data_service.dart';

class PostRepository {
  Future<List<PostModel>> fetchPosts() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.getMockPosts();
  }

  Future<PostModel> fetchPostById(String id) async {
    final posts = MockDataService.getMockPosts();
    return posts.firstWhere((p) => p.id == id);
  }
}