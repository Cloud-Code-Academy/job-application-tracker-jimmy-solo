
@isTest
private class JobApplicationRecordCleanup_Test {

    @TestSetup
    static void createJobApplicationRecordsOlderThan30Days(){
        
        List<Job_Application__c> jobApplicationList = new List<Job_Application__c>();
        for (Integer i = 0; i < 50; i++) {
            Job_Application__c jobApplication = new Job_Application__c(
                Company_Name__c = 'Test Company ' + i,
                Salary__c = 125000,
                Position_Title__c = 'Salesforce Developer/Architect',
                Rating__c = '4',
                Location__c = 'Remote',
                Status__c = 'Applying'
            );
            jobApplicationList.add(jobApplication);
        }
        insert jobApplicationList;

        DateTime manufacturedCreatedDate = DateTime.now().addDays(-40);
        for (Job_Application__c jobApp : jobApplicationList) {
            Test.setCreatedDate(jobApp.Id, manufacturedCreatedDate);
            System.debug(jobApp.CreatedDate);
        }
    }
    
    @isTest
    static void scheduleJobApplicationRecordCleanup_ExpectDeleteOfRecordsOlderThan30Days() {
        Test.startTest();
            String cronExp = '0 0 12 * * ?'; // Daily at noon
            String jobId = System.schedule('Jooble Job Cleanup', cronExp, new JobApplicationRecordCleanupSchedulable());
        Test.stopTest();

        List<Job_Application__c> cleanedUpJobApplicationList = [ SELECT Id, Status__c, Notes__c FROM Job_Application__c ];
        for (Job_Application__c jobApplication : cleanedUpJobApplicationList) {
            Assert.areEqual('This job application was closed by an automated process due to being created more than 30 days ago and not having a status of either Closed or Accepted.', jobApplication.Notes__c);
        }
    }
}