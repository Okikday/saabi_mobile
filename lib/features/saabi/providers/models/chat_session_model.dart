import 'package:isar_community/isar.dart';
import 'package:saabi_mobile/features/saabi/providers/models/chat_message_model.dart';

part 'chat_session_model.g.dart';

@collection
class ChatSessionModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sessionId;

  late String title;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  @Backlink(to: 'session')
  final messages = IsarLinks<ChatMessageModel>();
}
