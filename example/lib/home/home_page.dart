import 'package:aes256_demo/home/cubit/home_page_cubit.dart';
import 'package:aes256_demo/home/cubit/home_page_mode.dart';
import 'package:aes256_demo/home/cubit/home_page_state.dart';
import 'package:aes256_demo/home/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                controller: _scrollController,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: _body(state),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: _listener,
    );
  }

  Widget _body(HomePageState state) {
    final cubit = context.read<HomePageCubit>();
    return Form(
      key: cubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _openPubDevButton(),
          const SizedBox(height: 16),
          _modeButtons(state),
          const SizedBox(height: 20),
          _textField(state),
          const SizedBox(height: 20),
          _passphraseField(),
          const SizedBox(height: 16),
          Center(
            child: _actionButton(state),
          ),
          const SizedBox(height: 16),
          _result(state.result),
        ],
      ),
    );
  }

  Widget _modeButtons(HomePageState state) {
    final cubit = context.read<HomePageCubit>();
    return Wrap(
      spacing: 16,
      children: HomePageMode.values.map((e) {
        return ChoiceChip(
          label: Text(e.title),
          selected: e == state.mode,
          onSelected: (selected) {
            if (selected) {
              cubit.onSelectedMode(e);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _textField(HomePageState state) {
    final cubit = context.read<HomePageCubit>();
    return AppTextFormField(
      controller: cubit.textController,
      labelText: state.mode.textFieldTitle,
      maxLines: 4,
      validator: notEmpty,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
      ],
      onSaved: (value) => cubit.text = value?.trim() ?? '',
    );
  }

  Widget _passphraseField() {
    final cubit = context.read<HomePageCubit>();
    return AppTextFormField(
      controller: cubit.passphraseController,
      labelText: 'Passphrase',
      validator: notEmpty,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'^\s')),
      ],
      onSaved: (value) => cubit.passphrase = value?.trim() ?? '',
    );
  }

  Widget _openPubDevButton() {
    const url = 'https://pub.dev/packages/aes256';
    return TextButton(
      onPressed: () {
        launchUrlString(url);
      },
      child: const Text(url),
    );
  }

  Widget _actionButton(HomePageState state) {
    final cubit = context.read<HomePageCubit>();
    return FilledButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        cubit.onTapSubmit();
      },
      style: FilledButton.styleFrom(
        minimumSize: const Size(200, 48),
      ),
      child: Text(
        state.mode.actionTitle,
      ),
    );
  }

  Widget _result(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SelectableText(
                text,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              _onTapCopy(text);
            },
            icon: const Icon(
              Icons.copy,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  String? notEmpty(
    String? value,
  ) {
    final trimmed = value?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return null;
    } else {
      return 'Required';
    }
  }

  void _onTapCopy(String text) async {
    if (text.isEmpty) return;

    await Clipboard.setData(
      ClipboardData(text: text),
    );

    HapticFeedback.lightImpact();

    _showSnackBar('Coppied!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _listener(BuildContext context, HomePageState state) {
    switch (state.status) {
      case HomePageStatus.failure:
        final errorMessage = state.error?.toString();
        if (errorMessage != null) {
          _showSnackBar(errorMessage);
        }

        break;
      default:
        break;
    }
  }
}
