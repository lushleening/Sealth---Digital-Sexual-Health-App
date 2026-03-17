import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/personal_info/edit_details/edit_details_form.dart';
import 'package:sddp_dsh/backend/personal_info/personal_info/personal_info_data.dart';
import 'package:sddp_dsh/backend/user/app_registered_profile/app_registered_profile.dart';
import 'package:sddp_dsh/frontend/common_widgets/input_box.dart';

class EditUsername extends ConsumerStatefulWidget {
  final PersonalInfoData data;
  const EditUsername({super.key, required this.data});

  @override
  ConsumerState<EditUsername> createState() => _EditFieldsState();
}

class _EditFieldsState extends ConsumerState<EditUsername> {
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.data.profile!.username,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editDetailsFormProvider);
    final notifier = ref.read(editDetailsFormProvider.notifier);
    final e = state.inputEnabled;

    ref.listen(editDetailsFormProvider, (previous, next) {
      // When editing gets disabled, refill username
      if (previous?.inputEnabled == true && next.inputEnabled == false) {
        _usernameController.text = widget.data.profile!.username;
      }
    });

    // Catch server username update
    ref.listen(appRegisteredProfileProvider.select((p) => p.value?.username), (
      _,
      username,
    ) {
      if (!state.inputEnabled && username != null) {
        _usernameController.text = username;
      }
    });

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: baseLength / 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor: context.colors.mainColor,
                    ),
                  ),
                  child: TextFormField(
                    onChanged: notifier.setUsernameError,
                    enabled: e,
                    style: TextStyle(color: context.colors.textPrimary),
                    cursorColor: context.colors.mainColor,
                    cursorErrorColor: context.colors.alert,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(
                        color: e
                            ? context.colors.mainColor
                            : context.colors.textPrimary,
                      ),
                      labelText: "Username",
                      filled: true,
                      fillColor: Colors.transparent,
                      disabledBorder: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: context.colors.mainColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: context.colors.mainColor),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: context.colors.alert),
                      ),
                    ),
                  ),
                ),
              ),

              if (e) ...[
                const SizedBox(width: baseLength / 2),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.mainColor, // text color
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(horizontal: baseLength / 2),
                    disabledForegroundColor: context.colors.textSecondary,
                  ),
                  onPressed: state.hasErrors && !state.submitting
                      ? null
                      : () async {
                          await notifier.changeUsername(
                            widget.data.user.remoteId!,
                            _usernameController.text,
                            widget.data.profile!,
                          );
                        },
                  child: const Text("Save"),
                ),
              ],
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: baseLength),
            child: InputError(text: state.usernameError),
          ),
        ],
      ),
    );
  }
}
