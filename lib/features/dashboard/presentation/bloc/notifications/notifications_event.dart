part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
}

class RequestNotificationPermission extends NotificationsEvent {}

class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  const NotificationReceived(this.pushMessage);
}

class LoadStoredNotifications extends NotificationsEvent {}

class ClearNotifications extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String messageId;
  const DeleteNotification(this.messageId);
}

class MarkNotificationAsRead extends NotificationsEvent {
  final String messageId;
  const MarkNotificationAsRead(this.messageId);
}

class MarkAllAsRead extends NotificationsEvent {}

class NotificationNavigate extends NotificationsEvent {
  final String route;
  const NotificationNavigate(this.route);
}

class NotificationNavigated extends NotificationsEvent {}

class SyncNotificationsFromApi extends NotificationsEvent {}

class OptimisticRemoveNotification extends NotificationsEvent {
  final String messageId;
  const OptimisticRemoveNotification(this.messageId);
}

class RefreshRequested extends NotificationsEvent {}
