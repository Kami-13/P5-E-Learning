import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getTrailId from '@salesforce/apex/TrailWrapper.getTrailId';

export default class UnitCard extends NavigationMixin(LightningElement) {
  
    @api recordId;
    modules = [];
    currentModule;
    units = [];
    wrapper;
    //moduleProgress;
    moduleUrls;
    trailUrl;

    @wire(getTrailId, { moduleId: '$recordId' })
    wiredTrailId({ data, error }) {

        if (data) {

            this.wrapper = data;

            this.modules = data.modules;

            this.currentModule = this.modules.find(module => module.Id === this.recordId);

            console.log(this.currentModule);

            this.units = data.units;

            //this.moduleProgress = this.currentModule.Module_Progresses__r.Progress__c;

        } else if (error) {

            console.log(error);
        }


    }


}