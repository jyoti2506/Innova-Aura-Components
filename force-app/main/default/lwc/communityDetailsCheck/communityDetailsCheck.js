import { LightningElement, track } from 'lwc';  
import fetchInfo from '@salesforce/apex/CommunityDetailsCheckController.fetchInfo';  
 
  
export default class CommunityDetailsCheck extends LightningElement {  
  
    @track error;   
    @track objUser;
    @track showModal = false; 
    @track region;
    @track brand; 
    @track timezone;
  
    connectedCallback() {    
    
        fetchInfo()      
        .then(result => {    
  
            this.objUser = result;    
                console.log('objUser: ' +result);

                // Both region, brand and timezone are present, no need to show the modal
                    if (this.objUser && this.objUser.Innova_Region__c && this.objUser.Innova_Brand__c && this.objUser.Time_Zone__c) {
                    return;
                }

             // Check if region,brand and timezone are blank
             if (this.isRegionBrandBlank()) {
                this.showModal = true;

            }

            else {
                // If not blank, pre-populate the fields
                this.region = this.objUser.Innova_Region__c || '';
                this.brand = this.objUser.Innova_Brand__c || '';
                this.timezone = this.objUser.Time_Zone__c || '';
            }

                    this.showModal=true;
        })    
        .catch(error => {    
  
            this.error = error;   
            console.error('Error fetching info:', error);
  
        });   
    
    } 
    
    isRegionBrandBlank() {
        // Check if region or brand is blank (empty or contains only whitespace)
        return (
            (!this.objUser.Innova_Region__c || /^\s*$/.test(this.objUser.Innova_Region__c)) ||
            (!this.objUser.Innova_Brand__c || /^\s*$/.test(this.objUser.Innova_Brand__c)) ||
            (!this.objUser.Time_Zone__c || /^\s*$/.test(this.objUser.Time_Zone__c))
        );
    }

    handleSuccess( ) { 
        this.showModal = false;  
    
    }   
  
    closeModal() {  
  
        this.showModal = false;  
  
    }   
  
}