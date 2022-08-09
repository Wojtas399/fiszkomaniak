import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/delete_course_use_case.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockDeleteCourseUseCase extends Mock implements DeleteCourseUseCase {}

class MockCoursesLibraryDialogs extends Mock implements CoursesLibraryDialogs {}

void main() {
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final deleteCourseUseCase = MockDeleteCourseUseCase();
  final coursesLibraryDialogs = MockCoursesLibraryDialogs();

  CoursesLibraryBloc createBloc() {
    return CoursesLibraryBloc(
      getAllCoursesUseCase: getAllCoursesUseCase,
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      deleteCourseUseCase: deleteCourseUseCase,
      coursesLibraryDialogs: coursesLibraryDialogs,
    );
  }

  CoursesLibraryState createState({
    BlocStatus status = const BlocStatusInProgress(),
    List<Course> allCourses = const [],
  }) {
    return CoursesLibraryState(
      status: status,
      allCourses: allCourses,
    );
  }

  tearDown(() {
    reset(getAllCoursesUseCase);
    reset(loadAllCoursesUseCase);
    reset(deleteCourseUseCase);
    reset(coursesLibraryDialogs);
  });

  group(
    'initialize',
    () {
      final List<Course> allCourses = [
        createCourse(id: 'c1', name: 'course 1'),
        createCourse(id: 'c2', name: 'course 2'),
      ];

      blocTest(
        'should call method responsible for loading all courses and should set listener for theses courses',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getAllCoursesUseCase.execute(),
          ).thenAnswer((_) => Stream.value(allCourses));
          when(
            () => loadAllCoursesUseCase.execute(),
          ).thenAnswer((_) async => '');
        },
        act: (CoursesLibraryBloc bloc) {
          bloc.add(CoursesLibraryEventInitialize());
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
          ),
          createState(
            status: const BlocStatusInProgress(),
            allCourses: allCourses,
          ),
        ],
        verify: (_) {
          verify(
            () => loadAllCoursesUseCase.execute(),
          ).called(1);
        },
      );
    },
  );

  group(
    'all courses updated',
    () {
      final List<Course> allCourses = [
        createCourse(id: 'c1'),
        createCourse(id: 'c2'),
      ];

      blocTest(
        'should update all courses in state',
        build: () => createBloc(),
        act: (CoursesLibraryBloc bloc) {
          bloc.add(
            CoursesLibraryEventAllCoursesUpdated(allCourses: allCourses),
          );
        },
        expect: () => [
          createState(
            allCourses: allCourses,
          ),
        ],
      );
    },
  );

  blocTest(
    'delete course, confirmed, should call use case responsible for deleting course',
    build: () => createBloc(),
    setUp: () {
      when(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => true);
      when(
        () => deleteCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) async => '');
    },
    act: (CoursesLibraryBloc bloc) {
      bloc.add(
        CoursesLibraryEventDeleteCourse(courseId: 'c1'),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<CoursesLibraryInfoType>(
          info: CoursesLibraryInfoType.courseHasBeenRemoved,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteCourseUseCase.execute(courseId: 'c1'),
      ).called(1);
    },
  );

  blocTest(
    'delete course, cancelled, should not call use case responsible for deleting course',
    build: () => createBloc(),
    setUp: () {
      when(
        () => coursesLibraryDialogs.askForDeleteConfirmation(),
      ).thenAnswer((_) async => false);
      when(
        () => deleteCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer((_) async => '');
    },
    act: (CoursesLibraryBloc bloc) {
      bloc.add(
        CoursesLibraryEventDeleteCourse(courseId: 'c1'),
      );
    },
    verify: (_) {
      verifyNever(
        () => deleteCourseUseCase.execute(courseId: 'c1'),
      );
    },
  );
}
