public with sharing class ContactTriggerHelper {

    public static void evaluteAndUpdatePrimaryContactOnJobApplicationRecord(Map<String,Contact> jobApplicationIdToContactRecordMap){

        List<Job_Application__c> updatedJobApplicationList = new List<Job_Application__c>();

        //Get all the job applications records that have an id in the above listed map's keySet.
        Map<Id,Job_Application__c> jobApplicationMap = new Map<Id,Job_Application__c>(
            [ SELECT Id, Primary_Contact__c FROM Job_Application__c WHERE Id IN :jobApplicationIdToContactRecordMap.keySet() ]
        );

        for (Contact con : jobApplicationIdToContactRecordMap.values()) {
            Job_Application__c jobApp = jobApplicationMap.get(con.Job_Application__c);

            if (jobApp.Primary_Contact__c == null) {
                jobApp.Primary_Contact__c = con.Id;

                updatedJobApplicationList.add(jobApp);
            }
        }
        if (!updatedJobApplicationList.isEmpty()) {
            try {
                Database.update(updatedJobApplicationList);
            } catch (DmlException ex) {
                System.System.debug(ex);
            }
        }
    }
}