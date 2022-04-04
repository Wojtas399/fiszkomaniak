import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/group_model.dart';

class GroupPreviewState extends Equatable {
  final Group? group;

  const GroupPreviewState({this.group});

  @override
  List<Object> get props => [group ?? createGroup()];
}
