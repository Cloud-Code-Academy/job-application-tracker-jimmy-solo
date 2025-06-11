@IsTest
public with sharing class JobApplicationTriggerHelper_Test {
    @TestSetup
    static void makeJobApplicationData(){
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

        Database.insert(jobApplicationList);
    }
    
    @IsTest 
    public static void createTasksForSavedJobStatus_ThreeTasksShouldBeCreated(){

        List<Task> taskListExpectingThreeItems = [ SELECT Id FROM Task ];
        List<Job_Application__c> jobApplicationListExpectingTwoItems = [ SELECT Id, Status__c FROM Job_Application__c];

        Assert.areEqual(3, taskListExpectingThreeItems.size(), 'We expected 3 tasks to be creatd during a job application insert with status = saved');
        Assert.areEqual(2, jobApplicationListExpectingTwoItems.size(), 'We expected 2 job application records to be present');
    }

    @IsTest 
    public static void createTasksForApplyingJobStatus_ExpectEightTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Applying';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingEightItems = [ SELECT Id FROM Task ];
        Assert.areEqual(8, taskListExpectingEightItems.size(), 'We expected 8 total tasks to be created during a job application update to a status of Applying');
            
    }

    @IsTest 
    public static void createTasksForAppliedJobStatus_ExpectSevenTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Applied';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingSevenItems = [ SELECT Id FROM Task ];
        Assert.areEqual(7, taskListExpectingSevenItems.size(), 'We expected 7 total tasks to be created during a job application update to a status of Applied');
            
    }

    @IsTest 
    public static void createTasksForInterviewingJobStatus_ExpectEightTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Interviewing';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingEightItems = [ SELECT Id FROM Task ];
        Assert.areEqual(8, taskListExpectingEightItems.size(), 'We expected 8 total tasks to be created during a job application update to a status of Interviewing');
            
    }

    @IsTest 
    public static void createTasksForNegotiatingJobStatus_ExpectSixTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Negotiating';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingSixItems = [ SELECT Id FROM Task ];
        Assert.areEqual(6, taskListExpectingSixItems.size(), 'We expected 6 total tasks to be created during a job application update to a status of Negotiating');
    }

    @IsTest 
    public static void createTasksForAcceptedJobStatus_ExpectSixTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Accepted';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingSixItems = [ SELECT Id FROM Task ];
        Assert.areEqual(6, taskListExpectingSixItems.size(), 'We expected 6 total tasks to be created during a job application update to a status of Accepted');
    }

    @IsTest 
    public static void createTasksForClosedJobStatus_ExpectFiveTotalTasksToBeCreated(){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Company_Name__c 
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Salesforce'];

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        
        for (Job_Application__c jobApplication : jobApplicationList) {
            jobApplication.Status__c = 'Closed';

            updatedJobApplicationList.add(jobApplication);
        }

        Test.startTest();
            Database.update(updatedJobApplicationList);
        Test.stopTest();

        List<Task> taskListExpectingSixItems = [ SELECT Id FROM Task ];
        Assert.areEqual(5, taskListExpectingSixItems.size(), 'We expected 5 total tasks to be created during a job application update to a status of Accepted');
    }

    @IsTest 
    public static void populatePrimaryContactOnJobApplicationWhenNull_ExpectToPopulateWithAnyRelatedContact(){
        
        Job_Application__c testJobApp1 = new Job_Application__c(
            Name = 'Test Job Application 1'
        );
        Database.insert(testJobApp1);
        
        Contact testContact1 = new Contact(
            FirstName = 'Jonny',
            LastName = 'Jonnison',
            Job_Application__c = testJobApp1.Id
        );
        Database.insert(testContact1);

        Test.startTest();
            testJobApp1.Location__c = 'Remote';
            Database.update(testJobApp1);
        Test.stopTest();

        List<Job_Application__c> jobApplicationAssertionList = [ SELECT Id, Name, Primary_Contact__c 
                                                                    FROM Job_Application__c 
                                                                    WHERE Name = 'Test Job Application 1' ];
        Assert.isNotNull(jobApplicationAssertionList[0].Primary_Contact__c, 'We expect the Primary Contact field to be populated with a related contact, if available.');
    }
}