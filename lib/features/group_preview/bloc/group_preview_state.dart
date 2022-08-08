part of 'group_preview_bloc.dart';

class GroupPreviewState extends Equatable {
  final BlocStatus status;
  final Group? group;
  final Course? course;

  const GroupPreviewState({
    required this.status,
    required this.group,
    required this.course,
  });

  @override
  List<Object> get props => [
        status,
        group ?? '',
        course ?? '',
      ];

  int get amountOfAllFlashcards => group?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards =>
      group?.flashcards.where(_isFlashcardRemembered).length ?? 0;

  bool get doesGroupExist => group != null;

  bool get isQuickSessionButtonDisabled => amountOfAllFlashcards == 0;

  GroupPreviewState copyWith({
    BlocStatus? status,
    Group? group,
    Course? course,
  }) {
    return GroupPreviewState(
      status: status ?? const BlocStatusInProgress(),
      group: group ?? this.group,
      course: course ?? this.course,
    );
  }

  GroupPreviewState copyWithInfo(GroupPreviewInfo info) {
    return copyWith(
      status: const BlocStatusComplete<GroupPreviewInfo>(
        info: GroupPreviewInfo.groupHasBeenDeleted,
      ),
    );
  }

  bool _isFlashcardRemembered(Flashcard flashcard) {
    return flashcard.status == FlashcardStatus.remembered;
  }
}

enum GroupPreviewInfo { groupHasBeenDeleted }
