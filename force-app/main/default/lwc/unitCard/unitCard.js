import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class UnitCard extends NavigationMixin(LightningElement) {

    @api moduleId;
    units;

    @wire(getUnitsByModuleId, { moduleId: '$module.Id' })
    getModules({data, error}) {
        this.units = result;

        if (data) {
            this.units = {
                Name: data.Name,
                Total_Points__c: data.Total_Points__c,
                Description__c: data.Description__c,
                Estimated_Time__c: data.Estimated_Time__c,
                Skills__c: data.Skills__c,
                unitUrl: `/lightning/r/Unit__c/${this.unitId}/view`,
                // Progress__c: data.Progress__c
            };
        } else if (error) {
            console.error(result.error);
        }
    }

    handleNavigateToUnit(event) {

    const unitId = event.currentTarget.dataset.unitId;
    
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: unitId,
                objectApiName: 'Unit__c',
                actionName: 'view'
            }
        })
    }
    
}