import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/helper/safe_nav.dart';
import 'package:sddp_dsh/pages/discussion/discussion_post_tile.dart';
import 'package:sddp_dsh/pages/discussion/discussion_header.dart';
import 'models/discussion_post.dart';
import 'models/comments.dart';
import 'package:sddp_dsh/pages/discussion/create_post_page.dart';
import 'package:sddp_dsh/helper/colors.dart';

// Dummy Data
final dummyPosts = [
  DiscussionPost(
    id: "6",
    authorName: "Dr Andrews",
    title: "Common Sexual Health Questions",
    content:
        "You might be experiencing several STI symptoms, please do NOT ignore them. Seek professional help NOW!",
    likes: 189,
    shares: 88,
    isVerified: true,
    comments: [
      DiscussionComment(
        id: "c1",
        postId: "6",
        authorName: "Audrey",
        content: "Can I arrange an appointment?",
        isVerified: false,
        likes: 0,
        repliesCount: 2,
        parentCommentId: null,
        replies: [
          DiscussionComment(
            id: "c1r1",
            postId: "6",
            authorName: "Dr Andrews",
            content: "012-666-7890",
            isVerified: true,
            likes: 38,
            repliesCount: 0,
            parentCommentId: "c1",
            replies: [],
          ),
          DiscussionComment(
            id: "c1r2",
            postId: "6",
            authorName: "A",
            content: "Thanks for the info!",
            isVerified: false,
            likes: 1,
            repliesCount: 0,
            parentCommentId: "c1",
            replies: [],
          ),
        ],
      ),
      DiscussionComment(
        id: "c2",
        postId: "6",
        authorName: "Bobby",
        content: "How can I contact you?",
        isVerified: false,
        likes: 0,
        repliesCount: 1,
        parentCommentId: null,
        replies: [
          DiscussionComment(
            id: "c2r1",
            postId: "6",
            authorName: "Dr Andrews",
            content: "Please call the clinic directly.",
            isVerified: true,
            likes: 22,
            repliesCount: 0,
            parentCommentId: "c2",
            replies: [],
          ),
        ],
      ),
      DiscussionComment(
        id: "c3",
        postId: "6",
        authorName: "Thomas",
        content: "Is testing absolutely necessary?",
        isVerified: false,
        likes: 0,
        repliesCount: 1,
        parentCommentId: null,
        replies: [
          DiscussionComment(
            id: "c3r1",
            postId: "6",
            authorName: "Dr Andrews",
            content: "It is highly recommended.",
            isVerified: true,
            likes: 38,
            repliesCount: 0,
            parentCommentId: "c3",
            replies: [],
          ),
        ],
      ),
    ],
  ),

  DiscussionPost(
    id: "7",
    authorName: "Dr Melissa Tan",
    title: "Understanding Anxiety in Teens",
    content:
        "Anxiety is common among teenagers. If you are feeling overwhelmed, consider speaking to a counselor or trusted adult.",
    likes: 95,
    shares: 21,
    isVerified: true,
    comments: [], // No comments
  ),

  DiscussionPost(
    id: "8",
    authorName: "Health Malaysia",
    title: "Healthy Sleep Habits",
    content:
        "Getting at least 7-9 hours of sleep is important for focus, mood, and overall health. Try reducing screen time before bed.",
    likes: 63,
    shares: 14,
    isVerified: false,
    comments: [], // No comments
  ),
];

class DiscussionPage extends ConsumerStatefulWidget {
  const DiscussionPage({super.key});

  @override
  ConsumerState<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends ConsumerState<DiscussionPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredPosts = dummyPosts.where((post) {
      return post.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navPush(context, ref, const CreatePostPage());
        },

        backgroundColor: context.colors.textBoxFill,
        child: Icon(Icons.add, size: 28, color: context.colors.textPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscussionHeader(
              onBack: () {
                // Use your Riverpod page notifier to go back to Home
                navPop(
                  context,
                  ref,
                ); // changed to use navPop instead; // changed to use navPop instead
              },
            ),

            // Search bar with background
            Container(
              color: context.colors.whiteBackground,
              padding: const EdgeInsets.all(16),
              child: TextField(
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  hintText: "Search discussions...",
                  hintStyle: TextStyle(color: context.colors.textPrimary),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colors.textPrimary,
                  ),
                  filled: true,
                  fillColor: context.colors.textBoxFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),

            // Posts → scrollable
            Expanded(
              child: Container(
                color: context.colors.whiteBackground,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: filteredPosts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return DiscussionPostTile(post: filteredPosts[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
