import 'package:isar_community/isar.dart';

part 'chat_message_model.g.dart';

enum ChatMessageType {
  user,
  assistantText,
  assistantAction,
}

@collection
class ChatMessageModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String messageId;

  @Index()
  late DateTime timestamp;

  @Enumerated(EnumType.name)
  late ChatMessageType type;

  /// The text content for [ChatMessageType.user] and [ChatMessageType.assistantText].
  String? text;

  /// For [ChatMessageType.assistantAction], the type of intent.
  String? intentType;

  /// For [ChatMessageType.assistantAction], a JSON string representing the intent's properties.
  String? intentData;

  /// Converts this Isar model to a domain [ChatMessage].
  /// Note: The actual ChatMessage subclass conversion happens in the Pod
  /// where we can inject the contentBuilders for actions.
}
