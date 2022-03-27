import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class GroupsState extends Equatable {
  final List<Group> allGroups;
  final HttpStatus httpStatus;

  const GroupsState({
    this.allGroups = const [],
    this.httpStatus = const HttpStatusInitial(),
  });

  GroupsState copyWith({
    List<Group>? allGroups,
    HttpStatus? httpStatus,
  }) {
    return GroupsState(
      allGroups: allGroups ?? this.allGroups,
      httpStatus: httpStatus ?? const HttpStatusInitial(),
    );
  }

  @override
  List<Object> get props => [
        allGroups,
        httpStatus,
      ];
}
