enum NotificationType {
  motivation,
  trigger,
  achievement,
  reminder,
}

abstract class NotificationObserver {
  void onNotificationReceived(String message, NotificationType type);
}
