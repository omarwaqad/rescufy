import 'dart:developer' as developer;

import 'package:logging/logging.dart';
import 'package:rescufy/data/datasources/local/auth_local_datasource.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRHubConnectionFactory {
  SignalRHubConnectionFactory(this._authLocalDataSource);

  final AuthLocalDataSource _authLocalDataSource;

  Future<HubConnection> create({
    required String hubUrl,
    required String loggerName,
  }) async {
    final logger = Logger(loggerName);
    logger.onRecord.listen((record) {
      developer.log(
        record.message,
        name: loggerName,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });

    final token = await _authLocalDataSource.getToken();
    final headers = MessageHeaders();
    if (token != null && token.isNotEmpty) {
      headers.setHeaderValue(
        MessageHeaders.AuthorizationHeaderName,
        'Bearer $token',
      );
    }

    return HubConnectionBuilder()
        .configureLogging(logger)
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            headers: headers,
            accessTokenFactory: () async {
              final currentToken = await _authLocalDataSource.getToken();
              return currentToken ?? '';
            },
            transport: HttpTransportType.WebSockets,
            logger: logger,
            requestTimeout: 10000,
          ),
        )
        .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 30000])
        .build();
  }
}
