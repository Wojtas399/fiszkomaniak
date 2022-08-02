part of 'group_preview_bloc.dart';

class GroupPreviewState extends Equatable {
  final BlocStatus status;
  final Group? group;
  final Course? course;

  const GroupPreviewState({
    this.status = const BlocStatusInitial(),
    this.group,
    this.course,
  });

  @override
  List<Object> get props => [
        status,
        group ?? createGroup(),
        course ?? createCourse(),
      ];

  int get amountOfAllFlashcards => group?.flashcards.length ?? 0;

  int get amountOfRememberedFlashcards =>
      group?.flashcards.where(_isFlashcardRemembered).length ?? 0;

  bool get isQuickSessionButtonDisabled => amountOfAllFlashcards == 0;

  GroupPreviewState copyWith({
    BlocStatus? status,
    Group? group,
    Course? course,
  }) {
    return GroupPreviewState(
      status: status ?? const BlocStatusComplete<GroupPreviewInfoType>(),
      group: group ?? this.group,
      course: course ?? this.course,
    );
  }

  bool _isFlashcardRemembered(Flashcard flashcard) {
    return flashcard.status == FlashcardStatus.remembered;
  }
}

enum GroupPreviewInfoType { groupHasBeenRemoved }
