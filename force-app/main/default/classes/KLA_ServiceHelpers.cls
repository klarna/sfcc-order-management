public class KLA_ServiceHelpers {
    /* Get service meta */
    public static ApiSettings__mdt getServiceMeta(String serviceName) {
        List<ApiSettings__mdt> meta = new List<ApiSettings__mdt>();
        String allFields = getAllFields(new ApiSettings__mdt());
        String queryString = 'SELECT ' + allFields + ' FROM ApiSettings__mdt WHERE Label = \'' + serviceName + '\'' ;
        meta = Database.query(queryString);
        return meta.size() > 0 ? meta.get(0) : null;
    }

    /* Get service custom fields */
    public static KLA_CustomServiceFields__c getServiceCustomFields(String serviceName) {
        List<KLA_CustomServiceFields__c> serviceCustomFieldsObjects = new List<KLA_CustomServiceFields__c>();
        String allFields = getAllFields(new KLA_CustomServiceFields__c());
        String queryString = 'SELECT ' + allFields + ' FROM KLA_CustomServiceFields__c WHERE serviceName__c = \'' + serviceName + '\'' ;
        serviceCustomFieldsObjects = Database.query(queryString);
        return serviceCustomFieldsObjects.size() > 0 ? serviceCustomFieldsObjects.get(0) : null;
    }

    /* Get service custom fields */
    public static Integer getMaxRetryCount(ApiSettings__mdt serviceSettings) {
        Integer maxRetryCount = serviceSettings != null ? (Integer)serviceSettings.maxRetryCount__c : KLA_ServiceConstants.MAX_RETRY_COUNT;
        return maxRetryCount != null && maxRetryCount > 0 && maxRetryCount <= KLA_ServiceConstants.MAX_RETRY_COUNT ? maxRetryCount : KLA_ServiceConstants.MAX_RETRY_COUNT;
    }

    /* Get service custom fields */
    public static String getAllFields(SObject obj) {
        DescribeSObjectResult descResult = obj.getSObjectType().getDescribe();
        List<String> fieldList = new List<String>(descResult.Fields.getMap().keySet());
        return String.join(fieldList, ',');
    }

    /* Log longer messages */
    public static void logLongString(String sMsg) {
        for (Integer i = 0; i < sMsg.length(); i=i+300) {
            Integer iEffectiveEnd = (i+300 > (sMsg.length()-1) ? sMsg.length()-1 : i+300);
            //Sensitive Information in Debug Vulnerability Fix
            System.debug(sMsg.substring(i,iEffectiveEnd));
        }
    }

    /* Convert date-time to unix */
    public static Long getUnixTimestamp(Datetime myDateTime) {
        Long unixTimestamp = myDateTime.getTime() / 1000;
        return unixTimestamp;
    }
    
    /* GET OrderSummary By Id */
    public static OrderSummary getOrderSummary(String id) {
        String allFields = KLA_ServiceHelpers.getAllFields(new OrderSummary());
        String queryString = 'SELECT ' + allFields + ' FROM OrderSummary WHERE Id = \'' + id + '\'' ;
        List<OrderSummary> orderSummaries = Database.query(queryString);
        return orderSummaries.size() > 0 ? orderSummaries.get(0) : null;
    }

    /* Get order item summary by order summary Id */
    public static List<OrderItemSummary> getOrderItemSummary(String orderSummaryId) {
        List<OrderItemSummary> orderItemSummaryList = new List<OrderItemSummary>();
        String allFields = getAllFields(new OrderItemSummary());
        String queryString = 'SELECT ' + allFields + ' FROM OrderItemSummary WHERE OrderSummaryId = \'' + orderSummaryId + '\'' ;
        orderItemSummaryList = Database.query(queryString);
        return orderItemSummaryList.size() > 0 ? orderItemSummaryList : null;
    }

    /* Get order line items JSON */
    public static Integer castToInt(Decimal value) {
        Integer intValue = Integer.valueOf(value * 100);
        return Math.abs(intValue);
    }
    
    /* Enrich order line items JSON */
    private static Map<String, Object> enrichOrderItemSummaryJSON(Map<String, Object> mapObj, String lineItemJSON) {
        if (lineItemJSON != null && lineItemJSON != '') {
            Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(lineItemJSON);
            String prodType = (String) jsonObj.get('type');
            String prodName = (String) jsonObj.get('name');
            String merchantData = (String) jsonObj.get('merchant_data');
            String productURL = (String) jsonObj.get('product_url');
            String imageURL = (String) jsonObj.get('image_url');
            Object productIdentifiers;

            if (jsonObj.get('product_identifiers') != null) {
                productIdentifiers = jsonObj.get('product_identifiers');
                mapObj.put('product_identifiers', productIdentifiers);
            }

            mapObj.put('prodType', prodType);
            mapObj.put('name', prodName);
            mapObj.put('merchant_data', merchantData);
            mapObj.put('product_url', productURL);
            mapObj.put('image_url', imageURL);
        }
        return mapObj;
    }

    /* Get order line items JSON */
    public static List<Object> getOrderItemSummaryJSON(String orderSummaryId) {
        OrderSummary orderSummary = KLA_ServiceHelpers.getOrderSummary(orderSummaryId);
        List<OrderItemSummary> orderItemSummaries = new List<OrderItemSummary>();
        orderItemSummaries = KLA_ServiceHelpers.getOrderItemSummary(orderSummaryId);

        Boolean isGross = orderSummary.TaxLocaleType == 'Gross' ? true : false;

        Object [] arrayOfLineItems = new List<Object>();
        for (OrderItemSummary item : orderItemSummaries) {
            Integer prodQty = Integer.valueOf(item.Quantity);
            String prodName = item.Name;
            Integer prodTotalPrice = KLA_ServiceHelpers.castToInt(item.TotalPrice);
            Integer prodUnitPrice = KLA_ServiceHelpers.castToInt(item.UnitPrice);
            String prodProductCode = item.ProductCode;
            Integer prodTotalAdjustmentAmtWithTax = KLA_ServiceHelpers.castToInt(item.TotalAdjustmentAmtWithTax);
            Integer prodTotalTaxAmount = isGross ? KLA_ServiceHelpers.castToInt(item.TotalTaxAmount) : 0;
            String lineItemJSON = item.lineItemJSON__c;

            Map<String, Object> mapObj = new Map<String, Object> {
                    'quantity' => prodQty,
                    'name'=> prodName,
                    'total_amount' => prodTotalPrice,
                    'unit_price' => prodUnitPrice,
                    'reference' => prodProductCode,
                    'total_discount_amount' => prodTotalAdjustmentAmtWithTax,
                    'total_tax_amount' => prodTotalTaxAmount
            };

            mapObj = KLA_ServiceHelpers.enrichOrderItemSummaryJSON(mapObj, lineItemJSON);

            arrayOfLineItems.add(mapObj);
        }
        
        if (!isGross) {
            Map<String, Object> salexTaxObj = new Map<String, Object> {
                'type' => 'sales_tax',
                'name'=> 'Sales Tax',
                'reference' => 'Sales Tax',
                'quantity' => 1,
                'unit_price' => KLA_ServiceHelpers.castToInt(orderSummary.TotalTaxAmount),
                'tax_rate' => 0,
                'total_amount' => KLA_ServiceHelpers.castToInt(orderSummary.TotalTaxAmount),
                'total_tax_amount' => 0,
                'total_discount_amount' => 0
            };
            arrayOfLineItems.add(salexTaxObj);
        } 
        
        return arrayOfLineItems;
    }
}