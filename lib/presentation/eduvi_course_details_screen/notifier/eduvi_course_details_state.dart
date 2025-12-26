part of 'eduvi_course_details_notifier.dart';

/// Represents the state of EduviCourseDetails in the application.

// ignore_for_file: must_be_immutable
class EduviCourseDetailsState extends Equatable {
  EduviCourseDetailsState({
    this.emailController,
    this.eduviCourseDetailsModelObj,
  });

  TextEditingController? emailController;

  EduviCourseDetailsModel? eduviCourseDetailsModelObj;

  @override
  List<Object?> get props => [emailController, eduviCourseDetailsModelObj];
  EduviCourseDetailsState copyWith({
    TextEditingController? emailController,
    EduviCourseDetailsModel? eduviCourseDetailsModelObj,
  }) {
    return EduviCourseDetailsState(
      emailController: emailController ?? this.emailController,
      eduviCourseDetailsModelObj:
          eduviCourseDetailsModelObj ?? this.eduviCourseDetailsModelObj,
    );
  }
}
