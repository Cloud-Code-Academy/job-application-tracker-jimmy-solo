@IsTest
public with sharing class JobApplicationTriggerHelper_Test {

    @IsTest 
    public static void createTasksForSavedJobStatus_ThreeTasksShouldBeCreated(){

        List<Job_Application__c> jobApplicationList = new List<Job_Application__c>();
        Job_Application__c jobApplicationWithSavedStatus = new Job_Application__c(
            Status__c = 'Saved',
            Company_Name__c = 'Salesforce',
            URL__c = 'salesforce.com'
        );
        jobApplicationList.add(jobApplicationWithSavedStatus);

        Job_Application__c jobApplicationWithOutSavedStatus = new Job_Application__c(
            Status__c = 'Applying',
            Company_Name__c = 'Google',
            URL__c = 'google.com'
        );
        jobApplicationList.add(jobApplicationWithOutSavedStatus);

        Test.startTest();
            Database.insert(jobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingThreeItems = [ SELECT Id FROM Task ];
        List<Job_Application__c> jobApplicationListExpectingTwoItems = [ SELECT Id, Status__c FROM Job_Application__c];
        Assert.areEqual(3, taskListExpectingThreeItems.size(), 'We expected 3 tasks to be creatd during a job application insert with status = saved');
        Assert.areEqual(2, jobApplicationListExpectingTwoItems.size(), 'We expected 2 job application records to be present');
    }
}