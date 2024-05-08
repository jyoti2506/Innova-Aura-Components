import { LightningElement, track } from 'lwc';

export default class MyComponentName extends LightningElement {
    @track
    myBreadcrumbs = [
        { label: 'Case', name: 'objectName', id: 'case1' },
        { label: 'Record Name', name: 'record', id: 'Case2' },
    ];

    handleNavigateTo(event) {
        //get the name of the breadcrumb that's clicked
        const name = event.target.name;
        event.preventDefault();
        //your custom navigation here
    }
}