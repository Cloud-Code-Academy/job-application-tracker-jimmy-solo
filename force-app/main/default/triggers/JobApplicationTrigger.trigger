trigger JobApplicationTrigger on Job_Application__c (after insert, before update) {

    //Creating a new instance of our job application trigger handler and calling run.
    new JobApplicationTriggerHandler().run();
}