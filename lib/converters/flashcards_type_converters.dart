import 'package:fiszkomaniak/models/session_model.dart';

String convertFlashcardsTypeToViewFormat(FlashcardsType? type) {
  switch (type) {
    case FlashcardsType.all:
      return 'Wszystkie';
    case FlashcardsType.remembered:
      return 'Zapamiętane';
    case FlashcardsType.notRemembered:
      return 'Niezapamiętane';
    case null:
      return '--';
  }
}
