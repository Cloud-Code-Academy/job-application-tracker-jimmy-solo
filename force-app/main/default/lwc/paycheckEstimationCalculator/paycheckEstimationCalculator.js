import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import SALARY_FIELD from '@salesforce/schema/Job_Application__c.Salary__c';

const SOCIAL_SECURITY_RATE = 0.062;
const MEDICARE_TAX_RATE = 0.0145;

export default class PaycheckEstimationCalculator extends LightningElement {

    @api recordId;
    userInputSalary;

    @wire(getRecord, {recordId: '$recordId', fields: [SALARY_FIELD]})
    jobApplication({ error, data }) {
        if (data && !this.userInputSalary) {
            this.userInputSalary = data.fields.Salary__c.value;
        } else if (error) {
            console.error('Error loading Job Application record:', error);
        }
    }

    get salary() {
        return this.userInputSalary || 0;
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

    get biweeklyEstimatedPaycheck(){
        return this.yearlyEstimatedPaycheck / 26;
    }

    get weeklyEstimatedPaycheck(){
        return this.yearlyEstimatedPaycheck / 52;
    }

    get sixMonthEstimatedPaycheck(){
        return this.yearlyEstimatedPaycheck / 2;
    }

    get formattedYearlyEstimatedSalary(){
        return '$' + new Intl.NumberFormat('en-US').format(this.salary - this.totalTaxLiability);
    }

    get totalTaxLiability(){
        return (this.salary * this.federalTaxRateDecimal) + (this.salary * SOCIAL_SECURITY_RATE) + (this.salary * MEDICARE_TAX_RATE);
    }
    
    //::::::::::::::::::END OF Calculating Values:::::::::::::::::::::://


    //::::::::::::::::::START OF Formatting Values:::::::::::::::::::::://
    get formattedMonthlySalaryValue() {
        return this.formatCurrency(this.monthlyEstimatedPaycheck);
    }

    get formattedYearlyEstimatedSalary() {
        return this.formatCurrency(this.yearlyEstimatedPaycheck);
    }

    get formattedBiWeeklyEstimatedSalary() {
        return this.formatCurrency(this.biweeklyEstimatedPaycheck);
    }

    get formattedweeklyEstimatedSalary() {
        return this.formatCurrency(this.weeklyEstimatedPaycheck);
    }

    get formattedSixMonthEstimatedSalary() {
        return this.formatCurrency(this.sixMonthEstimatedPaycheck);
    }

    get formattedYearlyMedicareLiability() {
        return this.formatCurrency(this.salary * MEDICARE_TAX_RATE);
    }

    get formattedYearlyFederalTaxLiability() {
        return this.formatCurrency(this.salary * this.federalTaxRateDecimal);
    }

    get formattedYearlySSLiability() {
        return this.formatCurrency(this.salary * SOCIAL_SECURITY_RATE);
    }

    get userInputSalaryFormatted() {
        return this.userInputSalary ? this.userInputSalary.toString() : '';
    }

    formatCurrency(amount) {
        return '$' + new Intl.NumberFormat('en-US', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(amount);
    }
    //::::::::::::::::::END OF Formatting Values:::::::::::::::::::::://


    //::::::::::::::::::START OF OnChange Events:::::::::::::::::::::://

    handleSalaryChange(event) {
        const rawValue = event.target.value;
        const numericValue = parseFloat(rawValue.replace(/[^0-9.-]+/g, '')); // Strip currency formatting
        this.userInputSalary = isNaN(numericValue) ? 0 : numericValue;
    }
    //::::::::::::::::::End OF OnChange Events:::::::::::::::::::::://
}