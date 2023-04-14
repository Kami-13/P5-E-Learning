public with sharing class UnitService {
    
    @AuraEnabled(cacheable= false)  
    public static void submitAnswer(Id unitId, String answerJson) {
        // Get the current user
        Id userId = UserInfo.getUserId();
               
        // Get the corresponding Unit Progress record for the user and unit
        List<Unit_Progress__c> unitProgressRecords = [SELECT Id, Status__c, Unit_Attempts__c, Module_Progress__r.Status__c, Unit__r.Module__c FROM Unit_Progress__c WHERE Module_Progress__r.User__c = :userId AND Unit__c = :unitId];
        
        Unit_Progress__c unitProgress = null;
        Module_Progress__c moduleProgress = null;
        List<User_Answer__c> userAnswersToUpsert = new List<User_Answer__c>();
        
        if (unitProgressRecords.size() == 0) {
            // Create new Unit Progress record and Module Progress record if they don't exist yet
            List<Unit__c> relatedUnits = [SELECT Name, Module__c, Module__r.Name FROM Unit__c WHERE Id = :unitId LIMIT 1];
            if (relatedUnits.size() > 0) {
                Unit__c relatedUnit = relatedUnits[0];
                moduleProgress = [SELECT Id FROM Module_Progress__c WHERE Module__c = :relatedUnit.Module__c AND User__c = :userId LIMIT 1];
                if (moduleProgress == null) {
                    moduleProgress = new Module_Progress__c(
                        Name = relatedUnit.Module__r.Name,
                        User__c = userId,
                        Module__c = relatedUnit.Module__c,
                        Status__c = 'In Progress'
                    );
                    insert moduleProgress;
                }
                unitProgress = new Unit_Progress__c(
                    Name = relatedUnit.Name,
                    User__c = userId,
                    Completed__c = false,
                    Points_Obtained__c = 0,            
                    Unit__c = unitId,
                    Status__c = 'Draft',
                    Unit_Attempts__c = 1,
                    Module_Progress__c = moduleProgress.Id
                );
                insert unitProgress;
            }
        } else {
            // Update existing Unit Progress record
            unitProgress = unitProgressRecords[0];
            unitProgress.Unit_Attempts__c ++;
            unitProgress.Status__c = 'Draft';
            update unitProgress;
            // Delete existing User Answer records
            List<User_Answer__c> existingUserAnswers = [SELECT Id FROM User_Answer__c WHERE Unit_Progress__c = :unitProgress.Id];
            delete existingUserAnswers;
        }
                     
        // Parse answer JSON and create new User Answer records
        Map<Id, Id> answerMap = (Map<Id, Id>)JSON.deserializeStrict(answerJson, Map<Id, Id>.class);  
        for (String questionId : answerMap.keySet()) {
            User_Answer__c userAnswer = new User_Answer__c(
                Question__c = questionId,
                Answer__c = answerMap.get(questionId),
                Unit_Progress__c = unitProgress.Id
            );
            userAnswersToUpsert.add(userAnswer);
        }
        upsert userAnswersToUpsert;
        
        // Update Unit Progress record status to "Answered"
        if (unitProgress != null) {
            unitProgress.Status__c = 'Answered';
            update unitProgress;
        }
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