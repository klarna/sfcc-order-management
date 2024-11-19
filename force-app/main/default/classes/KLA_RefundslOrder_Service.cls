public class KLA_RefundslOrder_Service {

    public KLA_RefundslOrder_Service() {}

    /* REFUND
     * Refund paymen request
     */
    public static commercepayments.AbstractResponse refundPayment(commercepayments.ReferencedRefundRequest refundRequest) {
        commercepayments.ReferencedRefundResponse refundResponse = new commercepayments.ReferencedRefundResponse();

        Payment payment = [SELECT Id, GatewayRefNumber, OrderPaymentSummary.OrderSummary.kpOrderID__c, OrderPaymentSummary.OrderSummary.Id FROM Payment WHERE Id = :refundRequest.paymentId];

        if (refundRequest.amount != null) {
            //check read access to all objects and fields for query
            KLA_KlarnaAdapter.checkAccess();

            String description = 'REFUND AGAINST PAYMENT ID: ' + refundRequest.paymentId + ', FOR ORDER SUMMARY ID: ' + payment.OrderPaymentSummary.OrderSummary.Id;
            String URLpath = '/ordermanagement/v1/orders/' + payment.OrderPaymentSummary.OrderSummary.kpOrderID__c + '/refunds';

            Map<String, Object> jsonData = new Map<String, Object>();
            List<Object> orderItemSummaries = KLA_ServiceHelpers.getOrderItemSummaryJSON(payment.OrderPaymentSummary.OrderSummary.Id);

            jsonData.put('description', description);
            jsonData.put('refunded_amount', Integer.valueOf(Decimal.valueOf(refundRequest.amount) * 100));
            jsonData.put('order_lines', orderItemSummaries);

            HttpResponse response = KLA_KlarnaAdapter.sendRequest('POST', JSON.serialize(jsonData), URLpath,
                                                                         payment.OrderPaymentSummary.OrderSummary.kpOrderID__c);

            if((response.getStatusCode() >= 200 && response.getStatusCode() < 300) || response.getStatus() == 'Created') {
                refundResponse.setAmount(refundRequest.amount);
                refundResponse.setGatewayResultCode('200');
                refundResponse.setGatewayResultCodeDescription('Payment Refund Successful');
                refundResponse.setSalesforceResultCodeInfo(KLA_ServiceConstants.SUCCESS_SALESFORCE_RESULT_CODE_INFO);
                refundResponse.setGatewayReferenceNumber(response.getHeader('Refund-Id'));
                refundResponse.setGatewayMessage(response.getHeader('Location'));
                refundResponse.setGatewayDate(system.now());
            } else {
                refundResponse.setAmount(0);
                refundResponse.setGatewayResultCode(String.valueOf(response.getStatusCode()));
                refundResponse.setGatewayResultCodeDescription('Payment Intent NOT Refunded');
                refundResponse.setSalesforceResultCodeInfo(KLA_ServiceConstants.DECLINE_SALESFORCE_RESULT_CODE_INFO);
                refundResponse.setGatewayDate(system.now());
                String message = 'Payment Refund Failed Response Body' + response.getBody();
                throw new CalloutException(message);
            }
        } else {
            String message = 'Refund -> Required Field Missing: Amount';

            throw new CalloutException(message);
        }
        return refundResponse;
    }
}