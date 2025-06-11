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
    get federalTaxRateDecimal(){
        if (this.salary > 197300){
            return 0.32
        }else if (this.salary > 103350){
            return 0.24;
        }else if (this.salary > 48475){
            return 0.22;
        }else if (this.salary > 11925){
            return 0.12;
        }else if (this.salary > 0) {
            return 0.10;
        }else{
            return 0.00;
        }
    }
    get federalTaxRatePercent(){
        return (this.federalTaxRateDecimal * 100).toFixed(0) + '%';
    }
    get yearlyEstimatedPaycheck(){
        return this.salary - (this.salary * this.federalTaxRateDecimal);
    }
    get monthlyEstimatedPaycheck(){
        return this.yearlyEstimatedPaycheck / 12;
    }
    get formattedMonthlySalaryValue() {
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.monthlyEstimatedPaycheck);
    }
    get formattedSalaryAmount(){
        return '$' + new Intl.NumberFormat('en-US').format(this.salary);
    }
    get formattedYearlyEstimatedSalary(){
        return '$' + new Intl.NumberFormat('en-US').format(this.salary - (this.salary * this.federalTaxRateDecimal));
    }
}