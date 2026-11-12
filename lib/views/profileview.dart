import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/usercomment.dart';
import '../model/userdata.dart';
import '../model/userpost.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    required this.userPost,
    this.openComments = false, // true = jump to comments and open the keyboard
  });

  final Userpost userPost;
  final bool openComments;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Userdata userdata = Userdata();
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocus = FocusNode();
  final ScrollController scrollController = ScrollController();
  bool isSending = false;

  var nametxtStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  void initState() {
    super.initState();
    // Opened from the Comment button on the post list: go to the comments.
    if (widget.openComments) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) goToComments();
      });
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    commentFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // Scrolls down to the comment section, then opens the comment box.
  Future<void> goToComments() async {
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    if (mounted) commentFocus.requestFocus();
  }

  // Adds the typed comment to this post, saves it on the phone, shows it.
  Future<void> submitComment() async {
    final text = commentController.text.trim();
    if (text.isEmpty || isSending) return;
    setState(() => isSending = true);

    final saved = await userdata.addComment(widget.userPost, text);

    if (!mounted) return;
    commentController.clear();
    setState(() => isSending = false);
    FocusScope.of(context).unfocus();

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment posted, but it could not be saved on this device.'),
        ),
      );
    }

    // Scroll down so the new comment is in view.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget buttons(Userpost userPost) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        userPost.isLiked ? Colors.grey : Colors.blue,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up, size: 20),
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  // FIX: Comment scrolls to the comment section and opens the box.
                  onPressed: goToComments,
                  icon: const Icon(Icons.chat_bubble, size: 20),
                  label: const Text('Comment'),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('Share'),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
        ],
      );

  Widget commenters(Userpost userPost) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${userPost.comments.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Text(
                  'All Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
      );

  Widget userpostdetails(Usercomment userComment) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(userComment.commenterImg),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userComment.commenterName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(userComment.commentContent),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Row(
                      children: [
                        Text(userComment.displayTime,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        const Text('Like', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 12),
                        const Text('Reply', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget userline(Userpost userPost) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundImage: AssetImage(userPost.userimg),
              radius: 20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userPost.username, style: nametxtStyle),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(userPost.time),
                  const Text('.'),
                  const Icon(Icons.group, size: 15, color: Colors.grey),
                ],
              ),
            ],
          ),
        ],
      );

  Widget postimage(Userpost userPost) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [Expanded(child: Text(userPost.postcontent))]),
            const SizedBox(height: 15),
            Container(
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(userPost.posting),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );

  // The "write a comment" bar pinned to the bottom of the screen.
  Widget commentBox() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(userdata.myUserAccount.img),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: commentController,
                  focusNode: commentFocus,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  inputFormatters: [LengthLimitingTextInputFormatter(300)],
                  onSubmitted: (_) => submitComment(),
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: isSending ? null : submitComment,
                icon: const Icon(Icons.send),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final userPost = widget.userPost;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // ONE list. Comments are spread straight into it
            // instead of a second ListView inside this one.
            child: ListView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                userline(userPost),
                postimage(userPost),
                buttons(userPost),
                commenters(userPost),
                if (userPost.comments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No comments yet. Be the first to comment!'),
                  ),
                ...userPost.comments.map(userpostdetails),
              ],
            ),
          ),
          commentBox(),
        ],
      ),
    );
  }
}