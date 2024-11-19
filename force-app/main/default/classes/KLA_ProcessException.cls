public class KLA_ProcessException extends Exception {

    private static List<ProcessException> processExceptions = new List<ProcessException>();
    private static List<ProcessExceptionEvent> processExceptionEventList = new List<ProcessExceptionEvent>();

    public static void addProcessException(Id attachedToId, Id orderSummaryId, String message, String desctiption) {
        ProcessException processException = new ProcessException();
        processException.AttachedToId = attachedToId;
        processException.OrderSummaryId = orderSummaryId;
        processException.Message = message;
        processException.Description = desctiption;
        processExceptions.add(ProcessException);
    }

    public static void addProcessExceptionEvent(Id attachedToId, Id orderSummaryId, String exceptionType, String message, String desctiption) {
        ProcessExceptionEvent processExceptionEvent = new ProcessExceptionEvent();
        processExceptionEvent.ExternalReference = message;
        processExceptionEvent.AttachedToId = attachedToId;
        processExceptionEvent.OrderSummaryId = orderSummaryId;
        processExceptionEvent.Message = message;
        processExceptionEvent.Description = desctiption;
        processExceptionEvent.ExceptionType = exceptionType;
        processExceptionEventList.add(processExceptionEvent);
    }

    public static List<ProcessException> getProcessExceptions() {
        return processExceptions;
    }

    public static List<ProcessExceptionEvent> getProcessExceptionEventList() {
        return processExceptionEventList;
    }

    public static void insertProcessExceptions() {
        upsert processExceptions;
    }

    public static void insertProcessExceptionEventList () {
        List<Database.SaveResult> results = EventBus.publish(processExceptionEventList);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage());
                }
            }
        }
    }
}