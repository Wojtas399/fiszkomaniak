import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_all_groups_use_case.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'study_event.dart';

part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  late final GetAllGroupsUseCase _getAllGroupsUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  StreamSubscription<List<GroupItemParams>>? _groupsItemsParamsListener;

  StudyBloc({
    required GetAllGroupsUseCase getAllGroupsUseCase,
    required GetCourseUseCase getCourseUseCase,
  }) : super(const StudyState()) {
    _getAllGroupsUseCase = getAllGroupsUseCase;
    _getCourseUseCase = getCourseUseCase;
    on<StudyEventInitialize>(_initialize);
    on<StudyEventGroupsItemsParamsChanged>(_groupsItemsParamsChanged);
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
    _groupsItemsParamsListener = _getAllGroupsUseCase
        .execute()
        .flatMap(
          (groups) => Rx.combineLatest(
            groups.map(_createGroupItemParams),
            (List<GroupItemParams> items) => items,
          ),
        )
        .listen(
          (groupsItemsParams) => add(
            StudyEventGroupsItemsParamsChanged(
              groupsItemsParams: groupsItemsParams,
            ),
          ),
        );
  }

  void _groupsItemsParamsChanged(
    StudyEventGroupsItemsParamsChanged event,
    Emitter<StudyState> emit,
  ) {
    emit(state.copyWith(groupsItemsParams: event.groupsItemsParams));
  }

  Stream<GroupItemParams> _createGroupItemParams(Group group) {
    return _getCourseUseCase
        .execute(courseId: group.courseId)
        .map((course) => course.name)
        .map(
          (String courseName) => GroupItemParams(
            id: group.id,
            name: group.name,
            courseName: courseName,
            amountOfAllFlashcards: group.flashcards.length,
            amountOfRememberedFlashcards: group.flashcards
                .where(
                  (flashcard) => flashcard.status == FlashcardStatus.remembered,
                )
                .length,
          ),
        );
  }
}
