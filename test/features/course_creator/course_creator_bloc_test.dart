import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/add_new_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/check_course_name_usage_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/update_course_name_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_bloc.dart';
import 'package:fiszkomaniak/features/course_creator/bloc/course_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockAddNewCourseUseCase extends Mock implements AddNewCourseUseCase {}

class MockCheckCourseNameUsageUseCase extends Mock
    implements CheckCourseNameUsageUseCase {}

class MockUpdateCourseNameUseCase extends Mock
    implements UpdateCourseNameUseCase {}

void main() {
  final addNewCourseUseCase = MockAddNewCourseUseCase();
  final checkCourseNameUsageUseCase = MockCheckCourseNameUsageUseCase();
  final updateCourseNameUseCase = MockUpdateCourseNameUseCase();

  CourseCreatorBloc createBloc({
    CourseCreatorMode mode = const CourseCreatorCreateMode(),
    String courseName = '',
  }) {
    return CourseCreatorBloc(
      addNewCourseUseCase: addNewCourseUseCase,
      checkCourseNameUsageUseCase: checkCourseNameUsageUseCase,
      updateCourseNameUseCase: updateCourseNameUseCase,
      mode: mode,
      courseName: courseName,
    );
  }

  CourseCreatorState createState({
    BlocStatus status = const BlocStatusInProgress(),
    CourseCreatorMode mode = const CourseCreatorCreateMode(),
    String courseName = '',
  }) {
    return CourseCreatorState(
      status: status,
      mode: mode,
      courseName: courseName,
    );
  }

  tearDown(() {
    reset(addNewCourseUseCase);
    reset(checkCourseNameUsageUseCase);
    reset(updateCourseNameUseCase);
  });

  blocTest(
    'initialize, create mode, should update mode',
    build: () => createBloc(),
    act: (CourseCreatorBloc bloc) {
      bloc.add(
        CourseCreatorEventInitialize(
          mode: const CourseCreatorCreateMode(),
        ),
      );
    },
    expect: () => [
      createState(
        mode: const CourseCreatorCreateMode(),
      ),
    ],
  );

  group(
    'initialize, edit mode',
    () {
      final Course course = createCourse(
        id: 'c1',
        name: 'course name',
      );
      blocTest(
        'initialize, edit mode, should update mode and course name',
        build: () => createBloc(),
        act: (CourseCreatorBloc bloc) {
          bloc.add(
            CourseCreatorEventInitialize(
              mode: CourseCreatorEditMode(course: course),
            ),
          );
        },
        expect: () => [
          createState(
            mode: CourseCreatorEditMode(course: course),
            courseName: course.name,
          ),
        ],
      );
    },
  );

  blocTest(
    'course name changed, should update course name',
    build: () => createBloc(),
    act: (CourseCreatorBloc bloc) {
      bloc.add(
        CourseCreatorEventCourseNameChanged(courseName: 'new course name'),
      );
    },
    expect: () => [
      createState(
        courseName: 'new course name',
      ),
    ],
  );

  blocTest(
    'save changes, should emit appropriate status if course name is already taken',
    build: () => createBloc(courseName: 'courseName'),
    setUp: () {
      when(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => true);
    },
    act: (CourseCreatorBloc bloc) {
      bloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        courseName: 'courseName',
      ),
      createState(
        status: const BlocStatusError(
          error: CourseCreatorError.courseNameIsAlreadyTaken,
        ),
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
    'save changes, create mode, should call use case responsible for adding new course',
    build: () => createBloc(courseName: 'courseName'),
    setUp: () {
      when(
        () => checkCourseNameUsageUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => false);
      when(
        () => addNewCourseUseCase.execute(courseName: 'courseName'),
      ).thenAnswer((_) async => '');
    },
    act: (CourseCreatorBloc bloc) {
      bloc.add(CourseCreatorEventSaveChanges());
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        courseName: 'courseName',
      ),
      createState(
        status: const BlocStatusComplete(
          info: CourseCreatorInfo.courseHasBeenAdded,
        ),
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

  group(
    'save changes, edit mode',
    () {
      final Course course = createCourse(id: 'c1', name: 'courseName');
      const String newCourseName = 'new course name';
      final CourseCreatorMode mode = CourseCreatorEditMode(course: course);

      blocTest(
        'should call use case responsible for updating course',
        build: () => createBloc(
          mode: mode,
          courseName: newCourseName,
        ),
        setUp: () {
          when(
            () => checkCourseNameUsageUseCase.execute(
              courseName: newCourseName,
            ),
          ).thenAnswer((_) async => false);
          when(
            () => updateCourseNameUseCase.execute(
              courseId: course.id,
              newCourseName: newCourseName,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (CourseCreatorBloc bloc) {
          bloc.add(CourseCreatorEventSaveChanges());
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            mode: mode,
            courseName: newCourseName,
          ),
          createState(
            status: const BlocStatusComplete(
              info: CourseCreatorInfo.courseHasBeenUpdated,
            ),
            mode: mode,
            courseName: newCourseName,
          ),
        ],
        verify: (_) {
          verify(
            () => checkCourseNameUsageUseCase.execute(
              courseName: newCourseName,
            ),
          ).called(1);
          verify(
            () => updateCourseNameUseCase.execute(
              courseId: course.id,
              newCourseName: newCourseName,
            ),
          ).called(1);
        },
      );
    },
  );
}
