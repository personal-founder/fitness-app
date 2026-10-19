// metadata_version: 1
// purpose: "Private display model; tags are assigned by PostgreSQL, never the client."
// owner: unassigned
// related_adrs: [ADR-0015]
class AccountProfile {
  const AccountProfile({
    required this.firstName,
    required this.lastName,
    required this.tag,
    this.nickname,
    this.useNickname = false,
  });
  final String firstName, lastName, tag;
  final String? nickname;
  final bool useNickname;
  String get displayName =>
      useNickname && (nickname?.trim().isNotEmpty ?? false)
      ? nickname!.trim()
      : '$firstName $lastName'.trim();
  factory AccountProfile.fromJson(Map<String, dynamic> data) => AccountProfile(
    firstName: data['first_name'] as String,
    lastName: data['last_name'] as String,
    tag: data['account_tag'] as String,
    nickname: data['nickname'] as String?,
    useNickname: data['display_name_mode'] == 'nickname',
  );
}
