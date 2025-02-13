import 'dart:convert';
import 'dart:io';

import 'package:categorease/core/app_logger.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketModel extends Equatable {
  final int roomId;
  final WebSocketChannel channel;
  final bool listened;
  late final Stream broadcastStream;

  WebsocketModel({
    required this.roomId,
    required this.channel,
    this.listened = false,
  }) {
    broadcastStream = channel.stream.asBroadcastStream();
  }

  // copywith
  WebsocketModel copyWith({
    int? roomId,
    WebSocketChannel? channel,
    bool? listened,
  }) {
    return WebsocketModel(
      roomId: roomId ?? this.roomId,
      channel: channel ?? this.channel,
      listened: listened ?? this.listened,
    );
  }

  @override
  List<Object?> get props => [
        roomId,
        channel,
        broadcastStream,
      ];
}

class WebsocketHelper {
  final AppLogger _logger;

  WebsocketHelper({AppLogger? logger}) : _logger = logger ?? AppLoggerImpl();

  Future<WebSocketChannel> connect(int roomId, String accessToken) async {
    final baseUrl = Constants.getDevWebsocketUrl();
    WebSocketChannel channel = WebSocketChannel.connect(
      Uri.parse('$baseUrl/ws/$roomId/$accessToken'),
    );

    // FIXME: better error handling
    try {
      await channel.ready;
    } on SocketException catch (e, s) {
      _logger.error(
        'Error while trying to connect into websocket [SocketException]',
        e,
        s,
      );
    } on WebSocketChannelException catch (e, s) {
      _logger.error(
        'Error while trying to connect into websocket [WebSocketCHannelException]',
        e,
        s,
      );
    }

    return channel;
  }

  static void sendMessage(WebsocketModel model, String message) async {
    final Map<String, dynamic> json = Chat.message(content: message).toJson();

    json.remove('created_at');
    json.remove('updated_at');

    final constructedMessage = jsonEncode(json);

    model.channel.sink.add(
      constructedMessage,
    );
  }
}
