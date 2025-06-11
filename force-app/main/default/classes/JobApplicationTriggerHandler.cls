public with sharing class JobApplicationTriggerHandler extends TriggerHandler {
    
    private Map<Id, Job_Application__c> jobApplicationNewMap;
    private Map<Id, Job_Application__c> jobApplicationOldMap;
    private Id ownerId;

    List<String> applyingSubjectList = new List<String>{
            'Find and research someone who works at the company and add them as a contact',
            'Set up an informational interview to learn more about the role/company',
            'Identify potential referrals to help get your application on the top of the pile',
            'Customize your work achievements using the job description keywords',
            'Submit your application on the company website if possible'
        };

    List<String> appliedSubjectList = new List<String>{
            'Reach out to the hiring manager or recruiter',
            'Follow up on your application via email weekly',
            'Continue identifying and saving similar job opportunities',
            'Set up weekly networking calls to explore similar companies/roles'
    };

    List<String> interviewingSubjectList = new List<String>{
            'Prepare your blurb or \"tell me about yourself\" response',
            'Practice answering behavioral interview questions',
            'Research the company and your interviewers',
            'Set up your virtual interview space and test your tech',
            'Send thank you emails within 24 hours'
    };
    List<String> negotiatingSubjectList = new List<String>{
            'Research your market value and know your numbers',
            'Prepare your negotiation scripts',
            'Evaluate your offer and decline or accept'
    };
    List<String> acceptedSubjectList = new List<String>{
            'Plan your resignation if applicable',
            'Take some time to relax and recharge',
            'Prepare for your first day of onboarding'
    };
    List<String> closedSubjectList = new List<String>{
            'Send a follow-up email thanking the interviewer and asking for feedback',
            'Review your notes and reflect on areas of improvement'
    };
    
    public JobApplicationTriggerHandler() {
        this.jobApplicationNewMap = (Map<Id, Job_Application__c>)Trigger.newMap;
        this.jobApplicationOldMap = (Map<Id, Job_Application__c>)Trigger.oldMap;
    }

    @TestVisible
    public override void afterInsert(){
        List<Job_Application__c> savedJobApps = new List<Job_Application__c>();
        for (Job_Application__c jobApp : this.jobApplicationNewMap.values()) {
            if (jobApp.Status__c == 'Saved') {
                savedJobApps.add(jobApp);
            }
        }
        JobApplicationTriggerHelper.createTasksForSavedJobStatus(savedJobApps);
    }

    @TestVisible
    public override void beforeUpdate(){
        for (Job_Application__c jobApp : this.jobApplicationNewMap.values()) {
            Job_Application__c oldJobApplication = this.jobApplicationOldMap.get(jobApp.Id);

            if (jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Applying') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, applyingSubjectList);
            }else if(jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Applied') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, appliedSubjectList);
            }else if(jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Interviewing') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, interviewingSubjectList);
            }else if(jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Negotiating') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, negotiatingSubjectList);
            }else if(jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Accepted') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, acceptedSubjectList);
            }else if(jobApp.Status__c != oldJobApplication.Status__c && jobApp.Status__c == 'Closed') {
                JobApplicationTriggerHelper.createTasksForJobApplicationStatusUpdate(this.jobApplicationNewMap, closedSubjectList);
            }else {
                continue;
            }
        }
        evaluatePrimaryContactValue();
    }

    private void evaluatePrimaryContactValue(){
        Map<Id, Job_Application__c> jobAppsWithNullPrimaryContactMap = new Map<Id, Job_Application__c>();
        for (Job_Application__c jobApp : this.jobApplicationNewMap.values()) {
            if (jobApp.Primary_Contact__c == null) {
                jobAppsWithNullPrimaryContactMap.put(jobApp.Id, jobApp);
            }
        }
        JobApplicationTriggerHelper.populatePrimaryContactIfNull(jobAppsWithNullPrimaryContactMap);
    }
}