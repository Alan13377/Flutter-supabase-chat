import 'package:chat_app/models/model.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/message_bar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const ChatPage());
  }

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  final Map<String, Profile> _profileCache = {};

  @override
  @override
  void initState() {
    final myUserId = supabase.auth.currentUser!.id;
    _messagesStream = supabase
        .from("messages")
        .stream(primaryKey: ["id"])
        .order("created_at")
        .map(
          (maps) => maps
              .map((map) => Message.fromMap(map: map, myUserId: myUserId))
              .toList(),
        );
    super.initState();
  }

  Future<void> _loadProfileCache(String profileId) async {
    if (_profileCache["profileId"] != null) {
      return;
    }

    final data =
        await supabase.from("profiles").select().eq("id", profileId).single();
    final profile = Profile.fromMap(data);

    setState(() {
      _profileCache[profileId] = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text("Inicia tu conversacion ahora"),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            _loadProfileCache(message.profileId);
                            return ChatBubble(
                              message: message,
                              profile: _profileCache[message.profileId],
                            );
                          },
                        ),
                ),
                const MessageBar(),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}
