import { LightningElement, api, wire } from 'lwc';
import getUnitWrapper from '@salesforce/apex/UnitWrapper.getUnitWrapper';
import { NavigationMixin } from 'lightning/navigation';

export default class UnitCard extends NavigationMixin(LightningElement) {
    
  @api unit;
  @api moduleId;

  module;
  units;

  @wire(getUnitWrapper, {unitId: '$unit.Id'})
  wiredWrapper({ error, data }) {
    if (data) {
      this.module ={
        Name: data.Name,
        Total_Points__c: data.Total_Points__c,
        Description__c: data.Description__c,
        unitUrl: `/lightning/r/Unit__c/${this.unitId}/view`,
      }
    } else if (error) {
      console.error(error);
    }
  }

  get units() {
    return this.wrapper ? this.wrapper.units : [];
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
    }).then(() => {
        const clickedUnit = this.units.find(unit => unit.Id === unitId);
        this.lastVisitedUnit = clickedUnit;
    }).catch(error => {
        console.error(error);
    });

    const lastVisitedUnitCard = this.template.querySelector('c-unit-card');
    if (lastVisitedUnitCard) {
        lastVisitedUnitCard.updateUnit(this.lastVisitedUnit);
    }
  }

  //logica para traer TODOS los modulos


}