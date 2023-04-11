import { LightningElement, wire, api } from 'lwc';
import getTrail from '@salesforce/apex/MyController.getTrails';

export default class UnitView extends LightningElement {

    @api unit;
    questions;

    @wire(getTrail, { unitId: '$unitdId' })
    wiredGetTrail({ error, data }) {
        if (data) {

            this.unit = {
                Name: data.Name,
                Total_Points__c: data.Total_Points__c,
                Description__c: data.Description__c,
            };

            this.questions = data.Question__r;

        } else if (error) {
            
        }
    }

}
