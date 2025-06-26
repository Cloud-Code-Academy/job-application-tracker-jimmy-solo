@IsTest
public class JobInterviewReminderEmail_Test {

    @IsTest
    static void testJobInterviewReminderSchedulable() {

        Contact interviewer = new Contact(
            FirstName = 'Pete',
            LastName = 'Thompson',
            Email = 'pthompson@testing.com'
        );
        insert(interviewer);

        User testUser = new User(
            Alias = 'tuser',
            Email = 'jimmy.turner@coaccess.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser' + DateTime.now().getTime() + '@example.com'
        );
        insert(testUser);

        RecordType interviewRT = [
                                    SELECT Id, DeveloperName, SobjectType 
                                    FROM RecordType 
                                    WHERE SObjectType = 'Event' AND DeveloperName = 'Interview_Event' 
                                    LIMIT 1
                                ];

        // Insert an Event with StartDateTime = tomorrow
        Event interviewEvent = new Event(
            Subject = 'Interview with Candidate',
            RecordTypeId = interviewRT.Id,
            OwnerId = testUser.Id,
            Interviewer__c = interviewer.Id,
            Interview_Format__c = 'Remote Video',
            Interview_Type__c = 'Panel',
            StartDateTime = DateTime.now().addDays(1).addHours(1),
            EndDateTime = DateTime.now().addDays(1).addHours(2),
            Description = 'Interview for Software Engineer'
        );
        insert(interviewEvent);

        Test.startTest();
            String cronExp = '0 0 12 * * ?'; // Daily at noon
            String jobId = System.schedule('Test Interview Reminder Job', cronExp, new JobInterviewReminderEmailSchedulable());
        Test.stopTest();

        // Integer invocations = Limits.getEmailInvocations();
        // System.assertEquals(1, invocations, 'We expected one email invocation.');
        System.assertNotEquals(null, jobId, 'We expected the jobId to NOT be null');
    }
}
