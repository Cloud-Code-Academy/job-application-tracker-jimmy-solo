public with sharing class JobApplicationTriggerHelper {
        
    public static void createTasksForSavedJobStatus(List<Job_Application__c> jobApplicationsInSavedStatusList){
        List<Task> taskList = new List<Task>();
        List<String> subjectList = new List<String>{
            'Check if the job description aligns with your interests and values',
            'Research the company’s mission and culture',
            'Prepare a tailored resume and cover letter'
        };

        for (Job_Application__c app : jobApplicationsInSavedStatusList) {
            if (app.Status__c == 'Saved') {
                for (String subject : subjectList) {
                    Task task = new Task(
                        Subject = subject,
                        OwnerId = app.OwnerId,
                        ActivityDate = Date.today().addDays(3),
                        WhatId = app.Id
                    );
                    taskList.add(task);
                }
            }
        }

        try {
            Database.insert(taskList, true);
        } catch (DmlException ex) {
            System.debug(ex);
        }
    }

    public static void createTasksForJobApplicationStatusUpdate(Map<Id, Job_Application__c> jobApplicationNewMap, List<String> subjectList){

        List<Task> taskList = new List<Task>();

        for (Job_Application__c app : jobApplicationNewMap.values()) {
            for (String subject : subjectList) {
                Task task = new Task(
                    Subject = subject,
                    OwnerId = app.OwnerId,
                    ActivityDate = Date.today().addDays(3),
                    WhatId = app.Id
                );
                taskList.add(task);
            }
        }
        try {
            Database.insert(taskList, true);
        } catch (DmlException ex) {
            System.debug(ex);
        }
    }

    public static void populatePrimaryContactIfNull(Map<Id, Job_Application__c> jobAppsWithNullPrimaryContactMap){
        List<Contact> contactList = [   SELECT Id, Job_Application__c
                                        FROM Contact 
                                        WHERE Job_Application__c IN :jobAppsWithNullPrimaryContactMap.keySet() ];
        
        for (Contact contact : contactList) {
            Job_Application__c jobApplication = jobAppsWithNullPrimaryContactMap.get(contact.Job_Application__c);
            if (jobApplication == null) {
                continue;
            }else {
                jobApplication.Primary_Contact__c = contact.Id;
                jobAppsWithNullPrimaryContactMap.remove(jobApplication.Id);
            }           
        }
    }
}