public class KLA_Cancellation_Service extends KLA_Service {
    public KLA_Cancellation_Service(Map<String,String> params) {

        super(KLA_ServiceConstants.KLA_POST_CANCEL_ORDER, params);
		
        //Add Additional parameters related to Services
        serviceRequestBuilder.setAuthenticationProvier(new KLA_AuthProvider(serviceSettings));

        serviceRequestBuilder.setServiceSettings(serviceSettings, serviceCustomFields)
       // .setRequiresAuthentication(true)
        .build(params);
        setRequest(serviceRequestBuilder.getRequest());
    }
}