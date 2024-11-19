public class KLA_OrderUpdateAmount_Invocable {
    @InvocableMethod(label='Update Order Amounts' description='Updates the order amounts by passing the list of order summary number.')

    public static void makeOrderUpdateAmount(List<String> orderIDs) {
        List<OrderSummary> orderSummaries = [SELECT Id, kpOrderID__c FROM OrderSummary WHERE OrderNumber IN :orderIDs];

        for (OrderSummary orderSummary : orderSummaries) {
            HttpResponse resp = KLA_ServiceMgr.orderUpdateAmountAPI(orderSummary.kpOrderID__c, orderSummary.Id);
            if (resp.getStatusCode() >= 200 && resp.getStatusCode() < 300) {
                System.debug('SUCCEEDED to update order amounts: ' + orderSummary.kpOrderID__c);
            } else {
               	Id orderSummaryId = orderSummary.Id;
               	KLA_ProcessException.addProcessException(orderSummaryId, orderSummaryId, 'Failed to update order amounts.', resp.getBody());
            }
        }

        KLA_ProcessException.insertProcessExceptions();
    }
}