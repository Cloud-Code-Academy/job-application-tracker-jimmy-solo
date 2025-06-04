public with sharing class JobApplicationTriggerHandler extends TriggerHandler {
    
    private Map<Id, Job_Application__c> jobApplicationNewMap;
    private Map<Id, Job_Application__c> jobApplicationOldMap;
    
    public JobApplicationTriggerHandler() {
        this.jobApplicationNewMap = (Map<Id, Job_Application__c>)Trigger.newMap;
        this.jobApplicationOldMap = (Map<Id, Job_Application__c>)Trigger.oldMap;
    }

    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void beforeDelete(){}
    @TestVisible
    protected virtual void afterInsert(){}
    @TestVisible
    protected virtual void afterUpdate(){}
    @TestVisible
    protected virtual void afterDelete(){}
    @TestVisible
    protected virtual void afterUndelete(){}
}