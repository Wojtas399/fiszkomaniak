import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/components/course_item.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/remove_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_dialogs.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCoursesUseCase extends Mock implements GetAllCoursesUseCase {}

class MockLoadAllCoursesUseCase extends Mock implements LoadAllCoursesUseCase {}

class MockRemoveCourseUseCase extends Mock implements RemoveCourseUseCase {}

class MockGetGroupsByCourseIdUseCase extends Mock
    implements GetGroupsByCourseIdUseCase {}

class MockCoursesLibraryDialogs extends Mock implements CoursesLibraryDialogs {}

class MockNavigation extends Mock implements Navigation {}

void main() {
  final getAllCoursesUseCase = MockGetAllCoursesUseCase();
  final loadAllCoursesUseCase = MockLoadAllCoursesUseCase();
  final removeCourseUseCase = MockRemoveCourseUseCase();
  final getGroupsByCourseIdUseCase = MockGetGroupsByCourseIdUseCase();
  final coursesLibraryDialogs = MockCoursesLibraryDialogs();
  final navigation = MockNavigation();
  late CoursesLibraryBloc bloc;

  setUp(() {
    bloc = CoursesLibraryBloc(
      getAllCoursesUseCase: getAllCoursesUseCase,
      loadAllCoursesUseCase: loadAllCoursesUseCase,
      removeCourseUseCase: removeCourseUseCase,
      getGroupsByCourseIdUseCase: getGroupsByCourseIdUseCase,
      coursesLibraryDialogs: coursesLibraryDialogs,
      navigation: navigation,
    );
  });

  tearDown(() {
    reset(getAllCoursesUseCase);
    reset(loadAllCoursesUseCase);
    reset(removeCourseUseCase);
    reset(getGroupsByCourseIdUseCase);
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
        (_) => Stream.value([
          createCourse(id: 'c1', name: 'course name'),
        ]),
      );
      when(
        () => getGroupsByCourseIdUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value([
          createGroup(id: 'g1'),
          createGroup(id: 'g2'),
          createGroup(id: 'g3'),
        ]),
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
        coursesItemsParams: [
          createCourseItemParams(
            title: 'course name',
            amountOfGroups: 3,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'courses items params updated, should update state',
    build: () => bloc,
    act: (_) => bloc.add(
      CoursesLibraryEventCoursesItemsParamsUpdated(
        updatedCoursesItemsParams: [
          createCourseItemParams(
            title: 'course 1',
            amountOfGroups: 2,
          ),
          createCourseItemParams(
            title: 'course 2',
            amountOfGroups: 4,
          ),
        ],
      ),
    ),
    expect: () => [
      CoursesLibraryState(
        status: const BlocStatusComplete(),
        coursesItemsParams: [
          createCourseItemParams(
            title: 'course 1',
            amountOfGroups: 2,
          ),
          createCourseItemParams(
            title: 'course 2',
            amountOfGroups: 4,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'course pressed, should navigate to course groups preview',
    build: () => bloc,
    act: (_) => bloc.add(CoursesLibraryEventCoursePressed(courseId: 'c1')),
    verify: (_) {
      verify(() => navigation.navigateToCourseGroupsPreview('c1')).called(1);
    },
  );

  blocTest(
    'edit course, should navigate to course creator',
    build: () => bloc,
    setUp: () {
      when(
        () => navigation.navigateToCourseCreator(CourseCreatorEditMode(
          course: createCourse(id: 'c1'),
        )),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(CoursesLibraryEventEditCourse(
      course: createCourse(id: 'c1'),
    )),
    verify: (_) {
      verify(
        () => navigation.navigateToCourseCreator(CourseCreatorEditMode(
          course: createCourse(id: 'c1'),
        )),
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
}
