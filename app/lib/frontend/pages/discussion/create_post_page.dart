import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_header.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  bool isAnonymous = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submitPost() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      showSnackbarMessage("Please fill in the required fields");
      return;
    }

    // TODO: Add post creation logic later, changed to use navPop instead
    // navPop(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.whiteBackground,

      body: SafeArea(
        child: Column(
          children: [
            CreatePostHeader(onBack: () {}),//=> navPop(context, ref)),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),

                    // Post Title
                    Text("Post Title *", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colors.whiteBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Post Content
                    const Text(
                      "Post Content *",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _contentController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: context.colors.whiteBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Anonymous checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Anonymous post"),
                        Checkbox(
                          value: isAnonymous,
                          activeColor: context.colors.mainColor,
                          onChanged: (value) {
                            setState(() {
                              isAnonymous = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),

                    // space so content doesn't hide behind bottom button
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ keep button safe from gesture bar
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.whiteBackground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
