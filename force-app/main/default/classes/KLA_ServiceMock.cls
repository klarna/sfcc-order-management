@isTest
global class KLA_ServiceMock implements HttpCalloutMock  {
    private Boolean isMockResponseSuccessful;
    private String successResponse;
    private String failureResponse;
    private List<String> successResponses;

    public KLA_ServiceMock(Boolean isMockResponseSuccessful) {
        this.isMockResponseSuccessful  = isMockResponseSuccessful;
        successResponses = new List<String>();
    }

    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (this.isMockResponseSuccessful) {
            res.setBody(getSuccessResponse());
        	res.setStatusCode(200);
        } else {
            res.setBody(getFailureResponse());
        	res.setStatusCode(400);
        }
        return res;
    }

    public String getSuccessResponse() {
        return successResponse;
    }

    public String getFailureResponse() {
        return failureResponse;
    }

    public void setSuccessResponse(String successResponse) {
        successResponses.add(successResponse);
        this.successResponse = successResponse;
    }

    public void setFailureResponse(String failureResponse) {
        this.failureResponse = failureResponse;
    }

    public void resetServiceCustomFields(String serviceName) {
        KLA_CustomServiceFields__c serviceCustomFields = KLA_ServiceHelpers.getServiceCustomFields(serviceName);
    }
}