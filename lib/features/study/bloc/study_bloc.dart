import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../interfaces/courses_interface.dart';

part 'study_event.dart';

part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  late final CoursesInterface _coursesInterface;
  late final GroupsInterface _groupsInterface;
  late final FlashcardsInterface _flashcardsInterface;
  StreamSubscription<List<GroupItemParams>>? _groupsItemsListener;

  StudyBloc({
    required CoursesInterface coursesInterface,
    required GroupsInterface groupsInterface,
    required FlashcardsInterface flashcardsInterface,
  }) : super(const StudyState()) {
    _coursesInterface = coursesInterface;
    _groupsInterface = groupsInterface;
    _flashcardsInterface = flashcardsInterface;
    on<StudyEventInitialize>(_initialize);
    on<StudyEventGroupsItemsChanged>(_groupsItemsChanged);
  }

  @override
  Future<void> close() {
    _groupsItemsListener?.cancel();
    return super.close();
  }

  void _initialize(
    StudyEventInitialize event,
    Emitter<StudyState> emit,
  ) {
    _groupsItemsListener = _groupsInterface.allGroups$
        .flatMap(
          (groups) => Rx.combineLatest(
            groups.map(_createGroupItemParams),
            (List<GroupItemParams> items) => items,
          ),
        )
        .listen(
          (groupsItems) => add(
            StudyEventGroupsItemsChanged(groupsItems: groupsItems),
          ),
        );
  }

  void _groupsItemsChanged(
    StudyEventGroupsItemsChanged event,
    Emitter<StudyState> emit,
  ) {
    emit(state.copyWith(groupsItems: event.groupsItems));
  }

  Stream<GroupItemParams> _createGroupItemParams(Group group) {
    return Rx.combineLatest3(
      _coursesInterface.getCourseNameById(group.courseId),
      _flashcardsInterface.getAmountOfAllFlashcardsFromGroup(groupId: group.id),
      _flashcardsInterface.getAmountOfRememberedFlashcardsFromGroup(
        groupId: group.id,
      ),
      (
        String courseName,
        int amountOfAllFlashcards,
        int amountOfRememberedFlashcards,
      ) =>
          GroupItemParams(
        groupId: group.id,
        groupName: group.name,
        courseName: courseName,
        amountOfAllFlashcards: amountOfAllFlashcards,
        amountOfRememberedFlashcards: amountOfRememberedFlashcards,
      ),
    );
  }
}
