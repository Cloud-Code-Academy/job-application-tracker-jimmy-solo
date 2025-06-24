public with sharing class EventTriggerHelper {
    
    public static void ensureNoOtherInterviewEventsOnTodaysDate(List<Event> interviewTriggerNewEventList){
        
        List<Event> interviewEventList = [ SELECT Id, ActivityDate
                                            FROM Event ];

        for (Event event : interviewEventList) {
            for (Event newTriggerEvent : interviewTriggerNewEventList) {
                Date newTriggerStartDate = newTriggerEvent.StartDateTime.date();

                if (event.ActivityDate == newTriggerStartDate) {
                    newTriggerEvent.addError('You already have an interview scheduled for today.');
                    break;
                }
            }
        }
    }
}