part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {

  final AuthorizationStatus status;
  final List<PushMessage> notifications;

  final String? navigateToRoute;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined, 
    this.notifications = const[],
    this.navigateToRoute,
  });

  int get unreadCount => notifications.where((n) => !n.read).length;

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
    String? navigateToRoute,
  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
    navigateToRoute: navigateToRoute,
  );
  
  @override
  List<Object?> get props => [status, notifications, navigateToRoute];
}
