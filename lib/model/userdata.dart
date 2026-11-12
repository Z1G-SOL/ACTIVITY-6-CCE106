import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'friend.dart';
import 'usercomment.dart';
import 'userpost.dart';
import 'account.dart';

// TODO: put YOUR last name here. It shows on the profile and on your comments.
const String studentFirstNames = 'Michael Aguido L.';
const String studentLastName = 'Velez';

class Userdata {
  // One shared copy for the whole app, so every screen sees the same comments.
  static final Userdata _instance = Userdata._internal();
  factory Userdata() => _instance;

  Userdata._internal() {
    for (final post in userList) {
      post.comments.addAll(commentList);
    }
  }

  bool _loaded = false;

  List<Userpost> userList = [
    Userpost(
      id: 'post1',
      userimg: 'assets/person1.jfif',
      username: 'John Doe',
      time: '2 hrs ago',
      postcontent: 'Had a great day at the beach!',
      posting: 'assets/pavlova.jpg',
      numcomments: '24',
      numshare: '5',
      isLiked: false,
    ),
    Userpost(
      id: 'post2',
      userimg: 'assets/person2.jfif',
      username: 'Jane Smith',
      time: '3 hrs ago',
      postcontent: 'Loving the new cafe in town.',
      posting: 'assets/pavlova_main.jfif',
      numcomments: '18',
      numshare: '3',
      isLiked: true,
    ),
    Userpost(
      id: 'post3',
      userimg: 'assets/person3.jfif',
      username: 'Mike Johnson',
      time: '5 hrs ago',
      postcontent: 'Just finished a 10k run!',
      posting: 'assets/pavlova.jpg',
      numcomments: '30',
      numshare: '7',
      isLiked: false,
    ),
    Userpost(
      id: 'post4',
      userimg: 'assets/person4.jfif',
      username: 'Johnson Stewart',
      time: '5 hrs ago',
      postcontent: 'Just finished a 10k run!',
      posting: 'assets/pavlova_main.jfif',
      numcomments: '30',
      numshare: '7',
      isLiked: false,
    ),
  ];

  List<Friend> friendList = [
    Friend(img: 'assets/person1.jfif', name: 'Alice'),
    Friend(img: 'assets/person2.jfif', name: 'Bob'),
    Friend(img: 'assets/person3.jfif', name: 'Charlie'),
    Friend(img: 'assets/person4.jfif', name: 'Diana'),
    Friend(img: 'assets/person5.jfif', name: 'Ethan'),
    Friend(img: 'assets/person6.jpg', name: 'Fiona'),
  ];

  // Sample comments every post starts with.
  List<Usercomment> commentList = [
    Usercomment(
      commenterImg: 'assets/person2.jfif',
      commenterName: 'Jane Smith',
      commentTime: '1 hr ago',
      commentContent: 'Looks fun!',
    ),
    Usercomment(
      commenterImg: 'assets/person3.jfif',
      commenterName: 'Mike Johnson',
      commentTime: '30 mins ago',
      commentContent: 'Wish I was there!',
    ),
    Usercomment(
      commenterImg: 'assets/person4.jfif',
      commenterName: 'Emily Davis',
      commentTime: '15 mins ago',
      commentContent: 'Great photo!',
    ),
  ];

  Account myUserAccount = Account(
    name: '$studentFirstNames $studentLastName',
    email: 'Michaelvelez23@gmail.co,',
    img: 'assets/person2.jfif',
    numFollowers: '1 Million',
    numPosts: '350',
    numFollowing: '500',
    numFriends: '400',
  );

  String _key(Userpost post) => 'comments_${post.id}';

  // Call once at startup: puts previously saved comments back on their posts.
  Future<void> loadSavedComments() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final post in userList) {
        final raw = prefs.getString(_key(post));
        if (raw == null) continue;
        for (final item in jsonDecode(raw) as List<dynamic>) {
          post.addComment(Usercomment.fromJson(item as Map<String, dynamic>));
        }
      }
    } catch (_) {
      // Saved data unreadable: start with the sample comments only.
    }
  }

  // Adds a comment to a post and saves it. Returns false if it was blank or
  // could not be saved to the device (it still shows on screen in that case).
  Future<bool> addComment(Userpost post, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    post.addComment(
      Usercomment(
        commenterImg: myUserAccount.img,
        commenterName: myUserAccount.name,
        commentTime: 'Just now',
        commentContent: trimmed,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final mine = post.comments.where((c) => c.createdAt != null);
      return prefs.setString(
        _key(post),
        jsonEncode(mine.map((c) => c.toJson()).toList()),
      );
    } catch (_) {
      return false;
    }
  }
}