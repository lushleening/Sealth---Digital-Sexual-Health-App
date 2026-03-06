import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/navigation/safer_navigation/safer_navigation.dart';
import 'package:sddp_dsh/backend/in_app_notifications/snackbar_message.dart';
import 'package:sddp_dsh/backend/articles/providers/article.dart';
import 'package:sddp_dsh/frontend/pages/articles/article_reader_page.dart';
import 'package:sddp_dsh/backend/articles/providers/articles_provider.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class UploadArticlePage extends ConsumerStatefulWidget {
  const UploadArticlePage({super.key});

  @override
  ConsumerState<UploadArticlePage> createState() => _UploadArticlePageState();
}

class _UploadArticlePageState extends ConsumerState<UploadArticlePage> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
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
            _uploadCard(
              key: KBtn.uploadPdfBtn.key,
              icon: Icons.cloud_upload_outlined,
              title: "Tap to upload .md file",
              subtitle: "Max 10 MB",
              onTap: () {
                // TODO: file picker logic
              },
            ),

            const SizedBox(height: 20),

            _uploadCard(
              key: KBtn.uploadImageBtn.key,
              icon: Icons.image_outlined,
              title: "Upload article thumbnail image",
              subtitle: "JPEG, PNG – Max 5 MB",
              onTap: () {
                // TODO: image picker logic
              },
            ),

            const SizedBox(height: 28),

            _buildInput(
              "Article Title",
              _titleController,
              hint: "Enter article title",
            ),

            const SizedBox(height: 18),

            _buildInput(
              "Article Label",
              _categoryController,
              hint: "Select a label",
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
                onPressed: () {
                  if (_titleController.text.isEmpty) {
                    showSnackbarMessage("Title is required");
                    return;
                  }

                  final article = Article(
                    title: _titleController.text,
                    content: _contentController.text,
                    linkToSubpage: ArticleReaderPage(
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );

                  ref
                      .read(articlesProvider.notifier)
                      .addArticle(
                        article: article,
                        category: _categoryController.text,
                      );

                  navPop(context, ref);
                },
                child: const Text(
                  "Upload Article",
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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
                child: Icon(icon, size: 28, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
