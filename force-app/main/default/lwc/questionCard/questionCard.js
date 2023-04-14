import { LightningElement, api, track } from 'lwc';
import submitAnswer from '@salesforce/apex/UnitService.submitAnswer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const TILE_WRAPPER_SELECTED_CLASS = 'tile-wrapper selected custom-box slds-box slds-p-around_medium'
const TILE_WRAPPER_UNSELECTED_CLASS = 'tile-wrapper custom-box slds-box slds-p-around_medium'

export default class QuestionContent extends LightningElement {

    @api recordId;
    @api unit;
    @api wireQuestion;
    @api optionSelected;

    submitAnswersLenght = [];
    sentAnswers = {};
    @api selectedOption;
    @track previousOption;
    answerStyleId;

    handleClick(event) {

        const answerId = event.target.dataset.id;
        const questionId = event.target.dataset.qid;
        this.answerStyleId = event.target.dataset.id;

        if (this.sentAnswers.hasOwnProperty(questionId)) {

            delete this.sentAnswers[questionId];
        }
    
        this.sentAnswers[questionId] = answerId;
    
        this.optionSelected = answerId;

        this.submitAnswersLenght = Object.values(this.sentAnswers);
    }

    get tileClass() {
        if (this.selectedOption.includes(this.answerStyleId)) {
            return TILE_WRAPPER_SELECTED_CLASS
        } else {
            return TILE_WRAPPER_UNSELECTED_CLASS
        }
    }

    // get isOptionSelectedChanged() {

    //     if (this.selectedOption !== this.previousOption) {
    //         this.previousOption = this.selectedOption;
    //         if (this.selectedOption) {
    //             this.template.querySelector('.my-element').classList.add('selected');
    //         } else {
    //             this.template.querySelector('.my-element').classList.remove('selected');
    //         }
    //         return true;
    //     }
    //     return false;
    // }

    handleSubmit(){

        // console.log(JSON.stringify(this.sentAnswers));

        // console.log(this.submitAnswersLenght.length);
        // console.log(this.wireQuestion.length);

        if(this.submitAnswersLenght.length == this.wireQuestion.length){

            submitAnswer({unitId: this.unit.Id, answerJson: JSON.stringify(this.sentAnswers)})
            

            .then((status)=>{
                if(status == 'Success'){
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Congratulations!',
                        message: `You've succesfully completed {unit}.`,
                        variant: 'success'
                    }));
                }else{
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Oh, uh',
                        message: `There's at least one wrong question, try again.`,
                        variant: 'error'
                    }));
                }
            });

        }else{

            this.dispatchEvent(new ShowToastEvent({
                title: 'Try again',
                message: 'All questions must be answered before submitting.',
                variant: 'warning'
            }));
        }
    }

}