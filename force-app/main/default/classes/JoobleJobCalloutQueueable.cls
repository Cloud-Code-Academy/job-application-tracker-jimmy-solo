public without sharing class JoobleJobCalloutQueueable implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext qc){
        
        try {
            HttpRequest request = new HttpRequest();

            //Retrieve our Jooble API Key for our callouts.
            Jooble_API_Credential__mdt joobleAPIKey = [ SELECT Jooble_API_Key__c 
                                                        FROM Jooble_API_Credential__mdt 
                                                        WHERE DeveloperName = 'Jooble_API_Credential_Capstone_Project'];

            request.setEndpoint('https://jooble.org/api/' + joobleAPIKey.Jooble_API_Key__c);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            //Here we're building our search parameters to pass as part of our POST request.
            Map<String, String> requestBodyMap = new Map<String, String>();
            requestBodyMap.put('keywords', 'Salesforce Developer');
            requestBodyMap.put('location', 'Boulder, Colorado');
            request.setBody(JSON.serialize(requestBodyMap));

            //Here we're sending our HTTP request.
            Http http = new Http();
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                if (result.containsKey('jobs') && result.get('jobs') != null) {
                    List<Object> jobResultList = (List<Object>) result.get('jobs');

                    //Prepare a clean list and instantiate a new job application record to capture returned field values.
                    List<Job_Application__c> cleanJobApplicationList = new List<Job_Application__c>();
                    for(Object returnedJob : jobResultList) {
                        Job_Application__c jobApplicationRecord = new Job_Application__c();

                        Map<String, Object> jobMap = (Map<String, Object>) returnedJob;
                        jobApplicationRecord.Name = 'Job App ' + '- ' + (String)jobMap.get('company') + '- ' + Datetime.now().format('MM d, yyyy');
                        jobApplicationRecord.Position_Title__c = (String)jobMap.get('title');
                        jobApplicationRecord.Description__c = (String)jobMap.get('snippet');

                        //Here we're stripping non-numeric values and then casting to a decimal.
                        String rawSalary = (String) jobMap.get('salary');
                        if (rawSalary != null && rawSalary != '') {
                            // Remove non-numeric characters like $, commas, etc.
                            rawSalary = rawSalary.replaceAll('[^\\d.]', '');
                            if (rawSalary != '') {
                                try {
                                    jobApplicationRecord.Salary__c = Decimal.valueOf(rawSalary);
                                } catch (Exception e) {
                                    System.debug('Could not convert salary to decimal: ' + jobApplicationRecord);
                                }
                            }
                        }
                        jobApplicationRecord.URL__c = (String)jobMap.get('link');
                        jobApplicationRecord.Company_Name__c = (String)jobMap.get('company');
                        jobApplicationRecord.Company_Location__c = (String)jobMap.get('location');
                        jobApplicationRecord.Jooble_External_Id__c = String.valueOf(jobMap.get('id'));
                        jobApplicationRecord.Status__c = 'Saved';

                        if (!checkIfJobApplicationIsADuplicate(jobApplicationRecord)) {
                            cleanJobApplicationList.add(jobApplicationRecord);
                        }
                    }
                    //Creating a new instance of our batchable class to chunk the insert transactions in groups of 200.
                    Database.executeBatch(new JoobleJobCalloutBatchable(cleanJobApplicationList), 200);
                    

                } else {
                    System.debug('No jobs key found in response.');
                }
            } else {
                System.debug('Callout failed with status: ' + response.getStatus());
            }
        }catch (exception e) {
            System.debug('Exception during callout: ' + e.getMessage());
        }
    }

    public Boolean checkIfJobApplicationIsADuplicate(Job_Application__c jobApplication){
        List<Job_Application__c> jobApplicationList = [ SELECT Id, Jooble_External_Id__c 
                                                        FROM Job_Application__c
                                                        WHERE Jooble_External_Id__c = :jobApplication.Jooble_External_Id__c ];

        return jobApplicationList.isEmpty() ? false : true;
    }
}