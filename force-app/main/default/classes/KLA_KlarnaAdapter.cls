global class KLA_KlarnaAdapter implements commercepayments.PaymentGatewayAdapter {

    /* PROCESS REQUEST
     * Entry point for the payment adapter
     */
    global commercepayments.GatewayResponse processRequest(commercepayments.paymentGatewayContext gatewayContext) {
        try {
            String requestType = gatewayContext.getPaymentRequestType().name();
            commercepayments.AbstractResponse response;

            if (requestType == commercepayments.RequestType.Capture.name()) {
                response = KLA_CaptureOrder_Service.capturePaymentIntent((commercepayments.CaptureRequest)gatewayContext.getPaymentRequest());
            } else if (requestType == commercepayments.RequestType.ReferencedRefund.name()) {
                response = KLA_RefundslOrder_Service.refundPayment((commercepayments.ReferencedRefundRequest)gatewayContext.getPaymentRequest());
            }
            return response;
        } catch(NoAccessException e) {
            commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse('-1', e.getMessage());
            return error;
        } catch(Exception e) {
            commercepayments.GatewayErrorResponse error = new commercepayments.GatewayErrorResponse('-2', e.getMessage());
            return error;
        }
    }

    /* SEND REQUEST
     * Making a request and sending it
     */
    public static HttpResponse sendRequest(String method, String bodyJson, String URLpath, String idempotencyKey) {
        HttpRequest request = new HttpRequest();

        request.setHeader('Accept', KLA_ServiceConstants.ACCEPT_ALL);
        request.setHeader('Content-Type', KLA_ServiceConstants.CONTENT_TYPE_JSON);
        request.setHeader('Klarna-Idempotency-Key', idempotencyKey + '-' + Datetime.now().getTime());
        request.setEndpoint(URLpath);
        request.setMethod(method);
        request.setBody(bodyJson);
        request.setTimeout(120000);

        HttpResponse response = new HttpResponse();
        return new commercepayments.PaymentsHttp().send(request);
    }

    /* CHECK ACCESS
     * Objects and fields for LOM are currently not recognized
     * when using global describe to grab all objects and check access.
     * Check read access to all objects and fields for query
     */
    public static void checkAccess() {
        if(!(Schema.sObjectType.Payment.isAccessible()
             && Schema.sObjectType.Payment.fields.Id.isAccessible()
             && Schema.sObjectType.Payment.fields.OrderPaymentSummaryId.isAccessible()
             && Schema.sObjectType.PaymentAuthorization.isAccessible()
             && Schema.sObjectType.PaymentAuthorization.fields.Id.isAccessible()
             && Schema.sObjectType.PaymentAuthorization.fields.OrderPaymentSummaryId.isAccessible()
             && Schema.sObjectType.OrderPaymentSummary.isAccessible()
             && Schema.sObjectType.OrderPaymentSummary.fields.Id.isAccessible()
             && Schema.sObjectType.OrderPaymentSummary.fields.OrderSummaryId.isAccessible()
             && Schema.sObjectType.OrderSummary.isAccessible()
             && Schema.sObjectType.OrderSummary.fields.Id.isAccessible()
             && Schema.sObjectType.OrderSummary.fields.OriginalOrderId.isAccessible()
             && Schema.sObjectType.Order.isAccessible()
             && Schema.sObjectType.Order.fields.Id.isAccessible() )) {
                //throw error
                throwException('You do not have the required read access permissions for Payment, PaymentAuthorization, OrderPaymentSummary, OrderSummary, Order and their fields.');
        }
    }

    /* HANDLE ACCESS EXCEPTIONS
     *
     */
    public class accessException extends Exception {
        public override String getStackTraceString() {
            return super.getCause().getStackTraceString();
        }
    }

    private static void throwException(String message) {
        try {
            throw new NoAccessException();
        } catch (Exception e) {
            throw new accessException(message, e);
        }
    }
}