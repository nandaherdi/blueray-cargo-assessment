class DialogForegroundProcessModel {
  DialogForegroundProcessModel({
    required this.title,
    required this.message,
    required this.action,
    required this.buttonText,
  });

  String title;
  String message;
  Function action;
  String buttonText;
}
