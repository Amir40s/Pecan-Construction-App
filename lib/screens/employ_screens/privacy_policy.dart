import 'package:flutter/material.dart';
import 'package:pecan_construction/core/widgets/app_text.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool accepted = false;
  String lang = "EN";

  @override
  Widget build(BuildContext context) {
    final isEN = lang == "EN";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AppText(isEN ? "Privacy Policy" : "Datenschutzerklärung",fontSize: 20,fontWeight: FontWeight.w800,),
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
We value your privacy. This Privacy Policy explains how we collect, use, and protect your information when using this application.

1. Data We Collect
We may collect your name, email, account details, and uploaded files such as images or PDFs.

2. How We Use Data
We use data to provide application functionality, improve performance, and ensure security.

3. Data Sharing
We do not sell personal data. Data may be shared only with trusted service providers necessary to run the application.

4. Security
We use industry-standard security practices to protect your data.

5. Contact
For privacy questions contact: privacy@yourdomain.com
"""
                    : """
Wir respektieren Ihre Privatsphäre. Diese Datenschutzerklärung beschreibt, wie wir Ihre Daten erfassen und verwenden.

1. Erhobene Daten
Name, E-Mail, Kontodaten und hochgeladene Dateien können gespeichert werden.

2. Verwendung
Daten werden zur Bereitstellung der App-Funktionen und Sicherheit verwendet.

3. Weitergabe
Daten werden nicht verkauft und nur mit notwendigen Dienstleistern geteilt.

4. Sicherheit
Wir verwenden Sicherheitsmaßnahmen nach Industriestandards.

5. Kontakt
privacy@yourdomain.com
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
                    ? "I agree to Privacy Policy"
                    : "Ich stimme der Datenschutzerklärung zu"),
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
