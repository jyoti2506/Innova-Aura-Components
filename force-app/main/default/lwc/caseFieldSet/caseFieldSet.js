import { LightningElement, wire, track, api } from 'lwc';
import caseFieldSet from '@salesforce/apex/MyFieldSetApexClass.getCaseList';

export default class MyFielSetComponent extends LightningElement {
    @track cases;
    @track error;
    @api recordId;
    //@track parsedDescription; // Property to hold parsed description

    @wire(caseFieldSet, { caseid: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.cases = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.cases = undefined;
        }
    }

    
    
    
 
  
    
}