import 'package:apn_http/apn_http.dart';
import 'package:apn_state/apn_state.dart';
import 'package:dio/dio.dart';

abstract class ApiBaseState<T> extends BaseState<ErrorResponse> {
  var data = <T>[];
  var _loadingPage = 0;

  PaginationInfo paginationInfo;
  final _cancelTokens = <CancelToken>[];
  bool get isLoadingFirstData => isLoading && paginationInfo == null;

  bool get hasMorePages => paginationInfo != null
      ? paginationInfo.currentPage < paginationInfo.lastPage
      : false;

  @override
  ErrorResponse convertError(error) {
    if (error is DioError) {
      if (error.type == DioErrorType.CANCEL) {
        return null; //Don't set an error when a call is cancelled
      }
      if (error.response?.statusCode == 401) {
        emit(UserShouldLogoutEvent());
      }
      return error.toErrorResponse;
    } else {
      return ErrorResponse.fromMessage('An unexpected error occured: $error');
    }
  }

  Future<ApiResponse<V>> apiCall<V>(CancellableApiCall<V> callback) async {
    /// We ask for a new cancelToken, will be cancelled if onDispose is called on the state
    final cancelToken = CancelToken();
    _cancelTokens.add(cancelToken);

    /// Do the api call, don't automatically to setState (that can trigger rebuilds on cancelled/disposed views)
    final response = await process(() => callback(cancelToken), false);

    /// Remove the reference to the cancelToken
    _cancelTokens.remove(cancelToken);

    /// Return the response and the CancelToken to the caller
    return ApiResponse(
      data: response,
      cancelToken: cancelToken,
    );
  }

  @override
  void dispose() {
    _cancelTokens.forEach((element) => element.cancel('disposed'));
    super.dispose();
  }

  LoadDataEvent loadPageEvent({int page = 1}) {
    return null;
  }

  Future<ApiBaseState> dispatchLoadNewPage({int page = 1}) async {
    if (_loadingPage == page) return this;
    _loadingPage = page;
    final state =
        await dispatch<LoadDataEvent, ApiBaseState>(loadPageEvent(page: page));
    state._loadingPage = 0;
    return state;
  }
}

abstract class ApiEvent<T> extends BaseStateEvent<ApiBaseState<T>> {}

abstract class LoadDataEvent<V, T extends PageResponse<V>> extends ApiEvent<V> {
  final int page;

  LoadDataEvent({this.page = 1});

  @override
  Future<void> handle() async {
    final apiResponse =
        await state.apiCall<T>((cancelToken) => getData(cancelToken));

    // Cancelled, no UI update, just exit
    if (apiResponse.cancelToken.isCancelled) {
      return;
    }

    final response = apiResponse.data;
    if (!state.hasError) {
      if (page == 1) {
        state.data.clear();
      }
      state.data += response.data;
      state.paginationInfo = response.meta;
    } else {
      state.paginationInfo?.lastPage = state.paginationInfo?.currentPage;
    }

    //Update UI with a new page of data
    state.notifyListeners();
  }

  Future<T> getData(CancelToken cancelToken);
}

abstract class PageResponse<T> {
  List<T> data;
  PaginationInfo meta;
}

class ApiResponse<T> {
  final CancelToken cancelToken;
  final T data;

  ApiResponse({this.cancelToken, this.data});
}

typedef CancellableApiCall<T> = Future<T> Function(CancelToken cancelToken);

class UserShouldLogoutEvent extends EventBusEvent {}
