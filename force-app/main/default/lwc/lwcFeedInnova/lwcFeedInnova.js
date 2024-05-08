import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FeedComponent extends LightningElement {
  @api recordId; // Optional: Record ID for filtering feed items
  feedItems = [];
  error = null;

  handleNewPostClick() {
    // Handle new post logic (likely open a modal or navigate)
    console.log('New post button clicked');
  }

  connectedCallback() {
    this.fetchFeedItems();
  }

  async fetchFeedItems() {
    try {
      const data = await // Replace with your Apex call to fetch feed items
      this.feedItems = data.map((item) => ({
        userPicUrl: item.UserPicUrl, // Map data to component format
        userName: item.UserName,
        formattedTime: item.FormattedTime,
        body: item.Body,
      }));
    } catch (error) {
      this.error = error.message;
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error Fetching Feed',
          message: error.message,
          variant: 'error',
        })
      );
    }
  }
}