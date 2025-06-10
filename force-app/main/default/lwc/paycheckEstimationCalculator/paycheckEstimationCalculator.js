import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import SALARY_FIELD from '@salesforce/schema/Job_Application__c.Salary__c';

export default class PaycheckEstimationCalculator extends LightningElement {

    @api recordId;

    @wire(getRecord, {recordId: '$recordId', fields: [SALARY_FIELD]})
    jobApplication;

    get salary() {
        return this.jobApplication?.data?.fields?.Salary__c?.value;
    }

    

}