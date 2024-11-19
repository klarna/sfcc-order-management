public class KLA_OrderUpdateAmount_Service extends KLA_Service {
    public KLA_OrderUpdateAmount_Service(Map<String,String> params,String orderSummaryId) {

        super(KLA_ServiceConstants.KLA_PATCH_UPDATE_ORDER_AMOUNT, params);

        //Add Additional parameters related to Services
        serviceRequestBuilder.setAuthenticationProvier(new KLA_AuthProvider(serviceSettings));

        serviceRequestBuilder.setServiceSettings(serviceSettings, serviceCustomFields)
        .addRequestHeader('Klarna-Idempotency-Key', params.get('{order_id}') + '_' + Datetime.now().getTime())
        .setNameCredential(orderSummaryId)
        .build(params);
        setRequest(serviceRequestBuilder.getRequest());
    }
}