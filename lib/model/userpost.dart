import 'usercomment.dart';

class Userpost {
  final String id; // used as the key when saving this post's comments
  final String userimg;
  final String username;
  final String time;
  final String postcontent;
  final String posting;
  String numcomments;
  final String numshare;
  bool isLiked;
  final List<Usercomment> comments;

  Userpost({
    required this.id,
    required this.userimg,
    required this.username,
    required this.time,
    required this.postcontent,
    required this.posting,
    required this.numcomments,
    required this.numshare,
    required this.isLiked,
    List<Usercomment>? comments,
  }) : comments = comments ?? <Usercomment>[];

  // Adds a comment and keeps the "N Comments" label in step with it.
  void addComment(Usercomment comment) {
    comments.add(comment);
    numcomments = ((int.tryParse(numcomments) ?? 0) + 1).toString();
  }
}