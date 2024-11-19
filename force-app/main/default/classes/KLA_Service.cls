public  virtual class KLA_Service {
    private String serviceName;
    public ApiSettings__mdt serviceSettings;
    public KLA_CustomServiceFields__c serviceCustomFields;
    private Map<String,String> params;
    private HttpRequest request;
    public KLA_ServiceRequestBuilder serviceRequestBuilder;

    public KLA_Service(String serviceName, Map<String,String> params) {
        this.serviceName = serviceName;
        this.params = params;
        serviceRequestBuilder = new KLA_ServiceRequestBuilder(serviceName);
        // Get service settings and custom fields
		this.serviceSettings = KLA_ServiceHelpers.getServiceMeta(serviceName);
        this.serviceCustomFields = KLA_ServiceHelpers.getServiceCustomFields(serviceName);
    }

    public void setRequest(HttpRequest request) {
        this.request = request;
    }

    private HttpResponse call() {
        Http http = new Http();

        Integer maxRetryCount = KLA_ServiceHelpers.getMaxRetryCount(serviceSettings);
        HttpResponse response;
        Integer runNumber = 0;

        while (runNumber < maxRetryCount) {
            runNumber++;
            //Sensitive Information in Debug Vulnerability Fix
            //System.debug(request);
            response = http.send(request);
	
            if (response.getStatusCode() == 503) {
                //retry
                continue;
            }
            return response;
        }
        return response;
    }

    public HttpResponse getResponse() {
        return call();
    }

}