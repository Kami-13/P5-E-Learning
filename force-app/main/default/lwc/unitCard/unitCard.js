import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class UnitCard extends NavigationMixin(LightningElement) {

    @api moduleId;
    @api unit;
        
    handleNavigateToUnit() {

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.unit.Id,
                objectApiName: 'Unit__c',
                actionName: 'view'
            }
        });
    }
    
}