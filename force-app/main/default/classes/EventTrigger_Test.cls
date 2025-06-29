@isTest
private class EventTrigger_Test {

    @TestSetup
    public static void createInterviewEventData(){

        RecordType interviewRecordType = [ SELECT Id, DeveloperName 
                                            FROM RecordType 
                                            WHERE DeveloperName = 'Interview_Event'];
        
        Job_Application__c jobApplication = new Job_Application__c(
            Company_Name__c = 'Salesforce',
            Location__c = 'Remote',
            Salary__c = 170000,
            URL__c = 'www.salesforce.com'
        );
        insert jobApplication;

        Contact interviewer = new Contact(
            FirstName = 'Joe',
            LastName = 'Montana',
            Job_Application__c = jobApplication.Id
        );
        insert interviewer;

        Event interviewEvent = new Event(
            Subject = 'Test Interview #1',
            WhatId = jobApplication.Id,
            Interviewer__c = interviewer.Id,
            StartDateTime = DateTime.valueOf('2025-07-25 09:30:00'),
            EndDateTime = DateTime.valueOf('2025-07-25 10:30:00'),
            Description = 'Salesforce Interview Description',
            RecordTypeId = interviewRecordType.Id
        );
        insert interviewEvent;
    }

    @isTest
    public static void insertInterviewEventWithSameDate_ExpectError() {
        RecordType interviewRecordType = [ SELECT Id, DeveloperName 
                                            FROM RecordType 
                                            WHERE DeveloperName = 'Interview_Event'];
        
        Job_Application__c jobApplication = new Job_Application__c(
            Company_Name__c = 'Patagonia',
            Location__c = 'Remote',
            Salary__c = 130000,
            URL__c = 'www.patagonia.com'
        );
        insert jobApplication;

        Contact interviewer = new Contact(
            FirstName = 'Will',
            LastName = 'Thompson',
            Job_Application__c = jobApplication.Id
        );
        insert interviewer;

        Event interviewEvent = new Event(
            Subject = 'Test Interview #2',
            WhatId = jobApplication.Id,
            Interviewer__c = interviewer.Id,
            StartDateTime = DateTime.valueOf('2025-07-25 10:00:00'),
            EndDateTime = DateTime.valueOf('2025-07-25 11:00:00'),
            Description = 'Patagonia Interview Description',
            RecordTypeId = interviewRecordType.Id
        );
        Boolean exceptionThrown = false;

        Test.startTest();
            try {
                insert interviewEvent;
            } catch (DmlException ex) {
                exceptionThrown = true;
                System.debug(ex);
            }
        Test.stopTest();
        Assert.areEqual(true, exceptionThrown, 'We expected an exception to be thrown.');

        
    }
}