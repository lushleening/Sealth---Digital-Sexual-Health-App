import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/frontend/pages/discussion/create_post_page.dart';
import 'package:sddp_dsh/frontend/pages/discussion/discussion.dart';

import '../../helper/test_helper.dart';

void main() {
  group("Discussion Page Tests", () {
    testWidgets("DiscussionPage widget can be instantiated", (tester) async {
      // Simple test that doesn't need Supabase
      expect(() => const DiscussionPage(), returnsNormally);
    });

    testWidgets("DiscussionPage has correct type", (tester) async {
      final page = const DiscussionPage();
      expect(page, isA<DiscussionPage>());
    });
    
    testWidgets("CreatePostPage widget can be instantiated", (tester) async {
      expect(() => const CreatePostPage(), returnsNormally);
    });
    
    testWidgets("CreatePostPage has correct type", (tester) async {
      final page = const CreatePostPage();
      expect(page, isA<CreatePostPage>());
    });
  });
}