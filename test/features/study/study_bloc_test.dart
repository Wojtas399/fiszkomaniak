import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_all_groups_use_case.dart';
import 'package:fiszkomaniak/features/study/bloc/study_bloc.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllGroupsUseCase extends Mock implements GetAllGroupsUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

void main() {
  final getAllGroupsUseCase = MockGetAllGroupsUseCase();
  final getCourseUseCase = MockGetCourseUseCase();
  late StudyBloc bloc;

  setUp(() {
    bloc = StudyBloc(
      getAllGroupsUseCase: getAllGroupsUseCase,
      getCourseUseCase: getCourseUseCase,
    );
  });

  blocTest(
    'initialize, should set groups params listener',
    build: () => bloc,
    setUp: () {
      when(
        () => getAllGroupsUseCase.execute(),
      ).thenAnswer(
        (_) => Stream.value(
          [
            createGroup(
              id: 'g1',
              name: 'group 1',
              courseId: 'c1',
              flashcards: [
                createFlashcard(
                    index: 0, status: FlashcardStatus.notRemembered),
                createFlashcard(index: 1, status: FlashcardStatus.remembered),
                createFlashcard(index: 2, status: FlashcardStatus.remembered),
              ],
            ),
            createGroup(id: 'g2', name: 'group name 2', courseId: 'c1'),
          ],
        ),
      );
      when(
        () => getCourseUseCase.execute(courseId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(createCourse(id: 'c1', name: 'course 1')),
      );
    },
    act: (_) => bloc.add(StudyEventInitialize()),
    expect: () => [
      StudyState(
        groupsItemsParams: [
          createGroupItemParams(
            id: 'g1',
            name: 'group 1',
            courseName: 'course 1',
            amountOfRememberedFlashcards: 2,
            amountOfAllFlashcards: 3,
          ),
          createGroupItemParams(
            id: 'g2',
            name: 'group name 2',
            courseName: 'course 1',
          ),
        ],
      ),
    ],
  );

  blocTest(
    'groups items params changed, should update groups items params in state',
    build: () => bloc,
    act: (_) => bloc.add(
      StudyEventGroupsItemsParamsChanged(
        groupsItemsParams: [
          createGroupItemParams(id: 'g1', name: 'group 1'),
          createGroupItemParams(id: 'g2', name: 'group 2'),
        ],
      ),
    ),
    expect: () => [
      StudyState(
        groupsItemsParams: [
          createGroupItemParams(id: 'g1', name: 'group 1'),
          createGroupItemParams(id: 'g2', name: 'group 2'),
        ],
      ),
    ],
  );
}
