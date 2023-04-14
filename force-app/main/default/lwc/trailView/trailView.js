import { LightningElement, wire, api } from 'lwc';
import getTrailWrapper from '@salesforce/apex/UnitService.getTrailWrapper';

export default class TrailView extends LightningElement {

    @api recordId;
    trail;
    modules = [];
    units = [];
    moduleSingular;
    progressTrail;

    @wire(getTrailWrapper, { trailId: '$recordId' })
    wiredGetTrail({ data, error }) {

        if (data) {

            this.trail = data.trail;

            this.modules = data.modules;

            this.units = data.units;

            console.log(this.units);

            this.progressTrail = data.progressTrail;

        } else if (error) {
            console.log('Estoy en el error' + error);
        }

        if(this.modules.size == 1){
            this.moduleSingular = true;
        }

    }

}