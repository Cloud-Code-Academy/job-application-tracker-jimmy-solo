public with sharing class JobApplicationTriggerHelper {
        
    public static void createTasksForSavedJobStatus(Map<Id,Job_Application__c> jobApplicationNewMap){
        List<Task> taskList = new List<Task>();
        List<String> subjectList = new List<String>{
            'Check if the job description aligns with your interests and values',
            'Research the company’s mission and culture',
            'Prepare a tailored resume and cover letter'
        };

        for (Job_Application__c app : jobApplicationNewMap.values()) {
            if (app.Status__c == 'Saved') {
                for (String subject : subjectList) {
                    Task task = new Task(
                        Subject = subject,
                        OwnerId = app.Owner.Id,
                        ActivityDate = Date.today().addDays(3),
                        WhatId = app.Id
                    );
                    taskList.add(task);
                }
            }
        }

        try {
            Database.insert(taskList, true);
        } catch (Exception ex) {
            System.debug(ex);
        }

    }
}