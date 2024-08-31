import { LightningElement } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class MyComponent extends NavigationMixin(LightningElement) {
  navigateToRecord(recordId) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId,
        actionName: "view",
      },
    });
  }

  handleStatusChange(event) {
    if (event.detail.status === "FINISHED") {
      const outputVariables = event.detail.outputVariables;
      for (let i = 0; i < outputVariables.length; i++) {
        const outputVar = outputVariables[i];
        if (outputVar.name === "redirect") {
          this.navigateToRecord(outputVar.value);
        }
      }
    }
  }
}