public without sharing class JobApplicationRecordCleanupSchedulable implements Schedulable {

    public void execute(SchedulableContext sc){
        //Establishing our cutoff date for record cleanup.
        Datetime thirtyDaysAgo = Datetime.now().addDays(-1);

        //Query job application records older than 30 days.
        List<Job_Application__c> expiredJobApplicationsList = queryJobApplicationsOlderThan30Days(thirtyDaysAgo);

        if (!expiredJobApplicationsList.isEmpty()) {
            try {
                Database.delete(expiredJobApplicationsList);
            } catch (DmlException ex) {
                System.debug('DML Exception Caught: ' + ex.getMessage());
            }
        }else {
            System.debug('No old job application records to delete.');
        }
    }

    private List<Job_Application__c> queryJobApplicationsOlderThan30Days(DateTime thirtyDaysAgo){
        
        if (Schema.SObjectType.Job_Application__c.isAccessible()) {
            List<Job_Application__c> jobAppList = [ SELECT Id, CreatedDate 
                                                FROM Job_Application__c
                                                WHERE CreatedDate > :thirtyDaysAgo];

            return jobAppList;
        }else {
            System.debug('User does not have read access to Job Applications.');
            return new List<Job_Application__c>();
        }
    }
} 