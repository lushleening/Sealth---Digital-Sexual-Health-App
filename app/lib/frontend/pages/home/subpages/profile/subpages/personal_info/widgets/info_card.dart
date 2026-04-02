import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sddp_dsh/backend/authentication/supabase/supabase_auth.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/backend/personal_info/personal_info/personal_info_data.dart';

// Account Other Info
class InfoCard extends StatelessWidget {
  final PersonalInfoData data;
  const InfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final verified = data.profile!.verified;

    return Card(
      color: context.colors.mainColoredBox,
      child: Padding(
        padding: const EdgeInsets.all(baseLength),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final email = ref.read(supabaseAuthProvider).email;
                return email != null
                    ? InfoRow(label: "Email", value: email)
                    : const SizedBox.shrink();
              },
            ),
            InfoRow(
              label: "Verification Status",
              value: verified ? "Verified" : "Not Verified",
              valueStyle: verified
                  ? TextStyle(
                      color: context.colors.mainColor,
                      fontWeight: FontWeight.w700,
                    )
                  : null,
              copyable: false,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;
  final bool copyable;
  final TextStyle? valueStyle;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.editable = true,
    this.valueStyle,
    this.copyable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: baseLength / 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SelectableText(
                  value,
                  style:
                      valueStyle ??
                      TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),

          IconButton(
            color: copyable ? context.colors.textPrimary : Colors.transparent,
            icon: Icon(Icons.copy),
            style: IconButton.styleFrom(
              disabledForegroundColor: Colors.transparent,
            ),
            onPressed: copyable
                ? () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$label copied to clipboard")),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
