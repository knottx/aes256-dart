import 'package:aes256/aes256.dart';
import 'package:aes256_demo/home/cubit/home_page_mode.dart';
import 'package:aes256_demo/home/cubit/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController textController = TextEditingController();
  final TextEditingController passphraseController = TextEditingController();

  String text = '';
  String passphrase = '';

  HomePageCubit() : super(const HomePageState());

  @override
  Future<void> close() {
    textController.dispose();
    return super.close();
  }

  void onSelectedMode(HomePageMode mode) {
    switch (mode) {
      case HomePageMode.encryption:
        textController.clear();
        emit(
          HomePageState(
            mode: mode,
            result: '',
          ),
        );
        break;

      case HomePageMode.decryption:
        textController.text = state.result;
        emit(
          HomePageState(
            mode: mode,
            result: '',
          ),
        );
        break;
    }
  }

  void onTapSubmit() {
    textController.text = textController.text.trim();
    passphraseController.text = passphraseController.text.trim();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      switch (state.mode) {
        case HomePageMode.encryption:
          _encrypt();
          break;

        case HomePageMode.decryption:
          _decrypt();
          break;
      }
    }
  }

  void _encrypt() async {
    try {
      final result = Aes256.encrypt(
        text: text,
        passphrase: passphrase,
      );
      emit(
        state.copyWith(
          result: result,
        ),
      );
    } catch (error) {
      emit(state.failure(error));
      emit(state.ready());
    }
  }

  void _decrypt() async {
    try {
      final result = Aes256.decrypt(
        encrypted: text,
        passphrase: passphrase,
      );
      emit(
        state.copyWith(
          result: result,
        ),
      );
    } catch (error) {
      emit(state.failure(error));
      emit(state.ready());
    }
  }
}
