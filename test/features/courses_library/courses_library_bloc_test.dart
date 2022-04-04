import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_bloc.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_event.dart';
import 'package:fiszkomaniak/features/courses_library/bloc/courses_library_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoursesBloc extends Mock implements CoursesBloc {}

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockDialogs extends Mock implements Dialogs {}

void main() {
  final CoursesBloc coursesBloc = MockCoursesBloc();
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final Dialogs dialogs = MockDialogs();
  late CoursesLibraryBloc bloc;
  final List<Course> courses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
    createCourse(id: 'c3'),
  ];
  void mockConfirmationAnswer(bool answer) {
    when(
      () => dialogs.askForConfirmation(
        title: 'Czy na pewno chcesz usunąć ten kurs?',
        text:
            'Usunięcie kursu spowoduje również usunięcie wszystkich grup oraz fiszek należących do tego kursu.',
        confirmButtonText: 'Usuń',
      ),
    ).thenAnswer((_) async => answer);
  }

  setUp(() {
    bloc = CoursesLibraryBloc(
      coursesBloc: coursesBloc,
      groupsBloc: groupsBloc,
      dialogs: dialogs,
    );
    when(() => coursesBloc.state).thenReturn(CoursesState(allCourses: courses));
    when(() => coursesBloc.stream).thenAnswer(
      (_) => Stream.value(CoursesState(allCourses: courses)),
    );
  });

  tearDown(() {
    reset(coursesBloc);
    reset(groupsBloc);
    reset(dialogs);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(CoursesLibraryEventInitialize()),
    expect: () => [
      CoursesLibraryState(courses: courses),
    ],
  );

  blocTest(
    'remove course, confirmed',
    build: () => bloc,
    setUp: () => mockConfirmationAnswer(true),
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    verify: (_) {
      verify(
        () => coursesBloc.add(CoursesEventRemoveCourse(courseId: 'c1')),
      ).called(1);
      verify(
        () => groupsBloc.add(GroupsEventRemoveGroupsFromCourse(courseId: 'c1')),
      ).called(1);
    },
  );

  blocTest(
    'remove course, cancelled',
    build: () => bloc,
    setUp: () => mockConfirmationAnswer(false),
    act: (_) => bloc.add(CoursesLibraryEventRemoveCourse(courseId: 'c1')),
    verify: (_) {
      verifyNever(
        () => coursesBloc.add(CoursesEventRemoveCourse(courseId: 'c1')),
      );
      verifyNever(
        () => groupsBloc.add(GroupsEventRemoveGroupsFromCourse(courseId: 'c1')),
      );
    },
  );
}
