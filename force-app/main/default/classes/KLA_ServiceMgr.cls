public class KLA_ServiceMgr {

    public static HttpResponse getListOrdersAPI(String orderNumber, String orderSummaryId) {
        Map<String, String> params =  new Map<String, String>();
        params.put('{order_id}', orderNumber);

        KLA_Service service = KLA_ServiceFactory.getInstance(KLA_ServiceConstants.KLA_GET_RETRIEVE_ORDER, params, orderSummaryId);
        return service.getResponse();
   	}

    public static HttpResponse orderCancelAPI(String orderNumber, String orderSummaryId) {
        Map<String, String> params = new Map<String, String>();
        params.put('{order_id}', orderNumber);

        KLA_Service service = KLA_ServiceFactory.getInstance(KLA_ServiceConstants.KLA_POST_CANCEL_ORDER, params, orderSummaryId);
        return service.getResponse();
    }

    public static HttpResponse orderUpdateAmountAPI(String orderNumber, String orderSummaryId) {
        Map<String, String> params = new Map<String, String>();
        Map<String, Object> jsonData = new Map<String, Object>();
        params.put('{order_id}', orderNumber);

        OrderSummary orderSummary = [SELECT Id, GrandTotalAmount FROM OrderSummary WHERE kpOrderID__c = :orderNumber];
        List<Object> orderItemSummaries = KLA_ServiceHelpers.getOrderItemSummaryJSON(orderSummary.Id);

        jsonData.put('order_amount', KLA_ServiceHelpers.castToInt(orderSummary.GrandTotalAmount));
        jsonData.put('order_lines', orderItemSummaries);

        params.put('requestBody', JSON.serialize(jsonData));

        KLA_Service service = KLA_ServiceFactory.getInstance(KLA_ServiceConstants.KLA_PATCH_UPDATE_ORDER_AMOUNT, params, orderSummaryId);
        return service.getResponse();
    }

    public static HttpResponse releaseRemainingAuthAPI(String orderNumber, String orderSummaryId) {
        Map<String, String> params =  new Map<String, String>();
        params.put('{order_id}', orderNumber);

        KLA_Service service = KLA_ServiceFactory.getInstance(KLA_ServiceConstants.KLA_POST_RELEASE_REMAINING_AUTHORIZATION, params, orderSummaryId);
        return service.getResponse();
   	}
}