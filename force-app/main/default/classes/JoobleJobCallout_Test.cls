@IsTest
public with sharing class JoobleJobCallout_Test {
    @isTest
    static void testJoobleJobCalloutFromSchedulableToQueueableToBatchable() {
        // Set the mock response
        Test.setMock(HttpCalloutMock.class, new JoobleCalloutMock());

        Test.startTest();
            System.enqueueJob(new JoobleJobCalloutQueueable());
        Test.stopTest();

        List<Job_Application__c> mockJobApplicationList = [ SELECT Id, Company_Name__c, Company_Location__c, Salary__c, Position_Title__c
                                                            FROM Job_Application__c 
                                                            WHERE Company_Name__c = 'Tech Co'];
        
        Assert.areEqual(1, mockJobApplicationList.size());
        Assert.areEqual(mockJobApplicationList[0].Company_Name__c, 'Tech Co', 'Expected Tech Co as the company name.');
        Assert.areEqual(mockJobApplicationList[0].Company_Location__c, 'Boulder, CO', 'Expected Boulder CO as the location.');
        Assert.areEqual(mockJobApplicationList[0].Salary__c, 100000, 'Expected 100000 as the salary.');
        Assert.areEqual(mockJobApplicationList[0].Position_Title__c, 'Salesforce Developer', 'Expected Salesforce Developer as the position title.');
    }
}