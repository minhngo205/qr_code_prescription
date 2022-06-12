import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_code_prescription/services/dtos/pres_pagination_response.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import '../../../components/list_prescription_card.dart';

class PrescriptionListView extends StatefulWidget {
  const PrescriptionListView({Key? key}) : super(key: key);

  @override
  _PrescriptionListViewState createState() => _PrescriptionListViewState();
}

class _PrescriptionListViewState extends State<PrescriptionListView> {
  final int _limit = 5;
  UserRepository userRepository = UserRepository();

  final PagingController<int, Prescription> _pagingController =
      PagingController(firstPageKey: 1);

  _fetchData(int pageKey) async {
    try {
      PrescriptionPaginationResponse? response =
          await userRepository.getPaginationPres(pageKey, _limit);

      if (response != null) {
        bool isLastPgae = response.results.length < _limit;
        if (isLastPgae) {
          _pagingController.appendLastPage(response.results);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(response.results, nextPageKey);
        }
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Prescription>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Prescription>(
          itemBuilder: (context, item, index) => PrescriptionCard(
            prescription: item,
          ),
          // firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
          //   error: _pagingController.error,
          //   onTryAgain: () => _pagingController.refresh(),
          // ),
          // noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
        ),
      ),
    );
  }
}