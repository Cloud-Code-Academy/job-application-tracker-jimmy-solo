import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import SALARY_FIELD from '@salesforce/schema/Job_Application__c.Salary__c';

const SOCIAL_SECURITY_RATE = 0.062;
const MEDICARE_TAX_RATE = 0.0145;

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
    //::::::::::::::::::START OF Calculating Values:::::::::::::::::::::://
    get yearlyEstimatedPaycheck(){
        return this.salary - this.totalTaxLiability;
    }
    get monthlyEstimatedPaycheck(){
        return this.yearlyEstimatedPaycheck / 12;
    }
    get formattedYearlyEstimatedSalary(){
        return '$' + new Intl.NumberFormat('en-US').format(this.salary - (this.salary * this.federalTaxRateDecimal));
    }
    get totalTaxLiability(){
        return (this.salary * this.federalTaxRateDecimal) + (this.salary * SOCIAL_SECURITY_RATE) + (this.salary * MEDICARE_TAX_RATE);
    }
    //::::::::::::::::::END OF Calculating Values:::::::::::::::::::::://


    //::::::::::::::::::START OF Formatting Values:::::::::::::::::::::://
    get formattedMonthlySalaryValue() {
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.monthlyEstimatedPaycheck);
    }
    get formattedYearlyMedicareLiability(){
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.salary * MEDICARE_TAX_RATE);
    }
    get formattedYearlyFederalTaxLiability(){
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.salary * this.federalTaxRateDecimal);
    }
    get formattedYearlySSLiability(){
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(this.salary * SOCIAL_SECURITY_RATE);
    }
    get formattedSalaryAmount(){
        return '$' + new Intl.NumberFormat('en-US').format(this.salary);
    }
    //::::::::::::::::::END OF Formatting Values:::::::::::::::::::::://
}