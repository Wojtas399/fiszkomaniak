import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/course_item.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../config/navigation.dart';
import '../../course_creator/course_creator_mode.dart';
import '../components/courses_library_course_popup_menu.dart';

part 'courses_library_event.dart';

part 'courses_library_state.dart';

class CoursesLibraryBloc
    extends Bloc<CoursesLibraryEvent, CoursesLibraryState> {
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final RemoveCourseUseCase _removeCourseUseCase;
  late final GetGroupsByCourseIdUseCase _getGroupsByCourseIdUseCase;
  late final CoursesLibraryDialogs _coursesLibraryDialogs;
  late final Navigation _navigation;
  StreamSubscription<List<CourseItemParams>>? _coursesItemsParamsListener;

  CoursesLibraryBloc({
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required RemoveCourseUseCase removeCourseUseCase,
    required GetGroupsByCourseIdUseCase getGroupsByCourseIdUseCase,
    required CoursesLibraryDialogs coursesLibraryDialogs,
    required Navigation navigation,
  }) : super(const CoursesLibraryState()) {
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _removeCourseUseCase = removeCourseUseCase;
    _getGroupsByCourseIdUseCase = getGroupsByCourseIdUseCase;
    _coursesLibraryDialogs = coursesLibraryDialogs;
    _navigation = navigation;
    on<CoursesLibraryEventInitialize>(_initialize);
    on<CoursesLibraryEventCoursesItemsParamsUpdated>(
      _coursesItemsParamsUpdated,
    );
    on<CoursesLibraryEventCoursePressed>(_coursePressed);
    on<CoursesLibraryEventEditCourse>(_editCourse);
    on<CoursesLibraryEventRemoveCourse>(_removeCourse);
  }

  @override
  Future<void> close() {
    _coursesItemsParamsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    CoursesLibraryEventInitialize event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    _setCoursesParamsListener();
    await _loadAllCoursesUseCase.execute();
    emit(state.copyWith(
      status: const BlocStatusComplete(),
    ));
  }

  void _coursesItemsParamsUpdated(
    CoursesLibraryEventCoursesItemsParamsUpdated event,
    Emitter<CoursesLibraryState> emit,
  ) {
    emit(state.copyWith(
      coursesItemsParams: event.updatedCoursesItemsParams,
    ));
  }

  void _coursePressed(
    CoursesLibraryEventCoursePressed event,
    Emitter<CoursesLibraryState> emit,
  ) {
    _navigation.navigateToCourseGroupsPreview(event.courseId);
  }

  void _editCourse(
    CoursesLibraryEventEditCourse event,
    Emitter<CoursesLibraryState> emit,
  ) {
    _navigation.navigateToCourseCreator(
      CourseCreatorEditMode(course: event.course),
    );
  }

  Future<void> _removeCourse(
    CoursesLibraryEventRemoveCourse event,
    Emitter<CoursesLibraryState> emit,
  ) async {
    final bool confirmation =
        await _coursesLibraryDialogs.askForDeleteConfirmation();
    if (confirmation == true) {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _removeCourseUseCase.execute(courseId: event.courseId);
      emit(state.copyWith(
        status: const BlocStatusComplete(
          info: CoursesLibraryInfoType.courseHasBeenRemoved,
        ),
      ));
    }
  }

  void _setCoursesParamsListener() {
    _coursesItemsParamsListener = _getAllCoursesUseCase
        .execute()
        .switchMap(
          (courses) => Rx.combineLatest(
            courses.map(_createCourseItemParams),
            (List<CourseItemParams> coursesItemsParams) => coursesItemsParams,
          ),
        )
        .listen(
          (coursesItemsParams) => add(
            CoursesLibraryEventCoursesItemsParamsUpdated(
              updatedCoursesItemsParams: coursesItemsParams,
            ),
          ),
        );
  }

  Stream<CourseItemParams> _createCourseItemParams(Course course) {
    return _getGroupsByCourseIdUseCase.execute(courseId: course.id).map(
          (groupsFromCourse) => CourseItemParams(
            title: course.name,
            amountOfGroups: groupsFromCourse.length,
            onPressed: () => add(
              CoursesLibraryEventCoursePressed(courseId: course.id),
            ),
            onActionSelected: (CoursePopupAction action) {
              switch (action) {
                case CoursePopupAction.edit:
                  add(CoursesLibraryEventEditCourse(course: course));
                  break;
                case CoursePopupAction.remove:
                  add(CoursesLibraryEventRemoveCourse(courseId: course.id));
                  break;
              }
            },
          ),
        );
  }
}
