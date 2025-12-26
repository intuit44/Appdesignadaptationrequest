part of 'mentors_notifier.dart';

/// Represents the state of Mentors in the application.

// ignore_for_file: must_be_immutable
class MentorsState extends Equatable {
  MentorsState({
    this.emailController,
    this.scrollviewOneTab4ModelObj,
    this.mentorsModelObj,
  });

  TextEditingController? emailController;

  MentorsModel? mentorsModelObj;

  ScrollviewOneTab4Model? scrollviewOneTab4ModelObj;

  @override
  List<Object?> get props => [
    emailController,
    scrollviewOneTab4ModelObj,
    mentorsModelObj,
  ];
  MentorsState copyWith({
    TextEditingController? emailController,
    ScrollviewOneTab4Model? scrollviewOneTab4ModelObj,
    MentorsModel? mentorsModelObj,
  }) {
    return MentorsState(
      emailController: emailController ?? this.emailController,
      scrollviewOneTab4ModelObj:
          scrollviewOneTab4ModelObj ?? this.scrollviewOneTab4ModelObj,
      mentorsModelObj: mentorsModelObj ?? this.mentorsModelObj,
    );
  }
}
