public with sharing class JoobleJobCalloutBatchable implements Database.Batchable<Job_Application__c> {

    private List<Job_Application__c> jobList;

    public JoobleJobCalloutBatchable(List<Job_Application__c> jobList){
        this.jobList = jobList;
    }

    public Iterable<Job_Application__c> start(Database.BatchableContext bc) {
        return this.jobList;
    }

    public void execute(Database.BatchableContext bc, List<Job_Application__c> scope) {
        //Here we're inserting our job application records we built in our Queueable class.
        insert scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Finished batch processing:::: ' + bc);
    }
}