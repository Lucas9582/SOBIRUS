import 'package:sobrius_app/core/observers/notification_subject.dart';
import 'package:sobrius_app/core/observers/notification_observer.dart';

class NotificationService extends NotificationSubject {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  
  // RF03 - Notificações de motivação
  void sendMotivation(String message) {
    notify(message, NotificationType.motivation);
  }
  
  // RF17 - Alertas de gatilhos
  void sendTriggerAlert(String trigger) {
    notify('Gatilho identificado: $trigger', NotificationType.trigger);
  }
  
  // Conquistas
  void sendAchievement(String title) {
    notify('🏆 Conquista: $title', NotificationType.achievement);
  }
  
  // Lembretes
  void sendReminder(String message) {
    notify(message, NotificationType.reminder);
  }
}
