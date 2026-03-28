import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/database/pgsql_supabase/supabase_service.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditArticlePage extends ConsumerStatefulWidget {
  final Article article;
  final String category;
  final String markdownUrl;
  final String thumbnailUrl;

  const EditArticlePage({
    super.key,
    required this.article,
    required this.category,
    required this.markdownUrl,
    required this.thumbnailUrl,
  });

  @override
  ConsumerState<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends ConsumerState<EditArticlePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final supabase = ref.watch(supabaseServiceProvider);

  String? _newMarkdownPath;
  String? _newThumbnailPath;
  late String _selectedCategory;

  final List<String> categories = [
    "General",
    "Multiple Partners",
    "LGBTQ+",
    "Testing",
    "Prevention",
    "Treatment"
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController =
        TextEditingController(text: widget.article.content);
    _selectedCategory = widget.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _basename(String filePath) {
    return filePath.split(RegExp(r'[/\\]')).last;
  }

  Future<void> pickMarkdownFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md'],
    );
    if (result != null) {
      setState(() => _newMarkdownPath = result.files.single.path);
      showSnackbarMessage("New markdown file selected");
    }
  }

  Future<void> pickThumbnail() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _newThumbnailPath = image.path);
      showSnackbarMessage("New thumbnail selected");
    }
  }

  Future<String> uploadMarkdownToSupabase(String filePath) async {
    final file = File(filePath);
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${_basename(filePath)}";
    final storagePath = "markdown/$fileName";
    await supabase.storage.from('articles').upload(storagePath, file);
    return supabase.storage.from('articles').getPublicUrl(storagePath);
  }

  Future<String> uploadThumbnailToSupabase(String filePath) async {
    final file = File(filePath);
    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${_basename(filePath)}";
    final storagePath = "thumbnails/$fileName";
    await supabase.storage.from('articles').upload(storagePath, file);
    return supabase.storage.from('articles').getPublicUrl(storagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.grayBackground,
      appBar: AppBar(
        backgroundColor: context.colors.mainColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Article",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(baseLength),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _uploadCard(
              icon: Icons.cloud_upload_outlined,
              title: "Replace markdown file (optional)",
              subtitle: _newMarkdownPath == null
                  ? "Current file will be kept"
                  : "New markdown selected ✓",
              onTap: pickMarkdownFile,
            ),

            const SizedBox(height: 20),

            _uploadCard(
              icon: Icons.image_outlined,
              title: "Replace thumbnail image (optional)",
              subtitle: _newThumbnailPath == null
                  ? "Current image will be kept"
                  : "New thumbnail selected ✓",
              onTap: pickThumbnail,
            ),

            const SizedBox(height: 28),

            _buildInput("Article Title", _titleController,
                hint: "Enter article title"),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map((tag) =>
                      DropdownMenuItem(value: tag, child: Text(tag)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            _buildInput("Short Description (optional)", _descriptionController,
                hint: "Enter a brief description"),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.mainColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  if (_titleController.text.isEmpty) {
                    showSnackbarMessage("Title is required");
                    return;
                  }

                  final markdownUrl = _newMarkdownPath != null
                      ? await uploadMarkdownToSupabase(_newMarkdownPath!)
                      : widget.markdownUrl;

                  final thumbnailUrl = _newThumbnailPath != null
                      ? await uploadThumbnailToSupabase(_newThumbnailPath!)
                      : widget.thumbnailUrl;

                  await supabase.from('articles').update({
                    "title": _titleController.text,
                    "description": _descriptionController.text,
                    "markdown_url": markdownUrl,
                    "thumbnail_url": thumbnailUrl,
                    "category": _selectedCategory,
                  }).eq('id', widget.article.articleId!);

                  final updatedArticle = Article(
                    articleId: widget.article.articleId,
                    authorId: widget.article.authorId,
                    title: _titleController.text,
                    content: _descriptionController.text,
                    image: thumbnailUrl,
                    markdownUrl: markdownUrl,
                    category: _selectedCategory,
                    linkToSubpage: const SizedBox(),
                  );

                  ref.read(articlesProvider.notifier).updateArticle(
                        articleId: widget.article.articleId!,
                        updatedArticle: updatedArticle,
                        category: _selectedCategory,
                      );

                  showSnackbarMessage("Article updated successfully");

                  if (!mounted) return;
                  context.pop();
                  context.pop();
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: Icon(icon, size: 28, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}