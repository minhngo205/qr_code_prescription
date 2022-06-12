import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_code_prescription/components/hospital_cart.dart';
import 'package:qr_code_prescription/services/public_service/public_service.dart';
import 'package:qr_code_prescription/services/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/services/dtos/hospital_drugstore_pagination.dart';

class HospitalDrugstoreListView extends StatefulWidget {
  const HospitalDrugstoreListView({Key? key, required this.pageName})
      : super(key: key);
  final String pageName;

  @override
  State<HospitalDrugstoreListView> createState() =>
      _HospitalDrugstoreListViewState();
}

class _HospitalDrugstoreListViewState extends State<HospitalDrugstoreListView> {
  final int _limit = 5;
  PublicService publicService = PublicService();

  final PagingController<int, HospitalDrugstore> _pagingController =
      PagingController(firstPageKey: 1);

  _fetchData(int pageKey) async {
    try {
      HospitalDrugstorePagination? response = await publicService
          .getPaginationHospital(widget.pageName, pageKey, _limit);

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
      child: PagedListView<int, HospitalDrugstore>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) =>
              HospitalDrugstoreCard(hospitalDrugstore: item),
        ),
      ),
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
    );
  }
}
