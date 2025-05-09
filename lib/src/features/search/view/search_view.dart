import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({required this.keywords, super.key});

  final String keywords;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.keywords;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    _controller.clear();
                    context.goNamed(AppRoute.homeView.name);
                  } else {
                    context.read<EventBloc>().add(
                          EventSearch(value, null),
                        );
                  }
                },
              ),
              BlocBuilder<EventBloc, EventState>(
                buildWhen: (previous, current) =>
                    previous.searchEvents != current.searchEvents,
                builder: (context, state) {
                  if (state.searchEvents == null ||
                      state.requestState.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.searchEvents!.isEmpty) {
                    return const Center(
                      child: Text('No result'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        context.watch<EventBloc>().state.searchEvents?.length,
                    itemBuilder: (context, index) {
                      final event =
                          context.watch<EventBloc>().state.searchEvents![index];
                      return ListTile(
                        title: Text(event.name),
                        subtitle: Text(event.name ?? ''),
                        onTap: () {},
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
