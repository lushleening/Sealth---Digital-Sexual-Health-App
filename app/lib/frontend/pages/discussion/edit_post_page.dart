import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/discussion/discussion_services.dart';
import 'package:sddp_dsh/backend/discussion/models/discussion_post.dart';
import 'package:sddp_dsh/backend/discussion/discussion_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPostPage extends ConsumerStatefulWidget {
  final DiscussionPost post;

  const EditPostPage({super.key, required this.post});

  @override
  ConsumerState<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends ConsumerState<EditPostPage> {
  DiscussionServices? _service;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    _service = ref.read(discussionServicesProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Wrap in addPostFrameCallback to avoid calling during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to edit posts'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _service!.updatePost(
        postId: widget.post.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
      );

      ref.invalidate(postsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating post: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _goBack() {
    ref.invalidate(postsProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.whiteBackground,
      appBar: AppBar(
        title: const Text("Edit Post"),
        backgroundColor: context.colors.mainColor,
        foregroundColor: context.colors.textWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _saveChanges,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: context.colors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                "Post Title *",
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                cursorColor: context.colors.mainColor,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.colors.whiteBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.buttonBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.buttonBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.mainColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Post Content *",
                style: TextStyle(
                  fontSize: 14,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                cursorColor: context.colors.mainColor,
                maxLines: 10,
                minLines: 6,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  hintText: "Share your thoughts, questions, or experiences...",
                  filled: true,
                  fillColor: context.colors.whiteBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.buttonBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.buttonBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colors.mainColor,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.mainColor,
                disabledBackgroundColor: context.colors.buttonBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}