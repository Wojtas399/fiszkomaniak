import 'package:flutter/material.dart';
import '../domain/entities/flashcard.dart';

extension FlashcardStatusExtensions on FlashcardStatus {
  String toUIFormat() {
    switch (this) {
      case FlashcardStatus.remembered:
        return 'Zapamiętana';
      case FlashcardStatus.notRemembered:
        return 'Niezapamiętana';
    }
  }

  Color toColor() {
    switch (this) {
      case FlashcardStatus.remembered:
        return Colors.green;
      case FlashcardStatus.notRemembered:
        return Colors.red;
    }
  }
}
