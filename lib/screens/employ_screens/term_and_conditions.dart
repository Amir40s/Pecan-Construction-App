import 'package:flutter/material.dart';

import '../../core/widgets/app_text.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool accepted = false;
  String lang = "EN";

  @override
  Widget build(BuildContext context) {
    final isEN = lang == "EN";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AppText(isEN ? "Terms & Conditions" : "AGB", fontSize: 20,fontWeight: FontWeight.w800),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                lang = lang == "EN" ? "DE" : "EN";
              });
            },
            child: Text(
              lang == "EN" ? "DE" : "EN",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                isEN
                    ? """
By using this application, you agree to the following terms.

1. Usage
You agree to use the application only for authorized business purposes.

2. Accounts
You are responsible for keeping your account secure.

3. Content
Uploaded files remain your responsibility.

4. Availability
We may update or modify the application at any time.

5. Liability
The application is provided "as is" without warranties.
"""
                    : """
Durch Nutzung dieser App stimmen Sie den folgenden Bedingungen zu.

1. Nutzung
Die App darf nur für autorisierte Zwecke genutzt werden.

2. Konten
Sie sind für die Sicherheit Ihres Kontos verantwortlich.

3. Inhalte
Hochgeladene Dateien bleiben Ihre Verantwortung.

4. Verfügbarkeit
Die App kann jederzeit aktualisiert werden.

5. Haftung
Die App wird ohne Garantien bereitgestellt.
""",
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: accepted,
                onChanged: (v) {
                  setState(() => accepted = v!);
                },
              ),
              Expanded(
                child: Text(isEN
                    ? "I agree to Terms & Conditions"
                    : "Ich stimme den Bedingungen zu"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: accepted ? () => Navigator.pop(context) : null,
                child: Text(isEN ? "Continue" : "Weiter"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
