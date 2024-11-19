public class KLA_ReleaseRemainingAuth_Invocable {
    @InvocableMethod(label='Release Remaining Authorization' description='Releases the remaining authorization of the order by passing the list of order summary number.')

    public static void releaseRemainingAuth(List<String> orderIDs) {
        List<OrderSummary> orderSummaries = [SELECT Id, kpOrderID__c FROM OrderSummary WHERE OrderNumber IN :orderIDs];

        for (OrderSummary orderSummary : orderSummaries) {
            HttpResponse resp = KLA_ServiceMgr.releaseRemainingAuthAPI(orderSummary.kpOrderID__c, orderSummary.Id);
            if (resp.getStatusCode() >= 200 && resp.getStatusCode() < 300) {
                System.debug('SUCCEEDED to releases the remaining authorization: ' + orderSummary.kpOrderID__c);
            } else {
               	Id orderSummaryId = orderSummary.Id;
               	KLA_ProcessException.addProcessException(orderSummaryId, orderSummaryId, 'Failed to releases the remaining authorization.', resp.getBody());
            }
        }

        KLA_ProcessException.insertProcessExceptions();
    }
}