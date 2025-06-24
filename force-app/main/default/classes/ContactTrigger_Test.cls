
@isTest
private class ContactTrigger_Test {

    @isTest
    public static void myUnitTest() {
        // Create a job application with a blank primary contact.
        Job_Application__c jobApplication = new Job_Application__c(
            Company_Name__c = 'Testing Company',
            Salary__c = 140000,
            Position_Title__c = 'Salesforce Senior Developer'
        );
        Database.insert(jobApplication);

        // Create a contact and set the Job_Application__c to the previously created job application record.
        Contact con = new Contact(
            FirstName = 'FirstName',
            LastName = 'LastName',
            Title = 'CEO',
            Job_Application__c = jobApplication.Id
        );
        Database.insert(con);

        // Assert that the job application Primary_Contact__c field will be set to the previously created contact.
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Status__c, Salary__c, Primary_Contact__c, Company_Name__c
                                                        FROM Job_Application__c 
                                                        WHERE Company_Name__c = 'Testing Company' ];

        List<Contact> contactList = [ SELECT Id 
                                        FROM Contact
                                        WHERE FirstName = 'FirstName' AND LastName = 'LastName'];

        Assert.areEqual(jobApplicationList[0].Primary_Contact__c, contactList[0].Id, 'We expected the Primary Contact to be Test Contact');
    }
}