import { LightningElement, wire, api } from 'lwc';
import getModulesByTrailId from '@salesforce/apex/MyController.getModulesByTrailId';

export default class ModuleCard extends LightningElement {

    @api trailId;
    modules;

    @wire(getModulesByTrailId, { trailId: '$trail.Id' })
    getModules({data, error}) {
        this.modules = result;

        if (data) {
            this.modules = {
                Name: data.Name,
                Total_Points__c: data.Total_Points__c,
                Description__c: data.Description__c,
                Estimated_Time__c: data.Estimated_Time__c,
                Skills__c: data.Skills__c
                // Progress__c: data.Progress__c
            };
        } else if (error) {
            console.error(result.error);
        }
    }

    toggleSection(event) {
        let buttonid = event.currentTarget.dataset.buttonid;
        let currentsection = this.template.querySelector('[data-id="' + buttonid + '"]');
        if (currentsection.className.search('slds-is-open') == -1) {
            currentsection.className = 'slds-section slds-is-open';
        } else {
            currentsection.className = 'slds-section slds-is-close';
        }
    }

}