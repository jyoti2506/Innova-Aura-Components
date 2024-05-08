import { LightningElement, wire } from 'lwc';
import getTrendingArticles from '@salesforce/apex/KnowledgeTopicController.getTrendingArticles';
import { NavigationMixin } from 'lightning/navigation';

export default class TrendingArticles extends NavigationMixin(LightningElement) {

    articles;

    @wire(getTrendingArticles) trendingArticles({ error, data }) {
        if (data) {
            console.log('data: ', data);
            this.articles = data; 
        } else if (error) {
            this.error = error; // Handle errors gracefully
        }
    }

    navigateToArticle(event) {
        
        const recId = event.currentTarget.dataset.recid;
        console.dir('kb recId: ', recId);

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Knowledge_Article__c', // Your Experience Cloud page API name
            },
            state: {
                recId: recId, 
            }
        });
    }
}