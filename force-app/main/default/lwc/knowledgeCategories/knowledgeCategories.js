import { LightningElement, wire } from 'lwc';
import getTopics from '@salesforce/apex/KnowledgeTopicController.getTopics';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
//import { NavigationMixin } from 'lightning/navigation'; 

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

export default class KnowledgeCategories extends NavigationMixin(LightningElement) {

    topics; // Declare the topics variable
    error;  // Declare an error variable to store potential errors

    @wire(CurrentPageReference)
    pageRef;


subscription = null;

    @wire(MessageContext)
    messageContext;

    selectedTopic;
    payload;
    
    published = false;

    publishToChannel(category){
        console.log('--knowledgeCategories - publishToChannel');
   
        if(category){
            console.log('category is not blank.  publish to channel.');

            const payload = { categoryName: category };
            console.log('payload: ', payload);

            publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);

        } else{
            console.log('category IS BLANK.  DO NOT publish to channel');
        } 

    }

connectedCallback(){
    console.log('--knowledgeCategories connectedCallback - START');
    
    const state = this.pageRef.state;
    const category = state.category;
    const recId = state.recId;
    
    console.log('category state: ', state);
    console.log('category in state: ' + category);
    console.log('category recId: ' + recId);
    
    console.log('category url: ', this.pageRef);

    if(category){
        console.log('category found in url.  Publish.');

        //fix for second click after redirect.
        //wait a few milliseconds to ensure knowledgeArticles is subscribing to channel before we puslish.
        setTimeout(() => {
            this.publishToChannel(category);
        }, 500);

        
    } else if(category === undefined && recId === undefined) {
        console.log('initial knowledge articles click.');
        
        setTimeout(() => {
            this.publishToChannel('Trending');
        }, 500);
    }
    else{
        console.log('category and state not found in url.  Do not publish.');
    }
    
    console.log('--knowledgeCategories connectedCallback - END');
    console.log('----');
}

    handleSelect(event) {

        console.log('--knowledgeCategories - handleNavSelect.');

        this.performBehavior(event);
        
        console.log('exit handleNavSelect');
 
    }

    performBehavior(event){

        const url = this.pageRef ? window.location.href : '';

        console.log('url: ' + url);

        const pageName = 'knowledge-details';

         
        if(url.lastIndexOf(pageName) > 0 ){   
            this.behavior1(event);      // on knowledge-details page
        } else{
            this.behavior2(event);      // NOT on knowledge-details page,
        }

    }


    behavior1(event){

        console.log('result: behavior 1 - no redirect.');

        const category = event.detail.name;
        console.log('selected topic to publish: ' + category);

        if(category){
            this.publishToChannel(category);
        } else{
            console.log('error while selecting category.');
        }
        //const payload = { categoryName: selectedTopic };
        //publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
        //console.log('-published!');

    }

    behavior2(event){
        console.log('result: behavior 2 - redirect.');   

        const category = event.detail.name;
        console.log('selected category for url param: ', category);

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Knowledge_Details__c',
            },
            state: {
                category: category,  
            }
        });
    }

    @wire(getTopics, { }) 
    wiredTopics({ error, data }) {
        if (data) {
            console.log('returned categories: ',data);
            this.topics = data; 
            
        } else if (error) {
            console.error('Error fetching Topics:', error);
            // Consider displaying an error message to the user here
            this.error = error; 
            this.topics = undefined; // Reset in case there was previous data
        }
    }
}