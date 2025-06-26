public without sharing class JobInterviewReminderEmailSchedulable implements Schedulable {
    public static void execute(SchedulableContext sc) {

        List<Event> interviewEventList = new List<Event>();
        List<RecordType> eventRecordTypeList = [ SELECT Id, DeveloperName, SobjectType 
                                                    FROM RecordType
                                                    WHERE SobjectType = 'Event' AND DeveloperName = 'Interview_Event'
                                                    LIMIT 1 ];

        if (!eventRecordTypeList.isEmpty()) {
            interviewEventList = [ SELECT Subject, 
                                            WhoId, 
                                            Interviewer__c, 
                                            Interview_Format__c, 
                                            Interview_Type__c,
                                            Location, 
                                            StartDateTime, 
                                            EndDateTime, 
                                            WhatId,
                                            Description,
                                            Owner.Email,
                                            Interviewer__r.Name
                                    FROM Event 
                                    WHERE RecordTypeId = :eventRecordTypeList[0].id ];
        }

        if (!interviewEventList.isEmpty()) {
            List<Event> tomorrowsInterviewReminderList = new List<Event>();
            for (Event event : interviewEventList) {
                if (event.StartDateTime.Date() == (Date.today().addDays(1))) {
                    tomorrowsInterviewReminderList.add(event);
                }
            }
            sendInterviewReminderEmailForTomorrowsInterview(tomorrowsInterviewReminderList);
        }
    }

    private static void sendInterviewReminderEmailForTomorrowsInterview(List<Event> tomorrowsInterviewReminderList) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        
        for (Event tomorrowsEvent : tomorrowsInterviewReminderList) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(tomorrowsEvent.Subject);
            email.setHtmlBody(
                '<p>Don\'t forget you have an interview tomorrow with the following details:</p>' +
                '<ol>' +
                    '<li><strong>Subject:</strong> ' + tomorrowsEvent.Subject + '</li>' +
                    '<li><strong>Start Time:</strong> ' + tomorrowsEvent.StartDateTime + '</li>' +
                    '<li><strong>End Time:</strong> ' + tomorrowsEvent.EndDateTime + '</li>' +
                    '<li><strong>Interviewer:</strong> ' + tomorrowsEvent.Interviewer__r.Name + '</li>' +
                    '<li><strong>Interview Type:</strong> ' + tomorrowsEvent.Interview_Type__c + '</li>' +
                    '<li><strong>Interview Format:</strong> ' + tomorrowsEvent.Interview_Format__c + '</li>' +
                    '<li><strong>Description:</strong> ' + tomorrowsEvent.Description + '</li>' +
                    '<li><strong>Location:</strong> ' + tomorrowsEvent.Location + '</li>' +
                '</ol>'
            );
            if (tomorrowsEvent.Owner != null && tomorrowsEvent.Owner.Email != null) {
                System.debug(JSON.serializePretty('We\'re inside of the IF statement::::::::::'));
                System.debug(JSON.serializePretty(tomorrowsEvent.Owner));
                System.debug(JSON.serializePretty(tomorrowsEvent.Owner.Email));
                email.setToAddresses(new List<String> {tomorrowsEvent.Owner.Email} );
            }else {
                continue;
            }
            emailList.add(email);
        }
        List<Messaging.SendEmailResult> emailResultList = Messaging.sendEmail(emailList);
        System.debug(emailResultList);
    }
}