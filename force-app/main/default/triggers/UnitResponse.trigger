trigger UnitResponse on Unit_Progress__c (after update) {
    
    // Create a set of Unit Progress IDs being updated
    Set<Id> UnitProgressIds = new Set<Id>();
    for (Unit_Progress__c unitProgress : Trigger.new) {
        if (unitProgress.Status__c == 'Answered' && Trigger.oldMap.get(unitProgress.Id).Status__c != 'Answered') {
            UnitProgressIds.add(unitProgress.Id);
        }
    }
    
    if (UnitProgressIds.size() > 0) {
        
        // Query user answers related to the updated Unit Progress records
        List<Unit_Progress__c> unitProgressRecords = [
            SELECT Id, Status__c, Unit__r.Total_Points__c, (SELECT Id, Answer__r.Correct_Answer__c FROM User_Answers__r)
            FROM Unit_Progress__c 
            WHERE Id IN :UnitProgressIds
        ];

        // Check if all questions associated with each updated Unit Progress record have correct answers
        List<Unit_Progress__c> updatedUnitProgressRecords = new List<Unit_Progress__c>();
        
        for (Unit_Progress__c unitProgressRecord : unitProgressRecords) {   
            Boolean allAnswersCorrect = true;
            for (User_Answer__c userAnswer : unitProgressRecord.User_Answers__r) {              
                if (!userAnswer.Answer__r.Correct_Answer__c) {
                    allAnswersCorrect = false;
                    break;
                }
            }
            
            // Set the Unit Progress status to Success or Fail depending on their answers.
            if (allAnswersCorrect) {
                unitProgressRecord.Status__c = 'Success';
                
                // Calculate the points earned based on the number of attempts
                Integer attempts = Integer.valueOf(unitProgressRecord.Unit_Attempts__c);
                Decimal pointsEarned;
                if (attempts == 1) {
                    pointsEarned = unitProgressRecord.Unit__r.Total_Points__c;
                } else if (attempts == 2) {
                    pointsEarned = unitProgressRecord.Unit__r.Total_Points__c * 0.5;
                } else {
                    pointsEarned = unitProgressRecord.Unit__r.Total_Points__c * 0.25;
                }
                unitProgressRecord.Points_Obtained__c = pointsEarned;
                
            } else {
                unitProgressRecord.Status__c = 'Fail';
                unitProgressRecord.Points_Obtained__c = 0;
            }
            
            updatedUnitProgressRecords.add(unitProgressRecord);
        }
            
        update updatedUnitProgressRecords;
    }
}