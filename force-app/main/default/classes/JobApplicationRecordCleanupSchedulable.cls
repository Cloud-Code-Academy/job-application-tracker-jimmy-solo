public without sharing class JobApplicationRecordCleanupSchedulable implements Schedulable {

    public void execute(SchedulableContext sc){
        //Establishing our cutoff date for record cleanup.
        Datetime thirtyDaysAgo = Datetime.now().addDays(-30);

        //Query job application records older than 30 days.
        List<Job_Application__c> expiredJobApplicationsList = queryJobApplicationsOlderThan30Days(thirtyDaysAgo);

        if (!expiredJobApplicationsList.isEmpty()) {
            try {
                Database.update(expiredJobApplicationsList, true);
            } catch (DmlException ex) {
                System.debug('DML Exception Caught: ' + ex.getMessage());
            }
        }else {
            System.debug('No old job application records to delete.');
        }
    }

    private List<Job_Application__c> queryJobApplicationsOlderThan30Days(DateTime thirtyDaysAgo){
        
        if (Schema.SObjectType.Job_Application__c.isAccessible()) {
            List<Job_Application__c> jobAppList = [ SELECT Id, CreatedDate, Status__c, Notes__c 
                                                    FROM Job_Application__c
                                                    WHERE CreatedDate <= :thirtyDaysAgo AND Status__c NOT IN ('Closed', 'Accepted') ];

            if(!jobAppList.isEmpty()){
                for (Job_Application__c jobApp : jobAppList){
                    jobApp.Notes__c = 'This job application was closed by an automated process due to being created more than 30 days ago and not having a status of either Closed or Accepted.';
                    jobApp.Status__c = 'Closed';
                }
            return jobAppList;
            }else {
                System.debug('The job application list is empty following the SOQL query.');
                return new List<Job_Application__c>();
            }
        }else {
            System.debug('User does not have read access to Job Applications.');
            return new List<Job_Application__c>();
        }
    }
} 