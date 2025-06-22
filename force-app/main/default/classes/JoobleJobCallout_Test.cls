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
        
        Assert.areEqual(mockJobApplicationList.size(), 1);
        Assert.areEqual(mockJobApplicationList[0].Company_Name__c, 'Tech Co');
        Assert.areEqual(mockJobApplicationList[0].Company_Location__c, 'Boulder, CO');
        Assert.areEqual(mockJobApplicationList[0].Salary__c, 100000);
        Assert.areEqual(mockJobApplicationList[0].Position_Title__c, 'Salesforce Developer');
    }
}