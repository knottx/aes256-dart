import 'package:aes256_demo/home/cubit/home_page_mode.dart';
import 'package:equatable/equatable.dart';

enum HomePageStatus {
  initial,
  ready,
  failure,
}

class HomePageState extends Equatable {
  final HomePageStatus status;
  final HomePageMode mode;
  final String result;
  final Object? error;

  const HomePageState({
    this.status = HomePageStatus.initial,
    this.mode = HomePageMode.encryption,
    this.result = '',
    this.error,
  });

  @override
  List<Object?> get props => [
        mode,
        result,
        error,
      ];

  HomePageState copyWith({
    HomePageStatus? status,
    HomePageMode? mode,
    String? result,
    Object? error,
  }) {
    return HomePageState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }

  HomePageState ready() {
    return copyWith(
      status: HomePageStatus.ready,
    );
  }

  HomePageState failure(
    Object error,
  ) {
    return copyWith(
      status: HomePageStatus.failure,
      error: error,
    );
  }
}
