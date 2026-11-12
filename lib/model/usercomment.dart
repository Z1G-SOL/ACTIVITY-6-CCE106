class Usercomment {
  final String commenterImg;
  final String commenterName;
  final String commentTime;
  final String commentContent;

  // Only comments typed by the user have this (time written, in milliseconds).
  final int? createdAt;

  Usercomment({
    required this.commenterImg,
    required this.commenterName,
    required this.commentTime,
    required this.commentContent,
    this.createdAt,
  });

  String get displayTime {
    final created = createdAt;
    if (created == null) return commentTime;
    final diff = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(created),
    );
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    return '${diff.inDays} days ago';
  }

  Map<String, dynamic> toJson() => {
        'commenterImg': commenterImg,
        'commenterName': commenterName,
        'commentTime': commentTime,
        'commentContent': commentContent,
        'createdAt': createdAt,
      };

  factory Usercomment.fromJson(Map<String, dynamic> json) => Usercomment(
        commenterImg: json['commenterImg'] as String,
        commenterName: json['commenterName'] as String,
        commentTime: json['commentTime'] as String,
        commentContent: json['commentContent'] as String,
        createdAt: json['createdAt'] as int?,
      );
}