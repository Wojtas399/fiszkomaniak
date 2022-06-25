import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../components/group_item/group_item.dart';

part 'course_groups_preview_event.dart';

part 'course_groups_preview_state.dart';

class CourseGroupsPreviewBloc
    extends Bloc<CourseGroupsPreviewEvent, CourseGroupsPreviewState> {
  late final GetCourseUseCase _getCourseUseCase;
  late final GetGroupsByCourseIdUseCase _getGroupsByCourseIdUseCase;
  StreamSubscription<String>? _courseNameListener;
  StreamSubscription<List<GroupItemParams>>? _groupsListener;

  CourseGroupsPreviewBloc({
    required GetCourseUseCase getCourseUseCase,
    required GetGroupsByCourseIdUseCase getGroupsByCourseIdUseCase,
  }) : super(CourseGroupsPreviewState()) {
    _getCourseUseCase = getCourseUseCase;
    _getGroupsByCourseIdUseCase = getGroupsByCourseIdUseCase;
    on<CourseGroupsPreviewEventInitialize>(_initialize);
    on<CourseGroupsPreviewEventCourseNameUpdated>(_courseNameUpdated);
    on<CourseGroupsPreviewEventGroupsUpdated>(_groupsUpdated);
    on<CourseGroupsPreviewEventSearchValueChanged>(_searchValueChanged);
  }

  @override
  Future<void> close() {
    _courseNameListener?.cancel();
    _groupsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CourseGroupsPreviewEventInitialize event,
    Emitter<CourseGroupsPreviewState> emit,
  ) async {
    _setCourseNameListener(event.courseId);
    _setGroupsListener(event.courseId);
  }

  void _courseNameUpdated(
    CourseGroupsPreviewEventCourseNameUpdated event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(
      courseName: event.updatedCourseName,
    ));
  }

  void _groupsUpdated(
    CourseGroupsPreviewEventGroupsUpdated event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(
      groupsFromCourse: event.updatedGroups,
    ));
  }

  void _searchValueChanged(
    CourseGroupsPreviewEventSearchValueChanged event,
    Emitter<CourseGroupsPreviewState> emit,
  ) {
    emit(state.copyWith(searchValue: event.searchValue));
  }

  void _setCourseNameListener(final String courseId) {
    _courseNameListener = _getCourseUseCase
        .execute(courseId: courseId)
        .map((course) => course.name)
        .listen(
          (courseName) => add(CourseGroupsPreviewEventCourseNameUpdated(
            updatedCourseName: courseName,
          )),
        );
  }

  void _setGroupsListener(final String courseId) {
    _groupsListener = _getGroupsByCourseIdUseCase
        .execute(courseId: courseId)
        .switchMap(
          (groups) => Rx.combineLatest(
            groups.map(_getGroupItemParams),
            (List<GroupItemParams> groupsParams) => groupsParams,
          ),
        )
        .listen(
          (groupsParams) => add(
            CourseGroupsPreviewEventGroupsUpdated(
              updatedGroups: groupsParams,
            ),
          ),
        );
  }

  Stream<GroupItemParams> _getGroupItemParams(Group group) {
    return _getCourseUseCase.execute(courseId: group.courseId).map(
          (course) => GroupItemParams(
            id: group.id,
            name: group.name,
            courseName: course.name,
            amountOfRememberedFlashcards: group.flashcards
                .where(
                  (flashcard) => flashcard.status == FlashcardStatus.remembered,
                )
                .length,
            amountOfAllFlashcards: group.flashcards.length,
          ),
        );
  }
}
