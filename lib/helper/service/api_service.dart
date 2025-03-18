import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:kunet_app/helper/interceptors/api_interceptors.dart';
import 'package:kunet_app/helper/interceptors/token_retry.dart';
import 'package:kunet_app/helper/state/state_manager.dart';

class APIService {
  final _controller = Get.find<StateController>();
  http.Client client = InterceptedClient.build(
    interceptors: [
      MyApiInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  APIService() {
    // init();
  }

  final StreamController<http.Response> _streamController =
      StreamController<http.Response>();

  Future<http.Response> signup(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/customer/signup'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> login(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/customer/login'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  // Future<http.Response> googleAuth(Map body) async {
  //   return await http.post(
  //     Uri.parse('${Constants.baseURL}/auth/google/login'),
  //     headers: {
  //       "Content-type": "application/json",
  //     },
  //     body: jsonEncode(body),
  //   );
  // }

  // Future<http.Response> googleAuthRedirect({var authHeaders}) async {
  //   return await http.get(
  //     Uri.parse('${Constants.baseURL}/auth/google/redirect'),
  //     headers: authHeaders,
  //   );
  // }

  Future<http.Response> forgotPass(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/customer/forgotPassword'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resetPass(Map body) async {
    return await http.put(
      Uri.parse('${Constants.baseURL}/auth/customer/resetPassword'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> verifyOTP(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/customer/verifyOTP'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> resendOTP(Map body) async {
    return await http.post(
      Uri.parse('${Constants.baseURL}/auth/customer/sendOTP'),
      headers: {
        "Content-type": "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getProfile(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/customer/current/profile'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> getHistory(String accessToken) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/history/user'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> logout(String accessToken, String email) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/auth/logout/'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> updateProfile(
      {var body, var accessToken, var id}) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/customer/profile/update'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future getVTUs() async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/vtu/all'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> initVtuRequest(String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> initElectricityRequest(
      String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/electricity/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> initCableTVRequest(String accessToken, Map body) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/cable-tv/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> getPlans(String serviceId) async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/vtu/$serviceId/plans'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getVTUCountries({required String type}) async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/vtu/international?type=$type'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getCountryOperators(
      {required String countryCode, required String productTypeID}) async {
    return await http.get(
      Uri.parse(
          '${Constants.baseURL}/vtu/country/operators?code=$countryCode&product_type_id=$productTypeID'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getInternationalVariationCode(
      {required String operatorID, required String productTypeID}) async {
    return await http.get(
      Uri.parse(
          '${Constants.baseURL}/vtu/international/variation-code?operator_id=$operatorID&product_type_id=$productTypeID'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> initPayment(String accessToken, var encodedData) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vtu/request/payment/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(encodedData),
    );
  }

  Future<http.Response> getBanks(String countryCode) async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/bank/list?country_code=$countryCode'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> getBankCountries() async {
    return await http.get(
      Uri.parse('${Constants.baseURL}/bank/countries'),
      headers: {
        "Content-type": "application/json",
      },
    );
  }

  Future<http.Response> validateBank(String accessToken, var payload) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/bank/account/validate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> saveBank({
    required String accessToken,
    required var payload,
  }) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/bank/user/save'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> removeBank({
    required String accessToken,
    required var payload,
    required var bankId,
  }) async {
    return await client.delete(
      Uri.parse('${Constants.baseURL}/bank/user/remove/$bankId'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> fetchUserBankAccounts({
    required String accessToken,
    required String userId,
  }) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/bank/user/$userId/accounts'),
      headers: {
        "Content-type": "application/json",
        // "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Stream<http.Response> getUserBankAccounts({
    required String accessToken,
    required String emailAddress,
  }) async* {
    try {
      // Fetch data and add it to the stream
      http.Response response = await client.get(
        Uri.parse('${Constants.baseURL}/bank/user/$emailAddress/accounts'),
        headers: {
          "Content-type": "application/json",
        },
      );

      print("USER BANKS RESPO ::: ${response.body}");
      yield response; // Yield the response to the stream
    } catch (error) {
      // Handle errors by adding an error to the stream
      _streamController.addError(error);
    }
  }

  // VOUCHERS
  Future<http.Response> initiateVoucher(String accessToken, var payload) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/initiate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> redeemVoucher(String accessToken, var payload) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/redeem'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> getUserVouchers({
    required String accessToken,
    required int page,
    required int limit,
  }) async {
    return await http.get(
      Uri.parse(
          '${Constants.baseURL}/vouchers/user/all?page=$page&limit=$limit'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> getUserUnusedVouchers({
    required String accessToken,
    required int page,
    required int limit,
  }) async {
    return await http.get(
      Uri.parse(
          '${Constants.baseURL}/vouchers/user/unused/all?page=$page&limit=$limit'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> fetchVoucherCharge({
    required String accessToken,
    required var payload,
  }) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/buy/fetch-charge'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> validateVoucherCode({
    required String accessToken,
    required var voucherCode,
  }) async {
    return await client.post(
      Uri.parse(
          '${Constants.baseURL}/vouchers/code/validate?voucher_code=$voucherCode'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> voucherGenerateOTP({
    required String accessToken,
    required var voucherCode,
  }) async {
    return await client.get(
      Uri.parse('${Constants.baseURL}/vouchers/otp/generate/$voucherCode'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
    );
  }

  Future<http.Response> voucherVerifyOTP({
    required String accessToken,
    required Map payload,
  }) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/otp/validate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> processDepositVoucher({
    required String accessToken,
    required String voucherCode,
    required Map payload,
    required String type,
  }) async {
    return await client.post(
      Uri.parse(
          '${Constants.baseURL}/vouchers/process/deposit/$voucherCode?type=$type'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }

  Future<http.Response> generatePayLink({
    required String accessToken,
    required Map payload,
  }) async {
    return await client.post(
      Uri.parse('${Constants.baseURL}/vouchers/redeem-link/generate'),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer " + accessToken,
      },
      body: jsonEncode(payload),
    );
  }
}
