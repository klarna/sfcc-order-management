@isTest (SeeAllData = true)
public class KLA_ServiceMgr_Test {

   

    
    private static testMethod void getListOrders() {
        String expectedValue = '{"success" : "true"}';        
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        PaymentGateway pg = [SELECT Id,MerchantCredential.DeveloperName FROM PaymentGateway  LIMIT 1 ];
       
        CardPaymentMethod Cpm = [SELECT Id,PaymentGatewayId FROM CardPaymentMethod WHERE PaymentGatewayId = : pg.Id LIMIT 1];
        
        OrderPaymentSummary Ops = [SELECT OrderSummaryId FROM OrderPaymentSummary  LIMIT 1];
       
        OrderSummary OS = [SELECT Id,OrderLifeCycleType,OrderNumber,OriginalOrderId FROM OrderSummary WHERE Id = :Ops.OrderSummaryId LIMIT 1];
      
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);
        HttpResponse res = KLA_ServiceMgr.getListOrdersAPI(OS.OrderNumber, OS.Id);
        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();

        System.assert(contentType == 'application/json');
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    
    private static testMethod void orderCancel() {
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);
        PaymentGateway pg = [SELECT Id,MerchantCredential.DeveloperName FROM PaymentGateway  LIMIT 1 ];
        
        CardPaymentMethod Cpm = [SELECT Id,PaymentGatewayId FROM CardPaymentMethod WHERE PaymentGatewayId = : pg.Id LIMIT 1];
        
        OrderPaymentSummary Ops = [SELECT OrderSummaryId FROM OrderPaymentSummary  LIMIT 1];
        
        OrderSummary OS = [SELECT Id,OrderLifeCycleType,OrderNumber,OriginalOrderId FROM OrderSummary WHERE Id = :Ops.OrderSummaryId LIMIT 1];
        
        HttpResponse res = KLA_ServiceMgr.orderCancelAPI(OS.OrderNumber, OS.Id);

        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();

        System.assert(contentType == 'application/json');
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    
    private static testMethod void orderUpdateAmount() {
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);
        PaymentGateway pg = [SELECT Id,MerchantCredential.DeveloperName FROM PaymentGateway  LIMIT 1 ];
        
        CardPaymentMethod Cpm = [SELECT Id,PaymentGatewayId FROM CardPaymentMethod WHERE PaymentGatewayId = : pg.Id LIMIT 1];
        
        OrderPaymentSummary Ops = [SELECT OrderSummaryId FROM OrderPaymentSummary  LIMIT 1];
        
        OrderSummary OS = [SELECT Id,OrderLifeCycleType,OrderNumber,OriginalOrderId,kpOrderID__c FROM OrderSummary WHERE Id = :Ops.OrderSummaryId LIMIT 1];
        
        HttpResponse res = KLA_ServiceMgr.orderUpdateAmountAPI(OS.kpOrderID__c, OS.Id);

        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();

        System.assert(contentType == 'application/json');
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    
    private static testMethod void releaseRemainingAuth() {
        String expectedValue = '';
        KLA_ServiceMock serviceMock = new KLA_ServiceMock(true);
        serviceMock.setSuccessResponse(expectedValue);
        Test.setMock(HttpCalloutMock.class, serviceMock);
        PaymentGateway pg = [SELECT Id,MerchantCredential.DeveloperName FROM PaymentGateway  LIMIT 1 ];
        
        CardPaymentMethod Cpm = [SELECT Id,PaymentGatewayId FROM CardPaymentMethod WHERE PaymentGatewayId = : pg.Id LIMIT 1];
        
        OrderPaymentSummary Ops = [SELECT OrderSummaryId FROM OrderPaymentSummary  LIMIT 1];
        
        OrderSummary OS = [SELECT Id,OrderLifeCycleType,OrderNumber,OriginalOrderId FROM OrderSummary WHERE Id = :Ops.OrderSummaryId LIMIT 1];
        
        HttpResponse res = KLA_ServiceMgr.releaseRemainingAuthAPI(OS.OrderNumber, OS.Id);

        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();

        System.assert(contentType == 'application/json');
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

}