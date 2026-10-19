// metadata_version: 1
// purpose: "Owns disposable form values; lifecycle clears secrets without resetting theme edits."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014]
import 'package:flutter/material.dart';

import 'registration.dart';

class CredentialDraft extends ChangeNotifier {
  final first = TextEditingController(),
      last = TextEditingController(),
      email = TextEditingController(),
      password = TextEditingController(),
      nickname = TextEditingController(),
      confirm = TextEditingController();
  bool useNickname = false;
  CredentialDraft() {
    for (final controller in controllers) {
      controller.addListener(notifyListeners);
    }
  }
  List<TextEditingController> get controllers => [
    first,
    last,
    email,
    password,
    nickname,
    confirm,
  ];
  Registration get registration => Registration(
    first.text,
    last.text,
    email.text,
    password.text,
    nickname: nickname.text,
    useNickname: useNickname,
  );
  void selectNickname(bool value) {
    useNickname = value;
    notifyListeners();
  }

  void clearSecrets() {
    password.clear();
    confirm.clear();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
