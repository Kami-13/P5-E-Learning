import { LightningElement, api, track, wire } from 'lwc';
import submitAnswer from '@salesforce/apex/UnitService.submitAnswer';

export default class QuestionCard extends LightningElement {

    @api unitId;
    @track question;
    @track answers = [];
    @track value = '';

    @wire(getQuestions, { unitId: '$unitId' })
    wiredQuestions({ error, data }) {

        if (data) {
            this.question = {
                Content__c: data.Content__c,
            }
        } else if (error) {
            
        }
    }

    handleClick() {

        const data = {
            unitId: this.unitId,
            questionId: this.question.Id,
            answerId: this.value
        };
        submitAnswer({unitId: this.unitId, data: JSON.stringify(data)})
            .then(result => {
                console.log(result);
            })
            .catch(error => {
                console.error(error);
            });
    }
    
}