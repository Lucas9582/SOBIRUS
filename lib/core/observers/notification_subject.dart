import 'package:sobrius_app/core/observers/notification_observer.dart';

class NotificationSubject {
  final List<NotificationObserver> _observers = [];
  
  void attach(NotificationObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }
  
  void detach(NotificationObserver observer) {
    _observers.remove(observer);
  }
  
  void notify(String message, NotificationType type) {
    for (var observer in _observers) {
      try {
        observer.onNotificationReceived(message, type);
      } catch (e) {
        print('Erro ao notificar observador: $e');
      }
    }
  }
}
