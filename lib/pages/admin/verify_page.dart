import 'package:flutter/material.dart';
import 'package:jointact_case_study/components/button_component.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/admin_home_page.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  TextEditingController devKeyTextEditingController = TextEditingController();

  @override
  void dispose() {
    devKeyTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: getTranslated(context, StringKeys.verify)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormFieldComponent(
                context: context,
                textEditingController: devKeyTextEditingController,
                hintText: "devKey",
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              ButtonComponent(
                text: getTranslated(context, StringKeys.verify),
                isWide: true,
                onPressed: devKeyTextEditingController.text.isEmpty
                    ? null
                    : () async {
                        if (devKeyTextEditingController.text == "833F0ACB-49F7-451C-A0C7-1EA68FDC5B6B") {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminHomePage(),
                              ),
                              (route) => false);
                        } else {
                          AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.wrongAttempt),
                              backgroundColor: dangerDark, icon: Icons.error);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
