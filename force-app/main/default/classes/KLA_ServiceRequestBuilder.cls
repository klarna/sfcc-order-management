public class KLA_ServiceRequestBuilder {
    private HttpRequest request;
    private String serviceName;
    private ApiSettings__mdt serviceSettings;
    private KLA_CustomServiceFields__c serviceCustomFields;
    private String httpMethod = null;
    private Map<String, String> additionalHeaders;
    private String nameCredential = '';
    public KLA_AuthProvider authenticationProvider;
    //private MockResponseProvider mockResponseProvider = null; we can inject directly the Mock response provider for the specific service
    //private AuthenticationProvider authenticationProvider = null; e.g for Facebook , Google etc we can choose which one and just do something like that authenticationProvider.getTokenBearer();
    private String customURLParameters;
    //Default values
    private String headerAcceptValue = KLA_ServiceConstants.FORMAT_JSON;
    private String headerContentTypeValue = KLA_ServiceConstants.FORMAT_JSON;


    public KLA_ServiceRequestBuilder(String serviceName) {
        this.request = new HttpRequest();
        this.serviceName = serviceName;
        this.additionalHeaders = new Map<String, String>();
    }

   /**
    * CALL THIS METHOD LAST
    */
    public void build(Map<String, String> params) {
        String URLpath = serviceSettings.URLpath__c;

        addAdditionalRequestHeaders();
        setHttpMethod(serviceSettings.method__c);
        URLpath = replaceURLPlaceHolders(URLpath, params);

        if (this.httpMethod == KLA_ServiceConstants.METHOD_GET) {
            // Append Params to the URL
            URLpath = appendParamsToUrl(URLpath, params);
        } else {
            // Append Params to the request Body
            if (params.containsKey('requestBody')) {
                request.setBody(params.get('requestBody'));
            }
        }

        request.setMethod(httpMethod);
        request.setEndpoint('callout:' + this.nameCredential + URLpath);
    }

    private String replaceURLPlaceHolders (String URL , Map<String, String> params) {
        List<string> placeHoldersToRemove = new List<string>();
        for (String paramKey :  params.keySet()) {
            if (URL.contains(paramKey)) {
                URL = URL.replace(paramKey, params.get(paramKey));
                placeHoldersToRemove.add(paramKey);
            }
        }

        /*
         * Remove PlaceHolders from params
         */
        for (String key : placeHoldersToRemove) {
            params.remove(key);
        }
        return URL;
    }

    private void addAdditionalRequestHeaders() {
        request.setHeader('Accept', headerAcceptValue);
        request.setHeader('Content-Type', headerContentTypeValue);

        for (String headerKey :  additionalHeaders.keySet()) {
            request.setHeader(headerKey, additionalHeaders.get(headerKey));
        }

    }

    public KLA_ServiceRequestBuilder setAuthorizationBasic() {
        String authToken = 'Basic ' + authenticationProvider.getBasicToken();
        request.setHeader('Authorization', authToken);

        return this;
    }

    /*
     SETTERS
    */

    // IMPORTANT : This function should be called first in order to have metadata and custom fields loaded
    public KLA_ServiceRequestBuilder setServiceSettings(ApiSettings__mdt serviceSettings, KLA_CustomServiceFields__c serviceCustomFields) {
        this.serviceSettings = serviceSettings;
        this.serviceCustomFields = serviceCustomFields;
        return this;
    }

    public KLA_ServiceRequestBuilder setAcceptHeaderValue(String  acceptHeaderValue) {
        this.headerAcceptValue = acceptHeaderValue;
        return this;
    }
    public KLA_ServiceRequestBuilder setContentTypeHeader(String  contentTypeHeaderValue) {
        this.headerContentTypeValue = contentTypeHeaderValue;
        return this;
    }

    /**
     * Please note that the HttpMethod can be set only once per instance
     */
    public KLA_ServiceRequestBuilder setHttpMethod(String method) {
        this.httpMethod = (this.httpMethod == null) ? method : method;
        return this;
    }

    public KLA_ServiceRequestBuilder addRequestHeader(String headerName, String headerValue) {
        this.additionalHeaders.put(headerName, headerValue);
        return this;
    }

    public KLA_ServiceRequestBuilder setNameCredential(String orderSummaryId) {
        String nameCredential = '';

        if (orderSummaryId != '') {
            OrderPaymentSummary ops = [SELECT PaymentMethodId FROM OrderPaymentSummary WHERE OrderSummaryId = :orderSummaryId];
            CardPaymentMethod cpm = [SELECT PaymentGatewayId FROM CardPaymentMethod WHERE Id = :ops.PaymentMethodId ];
            PaymentGateway pg = [SELECT MerchantCredential.DeveloperName FROM PaymentGateway WHERE Id = :cpm.PaymentGatewayId];
            nameCredential = pg.MerchantCredential.DeveloperName;
        }

        if (nameCredential == '') {
            this.nameCredential = KLA_ServiceConstants.DEFAULT_NAME_CREDENTIAL;
        } else {
            this.nameCredential = nameCredential;
        }

        return this;
    }

    /**
     * GETTERS
     */

     public HttpRequest getRequest (){
        return this.request;
     }

    private String appendParamToURL(String url, String name, String value) {
        /**
         * If param already exists return url
         */

        if (url.indexOf(name + '=') != -1) {
            return url;
        }

        String separator = url.indexOf('?') != -1 ? '&' : '?';

        return url + separator + name + '=' + EncodingUtil.URLENCODE(value, 'UTF-8').replace('+', '%20').replace('%3A', ':');
    }

    private String appendParamsToUrl(String url, Map<String, String> params) {
        String newURL = url;
        for (String paramKey : params.keySet()) {
            newURL = appendParamToURL(newURL, paramKey, params.get(paramKey));
        }
        return newURL;
    }

    public void setAuthenticationProvier (KLA_AuthProvider provider) {
        this.authenticationProvider = provider;
    }
}