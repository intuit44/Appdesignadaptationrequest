part of 'become_an_instructor_notifier.dart';

/// Represents the state of BecomeAnInstructor in the application.

// ignore_for_file: must_be_immutable
class BecomeAnInstructorState extends Equatable {
  BecomeAnInstructorState({
    this.emailController,
    this.scrollviewOneTab3ModelObj,
    this.becomeAnInstructorModelObj,
  });

  TextEditingController? emailController;

  BecomeAnInstructorModel? becomeAnInstructorModelObj;

  ScrollviewOneTab3Model? scrollviewOneTab3ModelObj;

  @override
  List<Object?> get props => [
    emailController,
    scrollviewOneTab3ModelObj,
    becomeAnInstructorModelObj,
  ];
  BecomeAnInstructorState copyWith({
    TextEditingController? emailController,
    ScrollviewOneTab3Model? scrollviewOneTab3ModelObj,
    BecomeAnInstructorModel? becomeAnInstructorModelObj,
  }) {
    return BecomeAnInstructorState(
      emailController: emailController ?? this.emailController,
      scrollviewOneTab3ModelObj:
          scrollviewOneTab3ModelObj ?? this.scrollviewOneTab3ModelObj,
      becomeAnInstructorModelObj:
          becomeAnInstructorModelObj ?? this.becomeAnInstructorModelObj,
    );
  }
}
