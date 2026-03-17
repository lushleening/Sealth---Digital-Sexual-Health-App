import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/assets.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/frontend/pages/articles/markdown_article_page.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadArticlePage extends ConsumerStatefulWidget {
  const UploadArticlePage({super.key});

  @override
  ConsumerState<UploadArticlePage> createState() => _UploadArticlePageState();
}

class _UploadArticlePageState extends ConsumerState<UploadArticlePage> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();

  final supabase = Supabase.instance.client;

  String? _markdownPath;
  String? _thumbnailPath;
  String? _selectedCategory;

  final List<String> categories = [
    "General",
    "Multiple Partners",
    "LGBTQ+",
    "Testing",
    "Prevention",
    "Treatment"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //Extract filename safely on both Windows (\) and Unix (/) paths
  String _basename(String filePath) {
    return filePath.split(RegExp(r'[/\\]')).last;
  }

  //Pick markdown file
  Future<void> pickMarkdownFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['md'],
    );

    if (result != null) {
      setState(() {
        _markdownPath = result.files.single.path;
      });

      showSnackbarMessage("Markdown file selected");
    }
  }

  //Pick thumbnail image
  Future<void> pickThumbnail() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _thumbnailPath = image.path;
      });

      showSnackbarMessage("Thumbnail selected");
    }
  }

  //Upload markdown to Supabase
  Future<String> uploadMarkdownToSupabase(String filePath) async {
    final file = File(filePath);

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${_basename(filePath)}";

    final storagePath = "markdown/$fileName";

    await supabase.storage
        .from('articles')
        .upload(storagePath, file);

    return supabase.storage
        .from('articles')
        .getPublicUrl(storagePath);
  }

  //Upload thumbnail to Supabase
  Future<String?> uploadThumbnailToSupabase() async {
    if (_thumbnailPath == null) return null;

    final file = File(_thumbnailPath!);

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${_basename(_thumbnailPath!)}";

    final storagePath = "thumbnails/$fileName";

    await supabase.storage
        .from('articles')
        .upload(storagePath, file);

    return supabase.storage
        .from('articles')
        .getPublicUrl(storagePath);
  }

  //Insert article into database
  Future<void> insertArticleToDatabase({
    required String title,
    required String description,
    required String markdownUrl,
    required String category,
    required String thumbnailUrl,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      showSnackbarMessage("You must be logged in to upload articles");
      return;
    }
    final userId = user.id;
    await supabase.from('articles').insert({
      "title": title,
      "description": description,
      "markdown_url": markdownUrl,
      "thumbnail_url": thumbnailUrl,
      "category": category,
      "author_id": userId,
    });
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
          "Upload Article",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(baseLength),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Markdown Upload
            _uploadCard(
              key: KBtn.uploadPdfBtn.key,
              icon: Icons.cloud_upload_outlined,
              title: "Tap to upload .md file",
              subtitle: _markdownPath == null
                  ? "Max 10 MB"
                  : "Markdown selected ✓",
              onTap: pickMarkdownFile,
            ),

            const SizedBox(height: 20),

            //Thumbnail Upload
            _uploadCard(
              key: KBtn.uploadImageBtn.key,
              icon: Icons.image_outlined,
              title: "Upload article thumbnail image (optional)",
              subtitle: _thumbnailPath == null
                  ? "JPEG / PNG - Max 5 MB"
                  : "Thumbnail selected ✓",
              onTap: pickThumbnail,
            ),

            const SizedBox(height: 28),

            _buildInput(
              "Article Title",
              _titleController,
              hint: "Enter article title",
            ),

            const SizedBox(height: 18),

            //Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Select a label"),
              items: categories
                  .map((tag) =>
                      DropdownMenuItem(value: tag, child: Text(tag)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
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

            _buildInput(
              "Author (optional)",
              _authorController,
              hint: "Enter author name",
            ),

            const SizedBox(height: 18),

            _buildInput(
              "Short Description (optional)",
              _descriptionController,
              hint: "Enter a brief description",
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                key: KBtn.uploadArticleBtn.key,
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

                  if (_markdownPath == null) {
                    showSnackbarMessage("Upload a markdown file");
                    return;
                  }

                  if (_selectedCategory == null) {
                    showSnackbarMessage("Select a category");
                    return;
                  }

                  //Upload files
                  final markdownUrl =
                      await uploadMarkdownToSupabase(_markdownPath!);

                  final thumbnailUrl =
                      await uploadThumbnailToSupabase() ?? placeholderImage;

                  //Insert into database
                  await insertArticleToDatabase(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    markdownUrl: markdownUrl,
                    category: _selectedCategory!,
                    thumbnailUrl: thumbnailUrl,
                  );

                  // Update local provider instantly
                  final article = Article(
                    title: _titleController.text,
                    content: _descriptionController.text,
                    image: thumbnailUrl,
                    linkToSubpage: MarkdownArticlePage(
                      markdownPath: markdownUrl,
                      article: Article(
                        title: _titleController.text,
                        content: _descriptionController.text,
                        image: thumbnailUrl,
                        linkToSubpage: const SizedBox(),
                      ),
                      category: _selectedCategory!,
                    ),
                  );

                  ref.read(articlesProvider.notifier).addArticle(
                        article: article,
                        category: _selectedCategory!,
                      );

                  showSnackbarMessage("Article uploaded successfully");

                  navPop(context, ref);
                },
                child: const Text(
                  "Upload Article",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
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
                fontWeight: FontWeight.w500,
                fontSize: 14)),
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
    Key? key,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      key: key,
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
                child: Icon(icon,
                    size: 28,
                    color: Colors.grey.shade600),
              ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}