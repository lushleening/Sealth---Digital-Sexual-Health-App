import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';
import 'package:sddp_dsh/backend/personal_info/personal_info/personal_info_data.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/common_widgets/choice_dialog.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/frontend/common_widgets/top_appbar.dart';
import 'package:sddp_dsh/frontend/pages/home/subpages/profile/widgets/warning_btn.dart';

// Able to edit user's personal information
class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(personalInfoProvider);
    return AsyncPage(
      state: state,
      pageContent: (info) => _PersonalInfoContent(info: info),
      logTextOnError: (e, _) => 'Could not generate personal info page: $e',
    );
  }
}

class _PersonalInfoContent extends StatefulWidget {
  final PersonalInfoData info;
  const _PersonalInfoContent({required this.info});

  @override
  State<_PersonalInfoContent> createState() => _PersonalInfoContentState();
}

class _PersonalInfoContentState extends State<_PersonalInfoContent> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.info.profile.username,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _pickAvatar() {
    // TODO: Implement avatar picker logic
    uiLogger.warning("Pick avatar");
  }

  void _changePassword() {
    // TODO: Navigate to change password page
    uiLogger.warning("Change account");
  }

  void _confirmDeleteAccount() async {
    final bool? deleteAccount = await showDialog<bool>(
      context: context,
      builder: (_) {
        return ChoiceDialog(
          key: KPage.deleteAccountDialog.key,
          title: "Delete Account",
          content: "Are you sure you want to delete your account?",
          noText: "Cancel",
          yesText: "Delete",
          yesStyle: TextStyle(color: context.colors.alert),
        );
      },
    );
    uiLogger.warning("deleteAccount: $deleteAccount");
  }

  Widget _infoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              "$label:\n$value",
              style: TextStyle(color: context.colors.textPrimary),
            ),
          ),
          IconButton(
            color: context.colors.textPrimary,
            icon: Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$label copied to clipboard")),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    uiLogger.finer("Personal Info Page generated.");
    final profile = widget.info.profile;
    final user = widget.info.user;

    return SafeContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TopAppBar(
          title: "Personal Information",
          fg: context.colors.textPrimary,
          bg: context.colors.whiteBackground,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(baseLength / 2),
                  child: CircleAvatar(
                    backgroundColor: context.colors.mainColor,
                    radius: iconSizeVeryLarge,
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: iconSizeVeryLarge,
                            color: context.colors.whiteBackground,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: context.colors.textPrimary),
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.colors.textBoxUnderline,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: context.colors.mainColor,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: context.colors.alert),
                        ),
                      ),

                      onChanged: (value) {
                        // TODO: Handle username update
                      },
                    ),
                  ),
                  if (profile.verified)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.verified,
                        color: context.colors.mainColor,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),

              // Account Info
              Card(
                color: context.colors.mainColoredBox,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(label: "Local ID", value: user.localId),
                      _infoRow(
                        label: "Remote ID",
                        value: user.remoteId ?? "Not linked",
                      ),
                      _infoRow(label: "Email", value: profile.username),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              AlertBtn(
                text: "Change Password",
                color: context.colors.textSecondary,
                icon: Icons.password,
                onPressed: _changePassword,
              ),
              SizedBox(height: baseLength),
              AlertBtn(
                text: "Delete Account",
                color: context.colors.alert,
                icon: Icons.remove_circle_outline,
                onPressed: _confirmDeleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

              // Action Buttons
              // Column(
              //   children: [
              //     ElevatedButton(
              //       onPressed: _changePassword,
              //       child: Text("Change Password"),
              //     ),
              //     SizedBox(height: 12),
              //     ElevatedButton(
              //       onPressed: _confirmDeleteAccount,
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: context.colors.alert,
              //       ),
              //       child: Text("Delete Account"),
              //     ),
              //   ],
              // ),

// Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     InfoRow(
//       label: "Local ID",
//       value: widget.info.user.localId,
//     ),
//     InfoRow(
//       label: "Remote ID",
//       value: widget.info.user.remoteId ?? "Not linked",
//     ),
//     InfoRow(
//       label: "Email",
//       value: widget.info.profile.username, // or email field
//       editable: false,
//     ),
//   ],
// )

// body: Column(
//   children: [
//     GestureDetector(
//       onTap: () => _pickAvatar(), // implement image picker
//       child: CircleAvatar(
//         radius: 50,
//         backgroundImage: widget.info.profile.avatarUrl != null
//             ? NetworkImage(widget.info.profile.avatarUrl!)
//             : null,
//         child: widget.info.profile.avatarUrl == null
//             ? Icon(Icons.person, size: 50)
//             : null,
//       ),
//     ),
//     SizedBox(height: 12),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: TextFormField(
//             initialValue: widget.info.profile.username,
//             decoration: InputDecoration(
//               border: UnderlineInputBorder(),
//               labelText: "Username",
//             ),
//             onChanged: (value) => setState(() {
//               // handle username change
//             }),
//           ),
//         ),
//         if (widget.info.profile.verified)
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Icon(Icons.verified, color: Colors.blue),
//           ),
//       ],
//     ),
//   ],
// ),

// Scaffold(
//   // Selectable avatar circle image from avatarUrl
//   // Display localId and remoteId and copy button for easy copy
//   // Editable username
//   // Display logged in email (not editable)
//   // Change Password button
//   // Delete account button
//   // verified tag
// ),

// class InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool editable;

//   const InfoRow({super.key,
//     required this.label,
//     required this.value,
//     this.editable = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Expanded(child: Text("$label: $value")),
//           IconButton(
//             icon: Icon(Icons.copy),
//             onPressed: () {
//               Clipboard.setData(ClipboardData(text: value));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("$label copied to clipboard")),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
