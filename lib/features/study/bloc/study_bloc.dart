import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../interfaces/courses_interface.dart';

part 'study_event.dart';

part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  late final CoursesInterface _coursesInterface;
  late final GroupsInterface _groupsInterface;
  StreamSubscription<List<GroupItemParams>>? _groupsItemsParamsListener;

  StudyBloc({
    required CoursesInterface coursesInterface,
    required GroupsInterface groupsInterface,
  }) : super(const StudyState()) {
    _coursesInterface = coursesInterface;
    _groupsInterface = groupsInterface;
    on<StudyEventInitialize>(_initialize);
    on<StudyEventGroupsItemsChanged>(_groupsItemsChanged);
  }

  @override
  Future<void> close() {
    _groupsItemsParamsListener?.cancel();
    return super.close();
  }

  void _initialize(
    StudyEventInitialize event,
    Emitter<StudyState> emit,
  ) {
    _groupsItemsParamsListener = _groupsInterface.allGroups$
        .flatMap(
          (groups) => Rx.combineLatest(
            groups.map(_createGroupItemParams),
            (List<GroupItemParams> items) => items,
          ),
        )
        .listen(
          (groupsItemsParams) => add(
            StudyEventGroupsItemsChanged(groupsItemsParams: groupsItemsParams),
          ),
        );
  }

  void _groupsItemsChanged(
    StudyEventGroupsItemsChanged event,
    Emitter<StudyState> emit,
  ) {
    emit(state.copyWith(groupsItemsParams: event.groupsItemsParams));
  }

  Stream<GroupItemParams> _createGroupItemParams(Group group) {
    return _coursesInterface.getCourseNameById(group.courseId).map(
          (String courseName) => GroupItemParams(
            name: group.name,
            courseName: courseName,
            amountOfAllFlashcards: group.flashcards.length,
            amountOfRememberedFlashcards: group.flashcards
                .where(
                  (flashcard) => flashcard.status == FlashcardStatus.remembered,
                )
                .length,
            onPressed: () {
              //TODO
            },
          ),
        );
  }
}
