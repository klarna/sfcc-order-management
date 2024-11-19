public class KLA_ReleaseRemainingAuth_Service extends KLA_Service {
    public KLA_ReleaseRemainingAuth_Service(Map<String,String> params,String orderSummaryId) {

        super(KLA_ServiceConstants.KLA_POST_RELEASE_REMAINING_AUTHORIZATION, params);

        //Add Additional parameters related to Services
        serviceRequestBuilder.setAuthenticationProvier(new KLA_AuthProvider(serviceSettings));

        serviceRequestBuilder.setServiceSettings(serviceSettings, serviceCustomFields)
        .addRequestHeader('Klarna-Idempotency-Key', params.get('{order_id}') + '_' + Datetime.now().getTime())
        .setNameCredential(orderSummaryId)
        .build(params);
        setRequest(serviceRequestBuilder.getRequest());
    }
}