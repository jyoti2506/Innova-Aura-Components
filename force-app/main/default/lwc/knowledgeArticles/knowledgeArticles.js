import { LightningElement, wire, track } from 'lwc';
import getArticles from '@salesforce/apex/KnowledgeTopicController.getArticles';
 
// Import message service features required for subscribing and the message channel
import { subscribe, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

 
export default class KnowledgeArticles extends LightningElement {
 
    kbArticles;
    error;
 
    //show hide knowledge articles
    //showArticles = true;

    //handleCloseArticles() {
    //    console.log('hide articles');
        //this.showArticles = false;
    //}

    subscription = null;
    @track categoryName;
    

    @wire(MessageContext)
    messageContext;



     

    // Handler for message received by component
    handleMessage(message) {
        console.log('attempting to handle message from subscription.');
        this.categoryName = message.categoryName;
        console.log('topic/category received from subscription: ', this.categoryName);
        //console.log('showArticles: ' + this.showArticles);
        //this.showArticles = true;
    }
 
    // Standard lifecycle hooks used to sub/unsub to message channel
    connectedCallback() {
        console.log('--knowledgeArticles connectedCallback - START');
      
        this.subscription = subscribe(
            this.messageContext,
            RECORD_SELECTED_CHANNEL,
            (message) => {
                this.handleMessage(message);
                console.log('message received at knowledgeArticles: ', message);
            },{
                onError: (error) => {
                    console.error('error during subscription: ', error);
                }
            }
        );

        
        
        console.log('--knowledgeArticles connectedCallback - END');
    }
 
    @wire(getArticles, { categoryName: '$categoryName' }) 
    wiredArticles({ error, data }) {
        if (data) {
            this.kbArticles = data; 
            console.log('set this.kbArticles');
            console.log('the article data: ', data);
        } else if (error) {
            console.error('Error fetching kb articles for topic:', error);
            this.error = error; 
            this.kbArticles = undefined; // Reset in case there was previous data
        }
    }
 
}