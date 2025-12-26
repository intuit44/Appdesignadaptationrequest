part of 'mentor_profile_notifier.dart';

/// Represents the state of MentorProfile in the application.

// ignore_for_file: must_be_immutable
class MentorProfileState extends Equatable {
  MentorProfileState({
    this.emailController,
    this.scrollviewOneTab5ModelObj,
    this.mentorProfileModelObj,
  });

  TextEditingController? emailController;

  MentorProfileModel? mentorProfileModelObj;

  ScrollviewOneTab5Model? scrollviewOneTab5ModelObj;

  @override
  List<Object?> get props => [
    emailController,
    scrollviewOneTab5ModelObj,
    mentorProfileModelObj,
  ];
  MentorProfileState copyWith({
    TextEditingController? emailController,
    ScrollviewOneTab5Model? scrollviewOneTab5ModelObj,
    MentorProfileModel? mentorProfileModelObj,
  }) {
    return MentorProfileState(
      emailController: emailController ?? this.emailController,
      scrollviewOneTab5ModelObj:
          scrollviewOneTab5ModelObj ?? this.scrollviewOneTab5ModelObj,
      mentorProfileModelObj:
          mentorProfileModelObj ?? this.mentorProfileModelObj,
    );
  }
}
