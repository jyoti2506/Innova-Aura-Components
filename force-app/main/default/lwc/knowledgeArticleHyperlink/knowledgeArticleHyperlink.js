import { LightningElement,api } from 'lwc';
export default class KnowledgeArticleHyperlink extends LightningElement {

    baseUrl = '/Service/s/knowledge-article?recId=';

    @api articlerecord;

    handleClick(){
        //console.log('about to dispatch closearticles event');
        //const closeEvent = new CustomEvent('closearticles');
        //this.dispatchEvent(closeEvent);
    }

    get articleUrl(){
        return this.baseUrl + this.articlerecord.Id;
    }

}