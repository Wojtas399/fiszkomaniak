import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockRemoveCourseUseCase extends Mock implements RemoveCourseUseCase {}

class MockCoursesLibraryDialogs extends Mock implements CoursesLibraryDialogs {}

class MockNavigation extends Mock implements Navigation {}

void main() {
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final removeCourseUseCase = MockRemoveCourseUseCase();
  final coursesLibraryDialogs = MockCoursesLibraryDialogs();
  final navigation = MockNavigation();
  late CoursesLibraryBloc bloc;

  setUp(() {
    bloc = CoursesLibraryBloc(
      getAllCoursesUseCase: getAllCoursesUseCase,
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      removeCourseUseCase: removeCourseUseCase,
      coursesLibraryDialogs: coursesLibraryDialogs,
      navigation: navigation,
    );
  });

  tearDown(() {
    reset(getAllCoursesUseCase);
    reset(loadAllCoursesUseCase);
    reset(removeCourseUseCase);
    reset(coursesLibraryDialogs);
    reset(navigation);
  });

  blocTest(
    'initialize, should set all courses listener and call method responsible for loading them',
    build: () => bloc,
    setUp: () {
      when(
        () => getAllCoursesUseCase.execute(),
      ).thenAnswer(
        (_) => Stream.value([createCourse(id: 'c1')]),
      );
      when(() => loadAllCoursesUseCase.execute()).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(CoursesLibraryEventInitialize()),
    expect: () => [
      const CoursesLibraryState(
        status: BlocStatusLoading(),
      ),
      const CoursesLibraryState(
        status: BlocStatusComplete(),
      ),
      CoursesLibraryState(
        status: const BlocStatusComplete(),
        courses: [createCourse(id: 'c1')],
      ),
    ],
  );

  blocTest(
    'edit course, should navigate to course creator in edit mode',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToCourseCreator(
          CourseCreatorEditMode(course: createCourse(id: 'c1')),
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(
      CoursesLibraryEventEditCourse(course: createCourse(id: 'c1')),
    ),
    verify: (_) {
      verify(
        () => navigation.navigateToCourseCreator(
          CourseCreatorEditMode(course: createCourse(id: 'c1')),
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove course, should call remove course use case if confirmed',
    build: () => bloc,
    setUp: () {
      when(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => true);
      when(
        () => removeCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    expect: () => [
      const CoursesLibraryState(status: BlocStatusLoading()),
      const CoursesLibraryState(
        status: BlocStatusComplete(
          info: CoursesLibraryInfoType.courseHasBeenRemoved,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).called(1);
      verify(
        () => removeCourseUseCase.execute(courseId: 'c1'),
      ).called(1);
    },
  );

  blocTest(
    'remove course, should not call remove course use case if not confirmed',
    build: () => bloc,
    setUp: () {
      when(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => false);
      when(
        () => removeCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    expect: () => [],
    verify: (_) {
      verify(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).called(1);
      verifyNever(() => removeCourseUseCase.execute(courseId: 'c1'));
    },
  );

  blocTest(
    'courses updated, should update state',
    build: () => bloc,
    act: (_) => bloc.add(
      CoursesLibraryEventCoursesUpdated(
        updatedCourses: [
          createCourse(id: 'c1'),
          createCourse(id: 'c2'),
        ],
      ),
    ),
    expect: () => [
      CoursesLibraryState(
        status: const BlocStatusComplete(),
        courses: [
          createCourse(id: 'c1'),
          createCourse(id: 'c2'),
        ],
      ),
    ],
  );
}
