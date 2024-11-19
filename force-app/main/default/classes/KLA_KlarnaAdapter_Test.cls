@isTest (SeeAllData = true)
public class KLA_KlarnaAdapter_Test {

    private static testMethod void testProcessRequestCaptureSuccess() {
        PaymentAuthorization pa = [SELECT Id, Amount FROM PaymentAuthorization LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        Double amount = 10.00;
        commercepayments.CaptureRequest req = new commercepayments.CaptureRequest(amount, pa.Id);
        Test.startTest();
        KLA_CaptureOrder_Service refundOrderService = new KLA_CaptureOrder_Service();
        commercepayments.AbstractResponse response = KLA_CaptureOrder_Service.capturePaymentIntent(req);
        System.assertNotEquals(response, null);
        System.debug(response);
        Test.stopTest();
    }

   
    private static testMethod void  testProcessRequestCaptureFailed() {
        PaymentAuthorization pa = [SELECT Id, Amount FROM PaymentAuthorization LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        Double amount = 20.00;
        commercepayments.CaptureRequest req = new commercepayments.CaptureRequest(amount, pa.Id);
        Test.startTest();
        try {
            commercepayments.AbstractResponse response = KLA_CaptureOrder_Service.capturePaymentIntent(req);
        } catch(Exception e) {
            System.debug('Caught Exception');
            System.assertEquals(e.getMessage().contains('Payment Capture Failed'), false);
        }
        Test.stopTest();
    }

   
    private static testMethod void testProcessRequestCaptureBadRequest() {
        PaymentAuthorization pa = [SELECT Id, Amount FROM PaymentAuthorization LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        Double amount = -10.00;
        commercepayments.CaptureRequest req = new commercepayments.CaptureRequest(amount, pa.Id);
        
        Test.startTest();
        try {
            commercepayments.AbstractResponse response = KLA_CaptureOrder_Service.capturePaymentIntent(req);
        } catch(Exception e) {
            System.debug('Caught Exception');
            System.assertEquals(e.getMessage().contains('Payment Capture Failed Response Body'), false);
        }
        Test.stopTest();
    }

   
    private static testMethod void testProcessRequestCaptureNoAmount() {
        PaymentAuthorization pa = [SELECT Id, Amount FROM PaymentAuthorization LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        commercepayments.CaptureRequest req = new commercepayments.CaptureRequest(null, pa.Id);
        
        Test.startTest();
        try {
            commercepayments.AbstractResponse response = KLA_CaptureOrder_Service.capturePaymentIntent(req);
        } catch(Exception e) {
            System.debug('Caught Exception');
            System.assertEquals(e.getMessage().contains('Required Field Missing: Amount'), true);
        }
        Test.stopTest();
    }

   
    private static testMethod void testProcessRequestRefundSuccess() {
        KLA_RefundslOrder_Service refundConstructor = new KLA_RefundslOrder_Service();
        PaymentAuthorization pa = [SELECT Id, Amount, OrderPaymentSummaryId, PaymentMethodId FROM PaymentAuthorization LIMIT 1];
        Payment payment = new Payment(
                              Amount = pa.Amount,
                              ProcessingMode = 'External',
                              Status = 'Processed',
                              Type = 'Capture',
                              SfResultCode = 'Success',
                              GatewayRefNumber = 'SFTESTREF#123',
                              GatewayResultCode = '00',
                              GatewayResultCodeDescription = 'Transaction Normal',
                              PaymentAuthorizationId = pa.Id,
                              PaymentMethodId = pa.PaymentMethodId,
                              OrderPaymentSummaryId = pa.OrderPaymentSummaryId
                          );
        insert payment;

        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        commercepayments.ReferencedRefundRequest req = new commercepayments.ReferencedRefundRequest((Double)payment.Amount, payment.Id);        Test.startTest();
        commercepayments.AbstractResponse response = KLA_RefundslOrder_Service.refundPayment(req);
        System.debug(response);
        Test.stopTest();
        System.assertNotEquals(response, null);
    }

   
    private static testMethod void testProcessRequestRefundFailed() {
        PaymentAuthorization pa = [SELECT Id, Amount, OrderPaymentSummaryId, PaymentMethodId FROM PaymentAuthorization LIMIT 1];
        Payment payment = new Payment(
                              Amount = pa.Amount,
                              ProcessingMode = 'External',
                              Status = 'Processed',
                              Type = 'Capture',
                              SfResultCode = 'Success',
                              GatewayRefNumber = 'SFTESTREF#123',
                              GatewayResultCode = '00',
                              GatewayResultCodeDescription = 'Transaction Normal',
                              PaymentAuthorizationId = pa.Id,
                              PaymentMethodId = pa.PaymentMethodId,
                              OrderPaymentSummaryId = pa.OrderPaymentSummaryId
                          );
        insert payment;

        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        Double amount = 100.00;
        commercepayments.ReferencedRefundRequest req = new commercepayments.ReferencedRefundRequest(amount, payment.Id);

        Test.startTest();
        try{
            commercepayments.AbstractResponse response = KLA_RefundslOrder_Service.refundPayment(req);
        } catch(Exception e) {
            System.assertEquals(e.getMessage().contains('Payment Refund Failed Response Body'), false);
        }
        Test.stopTest();
    }

   
    private static testMethod void testProcessRequestRefundBadRequest() {
        PaymentAuthorization pa = [SELECT Id, Amount, OrderPaymentSummaryId, PaymentMethodId FROM PaymentAuthorization LIMIT 1];
        Payment payment = new Payment(
                              Amount = pa.Amount,
                              ProcessingMode = 'External',
                              Status = 'Processed',
                              Type = 'Capture',
                              SfResultCode = 'Success',
                              GatewayRefNumber = 'SFTESTREF#123',
                              GatewayResultCode = '00',
                              GatewayResultCodeDescription = 'Transaction Normal',
                              PaymentAuthorizationId = pa.Id,
                              PaymentMethodId = pa.PaymentMethodId,
                              OrderPaymentSummaryId = pa.OrderPaymentSummaryId
                          );
        insert payment;

        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        Double amount = 400.00;
        commercepayments.ReferencedRefundRequest req = new commercepayments.ReferencedRefundRequest(amount, payment.Id);

        Test.startTest();
        try{
            commercepayments.AbstractResponse response = KLA_RefundslOrder_Service.refundPayment(req);
        } catch(Exception e) {
            System.assertEquals(e.getMessage().contains('Payment Refund Failed Response Body'), true);
        }
        Test.stopTest();
    }

   
    private static testMethod void testProcessRequestRefundNoAmount() {
        PaymentAuthorization pa = [SELECT Id, Amount, OrderPaymentSummaryId, PaymentMethodId FROM PaymentAuthorization LIMIT 1];
        Payment payment = new Payment(
                              Amount = pa.Amount,
                              ProcessingMode = 'External',
                              Status = 'Processed',
                              Type = 'Capture',
                              SfResultCode = 'Success',
                              GatewayRefNumber = 'SFTESTREF#123',
                              GatewayResultCode = '00',
                              GatewayResultCodeDescription = 'Transaction Normal',
                              PaymentAuthorizationId = pa.Id,
                              PaymentMethodId = pa.PaymentMethodId,
                              OrderPaymentSummaryId = pa.OrderPaymentSummaryId
                          );
        insert payment;

        Test.setMock(HttpCalloutMock.class, new KLA_KlarnaAdapter_Mock());
        commercepayments.ReferencedRefundRequest req = new commercepayments.ReferencedRefundRequest(null, payment.Id);

        Test.startTest();
        try{
            commercepayments.AbstractResponse response = KLA_RefundslOrder_Service.refundPayment(req);
        } catch(Exception e) {
            System.assertEquals(e.getMessage().contains('Required Field Missing: Amount'), true);
        }
        Test.stopTest();
    }
}