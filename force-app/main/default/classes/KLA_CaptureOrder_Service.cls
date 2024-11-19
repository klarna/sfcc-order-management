public class KLA_CaptureOrder_Service {

    public KLA_CaptureOrder_Service() {}

    public static commercepayments.AbstractResponse capturePaymentIntent(commercepayments.CaptureRequest captureRequest) {
        commercepayments.CaptureResponse captureResponse = new commercepayments.CaptureResponse();

        PaymentAuthorization paymentAuth = [SELECT Id, GatewayRefNumber, OrderPaymentSummary.OrderSummary.kpOrderID__c, OrderPaymentSummary.OrderSummary.Id  FROM PaymentAuthorization WHERE Id = :captureRequest.paymentAuthorizationid];

        if(captureRequest.amount != null) {
            //check read access to all objects and fields for query
            KLA_KlarnaAdapter.checkAccess();

            String URLpath = '/ordermanagement/v1/orders/' + paymentAuth.OrderPaymentSummary.OrderSummary.kpOrderID__c + '/captures';
            String description = 'CAPTURE AUTHORIZATION ID: ' + captureRequest.paymentAuthorizationid + ', FOR ORDER SUMMARY ID: ' + paymentAuth.OrderPaymentSummary.OrderSummary.Id;

            Map<String, Object> jsonData = new Map<String, Object>();
            List<Object> orderItemSummaries = KLA_ServiceHelpers.getOrderItemSummaryJSON(paymentAuth.OrderPaymentSummary.OrderSummary.Id);

            jsonData.put('description', description);
            jsonData.put('captured_amount', Integer.valueOf(Decimal.valueOf(captureRequest.amount) * 100));
            jsonData.put('order_lines', orderItemSummaries);

            HttpResponse response = KLA_KlarnaAdapter.sendRequest('POST', JSON.serialize(jsonData), URLpath,
                                                                         paymentAuth.OrderPaymentSummary.OrderSummary.kpOrderID__c);

            if((response.getStatusCode() >= 200 && response.getStatusCode() < 300) || response.getStatus() == 'Created') {
                captureResponse.setAmount(captureRequest.amount);
                captureResponse.setGatewayResultCode('200');
                captureResponse.setGatewayResultCodeDescription('Payment Intent Successfully Captured');
                captureResponse.setSalesforceResultCodeInfo(KLA_ServiceConstants.SUCCESS_SALESFORCE_RESULT_CODE_INFO);
                captureResponse.setGatewayReferenceNumber(response.getHeader('Capture-Id'));
                captureResponse.setGatewayMessage(response.getHeader('Location'));
                captureResponse.setGatewayDate(system.now());
            } else {
                captureResponse.setAmount(0);
                captureResponse.setGatewayResultCode(String.valueOf(response.getStatusCode()));
                captureResponse.setGatewayResultCodeDescription('Payment Intent NOT Captured');
                captureResponse.setSalesforceResultCodeInfo(KLA_ServiceConstants.DECLINE_SALESFORCE_RESULT_CODE_INFO);
                captureResponse.setGatewayDate(system.now());
                String message = 'Payment Capture Failed Response Body' + response.getBody();
                throw new CalloutException(message);
            }
        } else {
            String message = 'Capture -> Required Field Missing: Amount';

            throw new CalloutException(message);
        }
        return captureResponse;
    }
}