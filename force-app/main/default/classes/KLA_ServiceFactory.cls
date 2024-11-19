public class KLA_ServiceFactory {
  private static KLA_Service getServiceBuilder(String serviceName , Map<String,String> params, String orderSummaryId) {

        switch on serviceName {
            when 'RetrieveOrder' {
                return new KLA_RetrieveOrder_Service(params, orderSummaryId);
            }
            when 'CancelOrder' {
                return new KLA_OrderCancellation_Service(params, orderSummaryId);
            }
            when 'UpdateOrderAmount' {
                return new KLA_OrderUpdateAmount_Service(params, orderSummaryId);
            }
            when 'ReleaseRemainingAuthorization' {
                return new KLA_ReleaseRemainingAuth_Service(params, orderSummaryId);
            }
        }
        return null;
    }

    public static KLA_Service getInstance(String serviceName, Map<String,String> params, String orderSummaryId) {
        return getServiceBuilder(serviceName, params, orderSummaryId);
    }
}