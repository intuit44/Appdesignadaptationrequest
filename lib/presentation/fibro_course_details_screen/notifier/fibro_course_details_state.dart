part of 'fibro_course_details_notifier.dart';

/// Represents the state of FibroCourseDetails in the application.

// ignore_for_file: must_be_immutable
class FibroCourseDetailsState extends Equatable {
  FibroCourseDetailsState({
    this.emailController,
    this.fibroCourseDetailsModelObj,
  });

  TextEditingController? emailController;

  FibroCourseDetailsModel? fibroCourseDetailsModelObj;

  @override
  List<Object?> get props => [emailController, fibroCourseDetailsModelObj];
  FibroCourseDetailsState copyWith({
    TextEditingController? emailController,
    FibroCourseDetailsModel? fibroCourseDetailsModelObj,
  }) {
    return FibroCourseDetailsState(
      emailController: emailController ?? this.emailController,
      fibroCourseDetailsModelObj:
          fibroCourseDetailsModelObj ?? this.fibroCourseDetailsModelObj,
    );
  }
}
