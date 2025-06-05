public with sharing class JobApplicationTriggerHandler extends TriggerHandler {
    
    private Map<Id, Job_Application__c> jobApplicationNewMap;
    private Map<Id, Job_Application__c> jobApplicationOldMap;
    private Id ownerId;
    
    public JobApplicationTriggerHandler() {
        this.jobApplicationNewMap = (Map<Id, Job_Application__c>)Trigger.newMap;
        this.jobApplicationOldMap = (Map<Id, Job_Application__c>)Trigger.oldMap;
    }

    @TestVisible
    public override void afterInsert(){
        for (Job_Application__c jobApp : this.jobApplicationNewMap.values()) {
            if (jobApp.Status__c == 'Saved') {
                JobApplicationTriggerHelper.createTasksForSavedJobStatus(this.jobApplicationNewMap);
            }
        }
    }
}