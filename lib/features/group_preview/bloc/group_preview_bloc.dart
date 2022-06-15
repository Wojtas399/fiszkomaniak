import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_dialogs.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../../interfaces/courses_interface.dart';
import '../../../models/flashcard_model.dart';
import '../../../models/group_model.dart';
import '../../group_creator/bloc/group_creator_mode.dart';

part 'group_preview_event.dart';

part 'group_preview_state.dart';

class GroupPreviewBloc extends Bloc<GroupPreviewEvent, GroupPreviewState> {
  late final CoursesInterface _coursesInterface;
  late final GroupPreviewDialogs _groupPreviewDialogs;
  late final Navigation _navigation;
  StreamSubscription<String>? _courseNameListener;
  StreamSubscription? _groupsStateSubscription;

  GroupPreviewBloc({
    required CoursesInterface coursesInterface,
    required GroupPreviewDialogs groupPreviewDialogs,
    required Navigation navigation,
  }) : super(const GroupPreviewState()) {
    _coursesInterface = coursesInterface;
    _groupPreviewDialogs = groupPreviewDialogs;
    _navigation = navigation;
    on<GroupPreviewEventInitialize>(_initialize);
    on<GroupPreviewEventCourseNameChanged>(_courseNameChanged);
    on<GroupPreviewEventEdit>(_edit);
    on<GroupPreviewEventRemove>(_remove);
    on<GroupPreviewEventEditFlashcards>(_editFlashcards);
    on<GroupPreviewEventReviewFlashcards>(_reviewFlashcards);
    on<GroupPreviewEventCreateQuickSession>(_createQuickSession);
    on<GroupPreviewEventGroupsStateUpdated>(_groupsStateUpdated);
  }

  @override
  Future<void> close() {
    _courseNameListener?.cancel();
    _groupsStateSubscription?.cancel();
    return super.close();
  }

  void _initialize(
    GroupPreviewEventInitialize event,
    Emitter<GroupPreviewState> emit,
  ) {
    // final Group? group = _groupsBloc.state.getGroupById(event.groupId);
    // if (group != null) {
    //   _setCourseNameListener(group.courseId);
    //   emit(state.copyWith(group: group));
    // }
    _setGroupsStateListener();
  }

  void _courseNameChanged(
    GroupPreviewEventCourseNameChanged event,
    Emitter<GroupPreviewState> emit,
  ) {
    emit(state.copyWith(
      courseName: event.newCourseName,
    ));
  }

  void _edit(
    GroupPreviewEventEdit event,
    Emitter<GroupPreviewState> emit,
  ) {
    final Group? group = state.group;
    if (group != null) {
      _navigation.navigateToGroupCreator(GroupCreatorEditMode(group: group));
    }
  }

  Future<void> _remove(
    GroupPreviewEventRemove event,
    Emitter<GroupPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      final bool confirmation =
          await _groupPreviewDialogs.askForDeleteConfirmation();
      // if (confirmation == true) {
      //   _groupsBloc.add(GroupsEventRemoveGroup(groupId: groupId));
      // }
    }
  }

  void _editFlashcards(
    GroupPreviewEventEditFlashcards event,
    Emitter<GroupPreviewState> emi,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      _navigation.navigateToFlashcardsEditor(
        FlashcardsEditorEditMode(groupId: groupId),
      );
    }
  }

  void _reviewFlashcards(
    GroupPreviewEventReviewFlashcards event,
    Emitter<GroupPreviewState> emit,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      _navigation.navigateToGroupFlashcardsPreview(state.group!.id);
    }
  }

  void _createQuickSession(
    GroupPreviewEventCreateQuickSession event,
    Emitter<GroupPreviewState> emit,
  ) {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      _navigation.navigateToSessionPreview(
        SessionPreviewModeQuick(groupId: state.group!.id),
      );
    }
  }

  void _groupsStateUpdated(
    GroupPreviewEventGroupsStateUpdated event,
    Emitter<GroupPreviewState> emit,
  ) {
    // final Group? group = _groupsBloc.state.getGroupById(state.group?.id);
    // if (group != null) {
    //   emit(state.copyWith(group: group));
    // }
  }

  void _setCourseNameListener(String courseId) {
    _courseNameListener = _coursesInterface.getCourseNameById(courseId).listen(
          (courseName) => add(
            GroupPreviewEventCourseNameChanged(newCourseName: courseName),
          ),
        );
  }

  void _setGroupsStateListener() {
    // _groupsStateSubscription = _groupsBloc.stream.listen((_) {
    //   add(GroupPreviewEventGroupsStateUpdated());
    // });
  }
}
