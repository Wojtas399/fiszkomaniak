import 'package:fiszkomaniak/domain/entities/session.dart';

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
