public class KLA_RetrieveOrder_Service extends KLA_Service {
    public KLA_RetrieveOrder_Service(Map<String,String> params,String orderSummaryId) {

        super(KLA_ServiceConstants.KLA_GET_RETRIEVE_ORDER, params);

        //Add Additional parameters related to Services
        serviceRequestBuilder.setAuthenticationProvier(new KLA_AuthProvider(serviceSettings));

        serviceRequestBuilder.setServiceSettings(serviceSettings, serviceCustomFields)
        .setNameCredential(orderSummaryId)
        .build(params);
        setRequest(serviceRequestBuilder.getRequest());
    }
}