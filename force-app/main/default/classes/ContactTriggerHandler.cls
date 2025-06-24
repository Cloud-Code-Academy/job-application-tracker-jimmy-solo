public with sharing class ContactTriggerHandler extends TriggerHandler {
    
    private Map<Id,Contact> contactNewMap;
    private Map<Id,Contact> contactOldMap;
    
    public ContactTriggerHandler() {
        this.contactNewMap = (Map<Id,Contact>)Trigger.newMap;
        this.contactOldMap = (Map<Id,Contact>)Trigger.oldMap;
    }
    
    @TestVisible
    public override void afterInsert(){

        Map<String,Contact> jobApplicationIdToContactRecordMap = setPrimaryContactOnJobApplicationRecord();
        if (!jobApplicationIdToContactRecordMap.isEmpty()) {
            ContactTriggerHelper.evaluteAndUpdatePrimaryContactOnJobApplicationRecord(jobApplicationIdToContactRecordMap);
        }
    }

    //:::::::::::::::::::::::::::Orchestration Methods:::::::::::::::::::::::::::::::::::://
    
    private Map<String,Contact> setPrimaryContactOnJobApplicationRecord(){
        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();
        Map<String,Contact> jobApplicationIdToContactRecordMap = new Map<String,Contact>();

        //Create a map of all contacts in Trigger.new that have a populated Job_Application__c field. 
        for (Contact con : this.contactNewMap.values()) {
            if (con.Job_Application__c != null) {
                //Building a map with Job_Application__c values in the keySet.
                jobApplicationIdToContactRecordMap.put(con.Job_Application__c, con);
            }
        }
        return jobApplicationIdToContactRecordMap;
    }
}