import 'package:flutter/material.dart';
import '../model/friend.dart';
import '../model/userdata.dart';

class Friendlist extends StatelessWidget {
  Friendlist({super.key, required this.userdata});

  final Userdata userdata;

  final followTxtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  Widget friend(Friend friend) => Card(
        clipBehavior: Clip.antiAlias, // FIX: keeps photos inside the card
        child: Column(
          children: [
            Expanded(
              // FIX: every photo fills the SAME box, so they line up.
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  friend.img,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stack) =>
                      const Center(child: Icon(Icons.person, size: 40)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                friend.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

  Widget friendsListGrid() => GridView.builder(
        shrinkWrap: true,
        // FIX: the grid must not scroll by itself; the page scrolls it.
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 180,
        ),
        itemCount: userdata.friendList.length,
        itemBuilder: (BuildContext ctx, index) {
          return friend(userdata.friendList[index]);
        },
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(children: [Text('Friends', style: followTxtStyle)]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(children: [Text('${userdata.friendList.length} Friends')]),
        ),
        const SizedBox(height: 10),
        friendsListGrid(),
        SizedBox(height: 10, child: Container(color: Colors.grey)),
      ],
    );
  }
}