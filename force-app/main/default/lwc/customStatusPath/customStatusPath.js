import { LightningElement, api, wire } from 'lwc';
import getChangeRequestStatusPath from '@salesforce/apex/PathController.getChangeRequestStatusPath';
import { getRecordIdFromURL } from 'c/utility'; // Assume this is a utility to parse URL parameters
export default class PathComponent extends LightningElement {
    @api recordId;
    statusPath;
    currentStep;

    // Example steps
    steps = [
        { label: 'New', value: 'New' },
        { label: 'Submitted for approval', value: 'Submitted for approval' },
        { label: 'Approved', value: 'Approved' },
        { label: 'Rejected', value: 'Rejected' },
        { label: 'Canceled', value: 'Canceled' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'Live', value: 'Live' }
    ];

    connectedCallback() {
        this.recordId = this.recordId || getRecordIdFromURL();

        getChangeRequestStatusPath({ changeRequestId: this.recordId })
            .then(result => {
                this.statusPath = result;
                // Determine the current step based on the statusPath
                this.currentStep = this.determineCurrentStep(result);
            })
            .catch(error => {
                console.error('Error fetching change request status path:', error);
            });
    }

    determineCurrentStep(statusPath) {
        // Example conversion of statusPath to step value
        switch(statusPath) {
            case 'New':
                return 'New';
            case 'Submitted for approval':
                return 'Submitted for approval';
            case 'Approved':
                return 'Approved';
            case 'Rejected':
                return 'Rejected';
            case 'Canceled':
                return 'Canceled';
            case 'Scheduled':
                return 'Scheduled';
            case 'Live':
                return 'Live';
            default:
                return ''; // Default to the first step or an empty value if not found
        }
    }
}