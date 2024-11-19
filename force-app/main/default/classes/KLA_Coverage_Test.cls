@isTest
public class KLA_Coverage_Test {
    @IsTest(SeeAllData=true)
    static void logLongString() {
        KLA_ServiceHelpers.logLongString('Test');
    }
    
    @IsTest(SeeAllData=true)
    static void getUnixTimestamp() {
        KLA_ServiceHelpers.getUnixTimestamp(Datetime.now());
    }
    
    @IsTest(SeeAllData=true)
    static void getNonExistingService() {
        KLA_Service expectedValue = null;
        KLA_Service service = KLA_ServiceFactory.getInstance('NON-EXISTING', null, null);
        System.assertEquals(service, expectedValue);
    }
    
    @IsTest(SeeAllData=true)
    static void serviceRequestBilder() {
        KLA_ServiceRequestBuilder requestBuilder = new KLA_ServiceRequestBuilder(KLA_ServiceConstants.KLA_GET_RETRIEVE_ORDER);
        Map<String, String> params =  new Map<String, String>();
        params.put('{order_id}', 'order_id');
        params.put('test', 'testParam');
        
        ApiSettings__mdt serviceSettings = KLA_ServiceHelpers.getServiceMeta(KLA_ServiceConstants.KLA_GET_RETRIEVE_ORDER);
        
        requestBuilder.setAuthenticationProvier(new KLA_AuthProvider(serviceSettings));
        requestBuilder.setAuthorizationBasic()
        .setServiceSettings(serviceSettings, null)
        .setAcceptHeaderValue('')
        .setContentTypeHeader('')
        .setNameCredential('')
        .build(params);
    }
    
    @IsTest(SeeAllData=true)
    static void makeOrderUpdateAmount_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_OrderUpdateAmount_Invocable.makeOrderUpdateAmount(orderIDs);
    }

    @IsTest(SeeAllData=true)
    static void makeOrderUpdateAmountFail_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(false);
        serviceMock.setFailureResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_OrderUpdateAmount_Invocable.makeOrderUpdateAmount(orderIDs);
    }
    
    @IsTest(SeeAllData=true)
    static void makeOrderCancellationCallout_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_OrderCancellation_Invocable.makeOrderCancellationCallout(orderIDs);
    }
    
    @IsTest(SeeAllData=true)
    static void makeOrderCancellationCalloutFail_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(false);
        serviceMock.setFailureResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_OrderCancellation_Invocable.makeOrderCancellationCallout(orderIDs);
    }
    
    @IsTest(SeeAllData=true)
    static void releaseRemainingAuth_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_ReleaseRemainingAuth_Invocable.releaseRemainingAuth(orderIDs);
    }
    
    @IsTest(SeeAllData=true)
    static void releaseRemainingAuthFail_Invocable() {
        List<String> orderIDs = new List<String>();
        orderIDs.add('00007320');
        
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(false);
        serviceMock.setFailureResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);

        KLA_ReleaseRemainingAuth_Invocable.releaseRemainingAuth(orderIDs);
    }
    
    @IsTest(SeeAllData=true)
    static void processException() {
        Test.startTest();

        OrderSummary OS = [SELECT Id FROM OrderSummary WHERE OrderNumber LIKE '%NKP%' LIMIT 1];
        Id orderSummaryId = OS.Id;
        KLA_ProcessException.addProcessException(orderSummaryId, orderSummaryId, 'Test', 'Response Test');
        
        List<ProcessException> processExceptions = KLA_ProcessException.getProcessExceptions();
        
        KLA_ProcessException.insertProcessExceptions();
        
        Test.stopTest();
    }
    
    @IsTest(SeeAllData=true)
    static void processExceptionEvent() {
        Test.startTest();

        OrderSummary OS = [SELECT Id FROM OrderSummary WHERE OrderNumber LIKE '%NKP%' LIMIT 1];
        Id orderSummaryId = OS.Id;
        KLA_ProcessException.addProcessExceptionEvent(orderSummaryId, orderSummaryId, 'Test', 'Response Test', 'Description Test');
        
        List<ProcessExceptionEvent> processExceptionEvents = KLA_ProcessException.getProcessExceptionEventList();
        
        KLA_ProcessException.insertProcessExceptionEventList();

        Test.stopTest();
    }

}