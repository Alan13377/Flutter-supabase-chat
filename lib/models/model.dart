// ignore_for_file: public_member_api_docs, sort_constructors_first
class Profile {
  final String id;
  final String username;
  final DateTime createdAt;
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  Profile.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        username = map["username"],
        createdAt = DateTime.parse(map["created_at"]);
}

class Message {
  final String id;
  final String profileId;
  final String content;
  final DateTime createdAt;
  final bool isMine;
  Message({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map["id"],
        profileId = map["profile_id"],
        content = map["content"],
        createdAt = DateTime.parse(map["created_at"]),
        isMine = myUserId == map["profile_id"];
}
