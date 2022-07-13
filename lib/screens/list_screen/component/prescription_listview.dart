import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_code_prescription/model/dtos/prescription_item.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
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
  StorageRepository storageRepository = StorageRepository();

  final PagingController<int, PrescriptionItem> _pagingController =
      PagingController(firstPageKey: 1);

  _fetchData(int pageKey) async {
    try {
      var response = await userRepository.getPaginationPres(pageKey, _limit);

      if (response == RequestStatus.RefreshFail) {
        storageRepository.deleteToken();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else {
        bool isLastPage = response.length < _limit;
        debugPrint(isLastPage.toString());
        if (isLastPage) {
          _pagingController.appendLastPage(response);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(response, nextPageKey);
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
      child: PagedListView<int, PrescriptionItem>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<PrescriptionItem>(
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
