import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/load_all_courses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/add_session_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/update_session_use_case.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../models/time_model.dart';
import '../../../utils/group_utils.dart';
import '../../../utils/time_utils.dart';

part 'session_creator_event.dart';

part 'session_creator_state.dart';

class SessionCreatorBloc
    extends Bloc<SessionCreatorEvent, SessionCreatorState> {
  late final LoadAllCoursesUseCase _loadAllCoursesUseCase;
  late final GetAllCoursesUseCase _getAllCoursesUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final GetGroupUseCase _getGroupUseCase;
  late final GetGroupsByCourseIdUseCase _getGroupsByCourseIdUseCase;
  late final AddSessionUseCase _addSessionUseCase;
  late final UpdateSessionUseCase _updateSessionUseCase;
  late final TimeUtils _timeUtils;

  SessionCreatorBloc({
    required LoadAllCoursesUseCase loadAllCoursesUseCase,
    required GetAllCoursesUseCase getAllCoursesUseCase,
    required GetCourseUseCase getCourseUseCase,
    required GetGroupUseCase getGroupUseCase,
    required GetGroupsByCourseIdUseCase getGroupsByCourseIdUseCase,
    required AddSessionUseCase addSessionUseCase,
    required UpdateSessionUseCase updateSessionUseCase,
    required TimeUtils timeUtils,
    BlocStatus status = const BlocStatusInitial(),
    SessionCreatorMode mode = const SessionCreatorCreateMode(),
    List<Course> courses = const [],
    List<Group>? groups,
    Course? selectedCourse,
    Group? selectedGroup,
    FlashcardsType flashcardsType = FlashcardsType.all,
    bool areQuestionsAndAnswersSwapped = false,
    Date? date,
    Time? startTime,
    Duration? duration,
    Time? notificationTime,
  }) : super(
          SessionCreatorState(
            status: status,
            mode: mode,
            courses: courses,
            groups: groups,
            selectedCourse: selectedCourse,
            selectedGroup: selectedGroup,
            flashcardsType: flashcardsType,
            areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
            date: date,
            startTime: startTime,
            duration: duration,
            notificationTime: notificationTime,
          ),
        ) {
    _loadAllCoursesUseCase = loadAllCoursesUseCase;
    _getAllCoursesUseCase = getAllCoursesUseCase;
    _getCourseUseCase = getCourseUseCase;
    _getGroupUseCase = getGroupUseCase;
    _getGroupsByCourseIdUseCase = getGroupsByCourseIdUseCase;
    _addSessionUseCase = addSessionUseCase;
    _updateSessionUseCase = updateSessionUseCase;
    _timeUtils = timeUtils;
    on<SessionCreatorEventInitialize>(_initialize);
    on<SessionCreatorEventCourseSelected>(_courseSelected);
    on<SessionCreatorEventGroupSelected>(_groupSelected);
    on<SessionCreatorEventFlashcardsTypeSelected>(_flashcardsTypeSelected);
    on<SessionCreatorEventSwapQuestionsWithAnswers>(_swapQuestionsWithAnswers);
    on<SessionCreatorEventDateSelected>(_dateSelected);
    on<SessionCreatorEventStartTimeSelected>(_startTimeSelected);
    on<SessionCreatorEventDurationSelected>(_durationSelected);
    on<SessionCreatorEventNotificationTimeSelected>(_notificationTimeSelected);
    on<SessionCreatorEventCleanDurationTime>(_cleanDurationTime);
    on<SessionCreatorEventCleanNotificationTime>(_cleanNotificationTime);
    on<SessionCreatorEventSubmit>(_submit);
  }

  Future<void> _initialize(
    SessionCreatorEventInitialize event,
    Emitter<SessionCreatorState> emit,
  ) async {
    emit(state.copyWith(status: const BlocStatusLoading()));
    await _loadAllCoursesUseCase.execute();
    final SessionCreatorMode mode = event.mode;
    if (mode is SessionCreatorCreateMode) {
      await _initializeCreateMode(emit);
    } else if (mode is SessionCreatorEditMode) {
      await _initializeEditMode(mode, emit);
    }
  }

  Future<void> _courseSelected(
    SessionCreatorEventCourseSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    final Course course = await _getCourse(event.courseId);
    final List<Group> groupsFromCourse = await _getGroupsFromCourse(
      event.courseId,
    );
    if (state.selectedCourse != course) {
      emit(state.reset(selectedGroup: true));
    }
    emit(state.copyWith(
      selectedCourse: course,
      groups: groupsFromCourse.where(_areThereFlashcardsInGroup).toList(),
    ));
  }

  Future<void> _groupSelected(
    SessionCreatorEventGroupSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    emit(state.copyWith(
      selectedGroup: await _getGroup(event.groupId),
    ));
  }

  void _flashcardsTypeSelected(
    SessionCreatorEventFlashcardsTypeSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(
      flashcardsType: event.type,
    ));
  }

  void _swapQuestionsWithAnswers(
    SessionCreatorEventSwapQuestionsWithAnswers event,
    Emitter<SessionCreatorState> emit,
  ) {
    if (state.selectedGroup != null) {
      emit(state.copyWith(
        areQuestionsAndAnswersSwapped: !state.areQuestionsAndAnswersSwapped,
      ));
    }
  }

  void _dateSelected(
    SessionCreatorEventDateSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    if (_isChosenDateWithStartTimeFromThePast(event.date) ||
        _isChosenDateWithNotificationTimeFromThePast(event.date)) {
      emit(state.copyWithInfo(
        SessionCreatorInfoType.timeFromThePast,
      ));
    } else {
      emit(state.copyWith(
        date: event.date,
      ));
    }
  }

  Future<void> _startTimeSelected(
    SessionCreatorEventStartTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    if (_checkIfChosenTimeIsFromThePast(event.startTime)) {
      emit(state.copyWithInfo(
        SessionCreatorInfoType.timeFromThePast,
      ));
    } else if (_checkIfChosenStartTimeIsEarlierThanNotificationTime(
      event.startTime,
    )) {
      emit(state.copyWithInfo(
        SessionCreatorInfoType.chosenStartTimeIsEarlierThanNotificationTime,
      ));
    } else {
      emit(state.copyWith(startTime: event.startTime));
    }
  }

  void _durationSelected(
    SessionCreatorEventDurationSelected event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  Future<void> _notificationTimeSelected(
    SessionCreatorEventNotificationTimeSelected event,
    Emitter<SessionCreatorState> emit,
  ) async {
    if (_checkIfChosenTimeIsFromThePast(event.notificationTime)) {
      emit(state.copyWithInfo(
        SessionCreatorInfoType.timeFromThePast,
      ));
    } else if (_checkIfChosenNotificationTimeIsLaterThanStartTime(
      event.notificationTime,
    )) {
      emit(state.copyWithInfo(
        SessionCreatorInfoType.chosenNotificationTimeIsLaterThanStartTime,
      ));
    } else {
      emit(state.copyWith(notificationTime: event.notificationTime));
    }
  }

  void _cleanDurationTime(
    SessionCreatorEventCleanDurationTime event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.reset(duration: true));
  }

  void _cleanNotificationTime(
    SessionCreatorEventCleanNotificationTime event,
    Emitter<SessionCreatorState> emit,
  ) {
    emit(state.reset(notificationTime: true));
  }

  Future<void> _submit(
    SessionCreatorEventSubmit event,
    Emitter<SessionCreatorState> emit,
  ) async {
    final SessionCreatorMode mode = state.mode;
    emit(state.copyWith(status: const BlocStatusLoading()));
    if (mode is SessionCreatorCreateMode) {
      await _addSession();
      emit(state.copyWithInfo(
        SessionCreatorInfoType.sessionHasBeenAdded,
      ));
    } else if (mode is SessionCreatorEditMode) {
      await _updateSession(mode.session.id);
      emit(state.copyWithInfo(
        SessionCreatorInfoType.sessionHasBeenUpdated,
      ));
    }
  }

  Future<void> _initializeCreateMode(Emitter<SessionCreatorState> emit) async {
    emit(state.copyWith(
      courses: await _getAllCoursesUseCase.execute().first,
    ));
  }

  Future<void> _initializeEditMode(
    SessionCreatorEditMode editMode,
    Emitter<SessionCreatorState> emit,
  ) async {
    final Session session = editMode.session;
    final List<Course> allCourses = await _getAllCoursesUseCase.execute().first;
    final Group group =
        await _getGroupUseCase.execute(groupId: session.groupId).first;
    final Course course = await _getCourse(group.courseId);
    final List<Group> groupsFromCourse = await _getGroupsFromCourse(course.id);
    emit(state.copyWith(
      mode: editMode,
      courses: allCourses,
      groups: groupsFromCourse,
      selectedCourse: course,
      selectedGroup: group,
      flashcardsType: session.flashcardsType,
      areQuestionsAndAnswersSwapped: session.areQuestionsAndAnswersSwapped,
      date: session.date,
      startTime: session.startTime,
      duration: session.duration,
      notificationTime: session.notificationTime,
    ));
  }

  Future<Course> _getCourse(String courseId) async {
    return await _getCourseUseCase.execute(courseId: courseId).first;
  }

  Future<List<Group>> _getGroupsFromCourse(String courseId) async {
    return await _getGroupsByCourseIdUseCase.execute(courseId: courseId).first;
  }

  bool _areThereFlashcardsInGroup(Group group) {
    return group.flashcards.isNotEmpty;
  }

  Future<Group> _getGroup(String groupId) async {
    return await _getGroupUseCase.execute(groupId: groupId).first;
  }

  bool _isChosenDateWithStartTimeFromThePast(Date date) {
    final Time? startTime = state.startTime;
    return startTime != null && _timeUtils.isPastTime(startTime, date);
  }

  bool _isChosenDateWithNotificationTimeFromThePast(Date date) {
    final Time? notificationTime = state.notificationTime;
    return notificationTime != null &&
        _timeUtils.isPastTime(notificationTime, date);
  }

  bool _checkIfChosenTimeIsFromThePast(Time time) {
    final Date? date = state.date;
    return date != null && _timeUtils.isPastTime(time, date);
  }

  bool _checkIfChosenStartTimeIsEarlierThanNotificationTime(
    Time startTime,
  ) {
    final Time? notificationTime = state.notificationTime;
    return notificationTime != null &&
        _timeUtils.isTime1EarlierThanTime2(
          time1: startTime,
          time2: notificationTime,
        );
  }

  bool _checkIfChosenNotificationTimeIsLaterThanStartTime(
    Time notificationTime,
  ) {
    final Time? startTime = state.startTime;
    return startTime != null &&
        _timeUtils.isTime1EarlierThanTime2(
          time1: startTime,
          time2: notificationTime,
        );
  }

  Future<void> _addSession() async {
    final String? groupId = state.selectedGroup?.id;
    final Date? date = state.date;
    final Time? startTime = state.startTime;
    if (groupId != null && date != null && startTime != null) {
      await _addSessionUseCase.execute(
        groupId: groupId,
        flashcardsType: state.flashcardsType,
        areQuestionsAndAnswersSwapped: state.areQuestionsAndAnswersSwapped,
        date: date,
        startTime: startTime,
        duration: state.duration,
        notificationTime: state.notificationTime,
      );
    }
  }

  Future<void> _updateSession(String sessionId) async {
    await _updateSessionUseCase.execute(
      sessionId: sessionId,
      groupId: state.selectedGroup?.id,
      date: state.date,
      startTime: state.startTime,
      duration: state.duration,
      flashcardsType: state.flashcardsType,
      areQuestionsAndAnswersSwapped: state.areQuestionsAndAnswersSwapped,
      notificationTime: state.notificationTime,
    );
  }
}
