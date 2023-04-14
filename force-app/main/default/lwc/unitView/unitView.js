import { LightningElement, wire, api } from 'lwc';
import getUnitWrapper from '@salesforce/apex/UnitService.getUnitWrapper';

export default class UnitView extends LightningElement {

    @api recordId;
    unit;
    questions = [];

    @wire(getUnitWrapper, { unitId: '$recordId' })
    wiredGetUnit({ error, data }) {

        console.log(this.recordId);

        if (data) {

            this.unit = data.unit;

            this.questions = data.questions;

            console.log('aca abajo se supone que hay preguntas y respuestas');
            console.log(this.questions);

        } else if (error) {
            
        }
    }

}
