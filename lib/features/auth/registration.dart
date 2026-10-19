// metadata_version: 1
// purpose: "Registration validation shared by the form and service boundary."
// owner: unassigned
// related_adrs: [ADR-0029, ADR-0014]
class Registration {
  const Registration(
    this.first,
    this.last,
    this.email,
    this.password, {
    this.nickname = '',
    this.useNickname = false,
  });
  final String first, last, email, password, nickname;
  final bool useNickname;
  bool get valid =>
      first.trim().isNotEmpty &&
      first.length <= 80 &&
      last.trim().isNotEmpty &&
      last.length <= 80 &&
      nickname.length <= 80 &&
      validEmail(email) &&
      password.length >= 12 &&
      password.length <= 128 &&
      (!useNickname || nickname.trim().isNotEmpty);
}

bool validEmail(String value) =>
    value.trim().length <= 254 &&
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
