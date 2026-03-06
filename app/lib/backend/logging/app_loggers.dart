import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Some loggers, you might need to add your logger here
// like Logger('Appointments') to segregate the logs
final authLogger = Logger('Authentication');
final uiLogger = Logger('UI');
final navLogger = Logger('Navigation');
final settingsLogger = Logger('Settings');

final localDBLogger = Logger('Local DB');
final remoteDBLogger = Logger('Remote DB');
final syncLogger = Logger('Sync');

// Note that we have this, thus no need to log the state of all riverpod providers
// As it will be handled by this Observer
final class RiverpodObserver extends ProviderObserver {
  final _logger = Logger('Riverpod');

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    _logger.info(
      'Added ${context.provider.name ?? context.provider.runtimeType} = $value',
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _logger.info(
      'Updated ${context.provider.name ?? context.provider.runtimeType} from $previousValue => $newValue',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _logger.fine(
      'Disposed ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.shout(
      'Provider error: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }
}
