part of 'study_bloc.dart';

class StudyState extends Equatable {
  final List<GroupItemParams> groupsItemsParams;

  const StudyState({
    this.groupsItemsParams = const [],
  });

  @override
  List<Object> get props => [groupsItemsParams];

  bool get areGroups => groupsItemsParams.isNotEmpty;

  StudyState copyWith({
    List<GroupItemParams>? groupsItemsParams,
  }) {
    return StudyState(
      groupsItemsParams: groupsItemsParams ?? this.groupsItemsParams,
    );
  }
}
