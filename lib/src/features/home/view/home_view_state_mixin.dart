import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/pagination_event%20/pagination_event_bloc.dart';
import 'package:gig_buddy/src/features/home/view/home_view.dart';
import 'package:gig_buddy/src/service/model/city/city.dart';


mixin HomeViewMixin on State<HomeView> {
  City? selectedCity;
  String? currentKeyword;
  CancelToken? _cancelToken;
  Timer? _debounceTimer;

  void onSelectCity(City city) {
    setState(() {
      if (selectedCity == city) return selectedCity = null;
      selectedCity = city;
    });
    onFiltered();
  }

  void onChangeKeyword(String keyword) {
    if (keyword == currentKeyword) return;

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    // Cancel the previous API call
    _cancelToken?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _cancelToken = CancelToken();
      setState(() {
        currentKeyword = keyword;
      });
      onFiltered();
    });
  }

  void onFiltered() {
    context
        .read<PaginationEventBloc>()
        .add(OnFiltered(selectedCity, currentKeyword, _cancelToken));
  }
}