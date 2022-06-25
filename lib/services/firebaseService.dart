//Cloud functions reference

import 'package:cloud_functions/cloud_functions.dart';

final HttpsCallable CREATE_INTENT =
    FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
final HttpsCallable GET_PAYMENT_INTENT =
    FirebaseFunctions.instance.httpsCallable('getUserPaymentIntent');
final HttpsCallable CONFIRM_PAYMENT_INTENT =
    FirebaseFunctions.instance.httpsCallable('confirmPaymentIntent');
final HttpsCallable CREATE_CUSTOMER_CHARGE =
    FirebaseFunctions.instance.httpsCallable('createCustomerCharge');
