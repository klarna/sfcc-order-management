@isTest
public class KLA_KlarnaAdapter_Mock implements HttpCalloutMock {

    public static HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        String endpoint = request.getEndpoint();
        if(endpoint.contains('capture') ) {
            //requesting capture
            String bodyString = request.getBody();
            System.debug(bodyString);
            if(bodyString.contains('2000')) {
                response.setStatus('OK');
                response.setStatusCode(200);
                Map<String, Object> responseBody = new Map<String, Object> {
                    'error' => new Map<String, Object> {
                                   'code' => 'Amount To Capture Invalid',
                                   'message' => 'Amount To Capture cannot be greater than the maximum on the payment intent'
                               }
                };
                response.setBody(JSON.serialize(responseBody));
            } else if(bodyString.contains('-1000')) {
                response.setStatusCode(400);
                response.setStatus('Bad Request');
            } else if(!bodyString.contains('captured_amount')) {
                response.setStatusCode(400);
                response.setStatus('Bad Request, amount to capture is missing');
            } else {
                response.setStatus('OK');
                response.setStatusCode(200);
                Map<String, Object> responseBody = new Map<String, Object> {
                    'status' => 'succeeded',
                    'id' => 'testId',
                    'amount_received' => 1000
                };
                response.setBody(JSON.serialize(responseBody));
            }

        } else if(endpoint.contains('token')) {
            response.setStatus('OK');
            response.setStatusCode(200);
            Map<String, Object> body = new Map<String, Object> {
                'access_token' => 'access123'
            };
            response.setBody(JSON.serialize(body));
        } else {
            //requesting refund
            String bodyString = request.getBody();
            if(bodyString.contains('10000')) {
                response.setStatusCode(200);
                response.setStatus('OK');
                Map<String, Object> responseBody = new Map<String, Object> {
                    'error' => new Map<String, Object> {
                        'message' => 'Amount Refunded cannot be greater than original payment amount.',
                        'code' => 'Amount To Refund Invalid'
                    }
                };
                response.setBody(JSON.serialize(responseBody));
            } else if(bodyString.contains('40000')) {
                response.setStatus('Payment Refund Failed Response Body');
                response.setStatusCode(400);
            } else {
                response.setStatus('OK');
                response.setStatusCode(200);
                Map<String, Object> responseBody = new Map<String, Object> {
                    'status' => 'succeeded',
                    'refunded_amount' => 1000,
                    'payment_intent' => 'testPI'
                };
                response.setBody(JSON.serialize(responseBody));
            }
        }
        return response;
    }
}