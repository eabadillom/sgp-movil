class NotificationFlag 
{
  static final NotificationFlag _instance = NotificationFlag._internal();

  factory NotificationFlag() => _instance;

  NotificationFlag._internal();

  bool newNotificationArrived = false;
}