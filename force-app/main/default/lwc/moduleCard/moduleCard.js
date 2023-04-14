import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ModuleCard extends NavigationMixin(LightningElement) {

    @api module;
    @api relatedUnits = [];

    navigateToModuleView() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.module.Id,
                objectApiName: 'Module__c',
                actionName: 'view'
            }
        });
    }

    navigateToUnitView(recordId) {
        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Unit__c',
                actionName: 'view'
            }
        });
    }

}