public with sharing class JoobleJobCalloutQueueable implements Queueable {

    public void execute(QueueableContext qc){
        
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://jooble.org/api/43df291b-956f-48de-86f9-fa8d7f78d359');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            Map<String, String> requestBodyMap = new Map<String, String>();
            requestBodyMap.put('keywords', 'Salesforce Developer');
            requestBodyMap.put('location', 'Boulder, Colorado');
            request.setBody(JSON.serialize(requestBodyMap));

            Http http = new Http();
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                if (result.containsKey('jobs') && result.get('jobs') != null) {
                    List<Object> jobResultList = (List<Object>) result.get('jobs');

                    //Prepare a clean list and instantiate a new job application record to capture returned field values.
                    List<Job_Application__c> cleanJobApplicationList = new List<Job_Application__c>();
                    Job_Application__c jobApplicationRecord = new Job_Application__c();

                    for(Object returnedJob : jobResultList) {
                        Map<String, Object> jobMap = (Map<String, Object>) returnedJob;
                        jobApplicationRecord.Position_Title__c = (String)jobMap.get('title');
                        jobApplicationRecord.Location__c = (String)jobMap.get('location');
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
                                    System.debug('Could not convert salary to decimal: ' + rawSalary);
                                }
                            }
                        }
                        jobApplicationRecord.URL__c = (String)jobMap.get('link');
                        jobApplicationRecord.Company_Name__c = (String)jobMap.get('company');
                        jobApplicationRecord.Location__c = (String)jobMap.get('location');
                        jobApplicationRecord.Jooble_External_Id__c = (String)jobMap.get('id');

                        cleanJobApplicationList.add(jobApplicationRecord);
                    }
                    //Creating a new instance of our batchable class to chunk the insert transactions in groups of 200.
                    Database.executeBatch(new JoobleJobCalloutBatchable(cleanJobApplicationList), 200);
                    System.debug(JSON.serializePretty(cleanJobApplicationList));

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
}