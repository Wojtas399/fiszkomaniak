import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../domain/use_cases/courses/get_all_courses_use_case.dart';
import '../../../domain/use_cases/courses/load_all_courses_use_case.dart';
import '../../../domain/use_cases/groups/add_group_use_case.dart';
import '../../../domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import '../../../domain/use_cases/groups/update_group_use_case.dart';
import '../../../models/bloc_status.dart';
import '../group_creator_mode.dart';

part 'group_creator_event.dart';

part 'group_creator_state.dart';

class GroupCreatorBloc extends Bloc<GroupCreatorEvent, GroupCreatorState> {
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final CheckGroupNameUsageInCourseUseCase
      _checkGroupNameUsageInCourseUseCase;
  late final AddGroupUseCase _addGroupUseCase;
  late final UpdateGroupUseCase _updateGroupUseCase;

  GroupCreatorBloc({
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required CheckGroupNameUsageInCourseUseCase
        checkGroupNameUsageInCourseUseCase,
    required AddGroupUseCase addGroupUseCase,
    required UpdateGroupUseCase updateGroupUseCase,
    GroupCreatorMode mode = const GroupCreatorCreateMode(),
    BlocStatus status = const BlocStatusInitial(),
    Course? selectedCourse,
    List<Course> allCourses = const [],
    String groupName = '',
    String nameForQuestions = '',
    String nameForAnswers = '',
  }) : super(
          GroupCreatorState(
            mode: mode,
            status: status,
            selectedCourse: selectedCourse,
            allCourses: allCourses,
            groupName: groupName,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ),
        ) {
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _checkGroupNameUsageInCourseUseCase = checkGroupNameUsageInCourseUseCase;
    _addGroupUseCase = addGroupUseCase;
    _updateGroupUseCase = updateGroupUseCase;
    on<GroupCreatorEventInitialize>(_initialize);
    on<GroupCreatorEventCourseChanged>(_onCourseChanged);
    on<GroupCreatorEventGroupNameChanged>(_onGroupNameChanged);
    on<GroupCreatorEventNameForQuestionsChanged>(_onNameForQuestionsChanged);
    on<GroupCreatorEventNameForAnswersChanged>(_onNameForAnswersChanged);
    on<GroupCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    GroupCreatorEventInitialize event,
    Emitter<GroupCreatorState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _loadAllCoursesUseCase.execute();
    final List<Course> allCourses = await _getAllCoursesUseCase.execute().first;
    final GroupCreatorMode mode = event.mode;
    if (mode is GroupCreatorCreateMode) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
        mode: mode,
        allCourses: allCourses,
      ));
    } else if (mode is GroupCreatorEditMode) {
      emit(state.copyWith(
        mode: mode,
        status: const BlocStatusComplete(),
        selectedCourse: allCourses.firstWhere(
          (course) => course.id == mode.group.courseId,
        ),
        allCourses: allCourses,
        groupName: mode.group.name,
        nameForQuestions: mode.group.nameForQuestions,
        nameForAnswers: mode.group.nameForAnswers,
      ));
    }
  }

  void _onCourseChanged(
    GroupCreatorEventCourseChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(
      selectedCourse: event.course,
    ));
  }

  void _onGroupNameChanged(
    GroupCreatorEventGroupNameChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(
      groupName: event.groupName,
    ));
  }

  void _onNameForQuestionsChanged(
    GroupCreatorEventNameForQuestionsChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(
      nameForQuestions: event.nameForQuestions,
    ));
  }

  void _onNameForAnswersChanged(
    GroupCreatorEventNameForAnswersChanged event,
    Emitter<GroupCreatorState> emit,
  ) {
    emit(state.copyWith(nameForAnswers: event.nameForAnswers));
  }

  Future<void> _submit(
    GroupCreatorEventSubmit event,
    Emitter<GroupCreatorState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    if (_shouldCheckGroupName() && await _isGroupNameAlreadyTaken()) {
      emit(state.copyWithError(
        GroupCreatorError.groupNameIsAlreadyTaken,
      ));
    } else {
      await _doAppropriateSubmitOperation(emit);
    }
  }

  Future<void> _doAppropriateSubmitOperation(
    Emitter<GroupCreatorState> emit,
  ) async {
    final GroupCreatorMode mode = state.mode;
    final String groupName = state.groupName.trim();
    final String nameForQuestions = state.nameForQuestions.trim();
    final String nameForAnswers = state.nameForAnswers.trim();
    final String? selectedCourseId = state.selectedCourse?.id;
    if (selectedCourseId != null) {
      if (mode is GroupCreatorCreateMode) {
        await _addGroup(
          name: groupName,
          courseId: selectedCourseId,
          nameForQuestions: nameForQuestions,
          nameForAnswers: nameForAnswers,
          emit: emit,
        );
      } else if (mode is GroupCreatorEditMode) {
        await _updateGroup(
          id: mode.group.id,
          name: groupName,
          courseId: selectedCourseId,
          nameForQuestions: nameForQuestions,
          nameForAnswers: nameForAnswers,
          emit: emit,
        );
      }
    }
  }

  Future<void> _addGroup({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
    required Emitter<GroupCreatorState> emit,
  }) async {
    await _addGroupUseCase.execute(
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
    emit(state.copyWithInfo(
      GroupCreatorInfo.groupHasBeenAdded,
    ));
  }

  Future<void> _updateGroup({
    required String id,
    required Emitter<GroupCreatorState> emit,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
  }) async {
    await _updateGroupUseCase.execute(
      groupId: id,
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
    emit(state.copyWithInfo(
      GroupCreatorInfo.groupHasBeenEdited,
    ));
  }

  bool _shouldCheckGroupName() {
    final GroupCreatorMode mode = state.mode;
    return (mode is GroupCreatorCreateMode) ||
        (mode is GroupCreatorEditMode && mode.group.name != state.groupName);
  }

  Future<bool> _isGroupNameAlreadyTaken() async {
    final String groupName = state.groupName;
    final String? courseId = state.selectedCourse?.id;
    if (courseId != null) {
      return await _checkGroupNameUsageInCourseUseCase.execute(
        groupName: groupName,
        courseId: courseId,
      );
    }
    return false;
  }
}
