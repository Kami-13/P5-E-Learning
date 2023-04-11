import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getTrailWrapper from '@salesforce/apex/UnitService.getTrailWrapper';

export default class TrailView extends LightningElement {

    trail;
    modules;

    @wire(CurrentPageReference) pageRef;

    @wire(getTrailWrapper, { trailId: '$pageRef.state.recordId' })
    wiredGetTrail({ data, error }) {

        if (data) {

            this.trail = {
                Name: data.Name,
                Total_Points__c: data.Total_Points__c,
                Description__c: data.Description__c,
                // Progress__c: data.Progress__c
            };

            this.modules = data.modules;

        } else if (error) {
            
        }
    }

}