import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/add_new_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/check_course_name_usage_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/update_course_name_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAddNewCourseUseCase extends Mock implements AddNewCourseUseCase {}

class MockCheckCourseNameUsageUseCase extends Mock
    implements CheckCourseNameUsageUseCase {}

class MockUpdateCourseNameUseCase extends Mock
    implements UpdateCourseNameUseCase {}

void main() {
  final addNewCourseUseCase = MockAddNewCourseUseCase();
  final checkCourseNameUsageUseCase = MockCheckCourseNameUsageUseCase();
  final updateCourseNameUseCase = MockUpdateCourseNameUseCase();
  late CourseCreatorBloc bloc;

  setUp(() {
    bloc = CourseCreatorBloc(
      addNewCourseUseCase: addNewCourseUseCase,
      checkCourseNameUsageUseCase: checkCourseNameUsageUseCase,
      updateCourseNameUseCase: updateCourseNameUseCase,
    );
  });

  tearDown(() {
    reset(addNewCourseUseCase);
    reset(checkCourseNameUsageUseCase);
    reset(updateCourseNameUseCase);
  });

  blocTest(
    'initialize, create mode, should set status and mode params',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseCreatorEventInitialize(
        mode: const CourseCreatorCreateMode(),
      ),
    ),
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        mode: const CourseCreatorCreateMode(),
      ),
    ],
  );

  blocTest(
    'initialize, edit mode, should set status, mode and course name params',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseCreatorEventInitialize(
        mode: CourseCreatorEditMode(
          course: createCourse(
            id: 'c1',
            name: 'course name',
          ),
        ),
      ),
    ),
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        mode: CourseCreatorEditMode(
          course: createCourse(
            id: 'c1',
            name: 'course name',
          ),
        ),
        courseName: 'course name',
      ),
    ],
  );

  blocTest(
    'course name changed, should set new course name',
    build: () => bloc,
    act: (_) => bloc.add(
      CourseCreatorEventCourseNameChanged(courseName: 'new course name'),
    ),
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        courseName: 'new course name',
      ),
    ],
  );

  blocTest(
    'save changes, should emit appropriate status if course name is already taken',
    build: () => bloc,
    setUp: () {
      when(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(CourseCreatorEventCourseNameChanged(courseName: 'courseName'));
      bloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusLoading(),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusCourseNameIsAlreadyTaken(),
        courseName: 'courseName',
      ),
    ],
    verify: (_) {
      verify(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).called(1);
    },
  );

  blocTest(
    'save changes, create mode, should call add new course use case',
    build: () => bloc,
    setUp: () {
      when(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => false);
      when(
        () => addNewCourseUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(CourseCreatorEventCourseNameChanged(courseName: 'courseName'));
      bloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusLoading(),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusCourseAdded(),
        courseName: 'courseName',
      ),
    ],
    verify: (_) {
      verify(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).called(1);
      verify(
        () => addNewCourseUseCase.execute(courseName: 'courseName'),
      ).called(1);
    },
  );

  blocTest(
    'save changes, edit mode, should call update course name use case',
    build: () => bloc,
    setUp: () {
      when(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => false);
      when(
        () => updateCourseNameUseCase.execute(
          courseId: 'c1',
          newCourseName: 'courseName',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) {
      bloc.add(
        CourseCreatorEventInitialize(
          mode: CourseCreatorEditMode(
            course: createCourse(id: 'c1', name: 'courseName'),
          ),
        ),
      );
      bloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      CourseCreatorState(
        status: CourseCreatorStatusLoaded(),
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'courseName'),
        ),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusLoading(),
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'courseName'),
        ),
        courseName: 'courseName',
      ),
      CourseCreatorState(
        status: CourseCreatorStatusCourseUpdated(),
        mode: CourseCreatorEditMode(
          course: createCourse(id: 'c1', name: 'courseName'),
        ),
        courseName: 'courseName',
      ),
    ],
    verify: (_) {
      verify(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).called(1);
      verify(
        () => updateCourseNameUseCase.execute(
          courseId: 'c1',
          newCourseName: 'courseName',
        ),
      ).called(1);
    },
  );
}
