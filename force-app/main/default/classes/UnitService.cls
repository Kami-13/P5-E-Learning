public class UnitService {
    
    @AuraEnabled(cacheable = true)
    public static void submitAnswer(String unitId, String answerJson) {
        
        // Get the current user
        Id userId = UserInfo.getUserId();
        
        // Get the corresponding Unit Progress record for the user and unit
        Unit_Progress__c unitProgress = [SELECT Id, Status__c, Unit_Attempts__c, Module_Progress__r.Status__c FROM Unit_Progress__c WHERE Module_Progress__r.User__c = :userId AND Unit__c = :unitId];
        
        // Set the Unit Progress status to 'Draft' and increment the number of attempts
        // CONSULTAR SOBRE MODIFICAR CODIGO PARA DML BULK
        unitProgress.Status__c = 'Draft';
        unitProgress.Unit_Attempts__c++;
        
        // If this is the first unit being answered for the module, create a new Module Progress record for the user and module
        if (unitProgress.Module_Progress__r.Status__c != 'In Progress' && unitProgress.Module_Progress__r.Status__c != 'Completed') {
            Module_Progress__c moduleProgress = new Module_Progress__c();
            moduleProgress.User__c = userId;
            moduleProgress.Module__c = unitProgress.Unit__r.Module__c;
            moduleProgress.Status__c = 'In Progress';
            insert moduleProgress;
        }
        
        // Create new User Answer records for each question answered with the selected option
        Map<String, Object> answerMap = (Map<String, Object>) JSON.deserializeUntyped(answerJson);
        List<User_Answer__c> userAnswers = new List<User_Answer__c>();
        for (String questionId : answerMap.keySet()) {
            User_Answer__c userAnswer = new User_Answer__c();
            userAnswer.Question__c = questionId;
            userAnswer.Answer__c = (String) answerMap.get(questionId);
            userAnswer.Unit_Progress__c = unitProgress.Id;
            userAnswers.add(userAnswer);
        }
        insert userAnswers;
        
        // Set the Unit Progress status to 'Answered'
        unitProgress.Status__c = 'Answered';
        update unitProgress;
    }
       
    @AuraEnabled(cacheable = true)
    public static TrailWrapper getTrailWrapper(Id trailId) {
        TrailWrapper tw = new TrailWrapper(trailId);
        return tw;
    }
    
    @AuraEnabled(cacheable = true)
    public static UnitWrapper getUnitWrapper(Id unitId) {  
        UnitWrapper uw = new UnitWrapper(unitId);
        return uw;
    }
    
}