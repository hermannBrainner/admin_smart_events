/*
import 'dart:convert';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

import '/outils/fonctions.dart';
class PaiementService{
  final int montant;
  final String url;

  PaiementService({this.montant = 100, this.url = ''});

  static init(){
    StripePayment.setOptions(
      StripeOptions(publishableKey: 'pk_test_51L27GBBBK9QZZ6tE7TrEYVaEMN6yj8PsfVJOYPG1si7MwRD8rnkuHakjRn3n0nNrElA0bi3ukV0mAPvpLhWXumeB00LtzoZLsj',
          merchantId:'test' ,
          androidPayMode: 'test')
    );
  }

   Future<PaymentMethod?>   createPaiementMethode()async{

    PaymentMethod paiementMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
    return paiementMethod;
  write("Le montant a charger est ${montant}");
  }


  Future<void>   processPaiementMethode( PaymentMethod paymentMethod)async{

    final http.Response response = await http.post(
      Uri.parse('$url?amount=$montant&currency=USD&paym=${paymentMethod.id}')
    );

    if(response.body != 'error'){
      final paymentIntent = jsonDecode(response.body);
      final status = paymentIntent['paymentIntent']['status'];
      write(status);

      if(status == 'succeeded'){
        write('paiment complete.  ${paymentIntent['paymentIntent']['amount'].toString()} succesifuly ');
      }
    }else{
      write('paiement failed');
    }

  }
}*/
