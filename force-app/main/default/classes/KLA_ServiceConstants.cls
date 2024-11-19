public class KLA_ServiceConstants {
    /* Service Configurations - Start */
        public static final String FORMAT_JSON  = 'application/json';
        public static final String CONTENT_TYPE_JSON = 'application/json; charset=utf-8';
        public static final String CONTENT_TYPE_URLENCODED = 'application/x-www-form-urlencoded';
        public static final String ACCEPT_ALL = '*/*';
        public static final String METHOD_GET  = 'GET';
        public static final String METHOD_POST  = 'POST';
        public static final String METHOD_PATCH  = 'PATCH';
        public static final Integer MAX_RETRY_COUNT = 3;
    /* Service Configurations - End   */

    /* SPECIFIC CONSTANTS - Start */
        public static final String KLA_GET_RETRIEVE_ORDER = 'RetrieveOrder';
        public static final String KLA_POST_CANCEL_ORDER = 'CancelOrder';
        public static final String KLA_POST_REFUND_ORDER = 'RefundOrder';
        public static final String KLA_PATCH_UPDATE_ORDER_AMOUNT = 'UpdateOrderAmount';
        public static final String KLA_POST_RELEASE_REMAINING_AUTHORIZATION = 'ReleaseRemainingAuthorization';
        public static final String DEFAULT_NAME_CREDENTIAL  = 'KlarnaAuth';
    /* SPECIFIC CONSTANTS - End   */

    /* PAYMENT ADAPTER SPECIFIC CONSTANTS - Start */
        public static final commercepayments.SalesforceResultCodeInfo SUCCESS_SALESFORCE_RESULT_CODE_INFO =
            new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Success);
        public static final commercepayments.SalesforceResultCodeInfo DECLINE_SALESFORCE_RESULT_CODE_INFO =
            new commercepayments.SalesforceResultCodeInfo(commercepayments.SalesforceResultCode.Decline);

        public static final String KLA_OM_APPLY_FAILED = 'OM Apply Failed';
        public static final String KLA_OM_CAPTURE_FAILED = 'OM Capture Failed';
        public static final String KLA_OM_REFUND_FAILED = 'OM Refund Failed';
    /* PAYMENT ADAPTER SPECIFIC CONSTANTS - End */
}