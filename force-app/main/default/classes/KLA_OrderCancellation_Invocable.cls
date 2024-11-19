public class KLA_OrderCancellation_Invocable {
    @InvocableMethod(label='Cancel Orders' description='Cancel list of orders by passing the list of order summary number.')

    public static void makeOrderCancellationCallout(List<String> orderIDs) {
        List<OrderSummary> orderSummaries = [SELECT Id, kpOrderID__c FROM OrderSummary WHERE OrderNumber IN :orderIDs];

        for (OrderSummary orderSummary : orderSummaries) {
            HttpResponse resp = KLA_ServiceMgr.orderCancelAPI(orderSummary.kpOrderID__c, orderSummary.Id);
            if (resp.getStatusCode() >= 200 && resp.getStatusCode() < 300) {
                System.debug('SUCCEEDED to cancel order: ' + orderSummary.kpOrderID__c);
            } else {
               	Id orderSummaryId = orderSummary.Id;
               	KLA_ProcessException.addProcessException(orderSummaryId, orderSummaryId, 'Failed to cancel the order.', resp.getBody());
            }
        }

        KLA_ProcessException.insertProcessExceptions();
    }
}