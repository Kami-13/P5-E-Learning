trigger UnitResponse on Unit_Progress__c (before update, before insert) {
    
    // Create a map of Unit Progress IDs being updated/inserted with their associated User Answers
    Map<Id, List<User_Answer__c>> unitProgressWithUserAnswersMap = new Map<Id, List<User_Answer__c>>();
    for (Unit_Progress__c unitProgress : Trigger.new) {
        if (unitProgress.Status__c == 'Answered' && Trigger.oldMap.get(unitProgress.Id).Status__c != 'Answered') {
            unitProgressWithUserAnswersMap.put(unitProgress.Id, unitProgress.User_Answers__r);
        }
    }
    
    if (unitProgressWithUserAnswersMap.size() > 0) {
        
        // Query Units related to the updated/inserted Unit Progress records
        Map<Id, Unit__c> unitsMap = new Map<Id, Unit__c>([
            SELECT Id, Total_Points__c
            FROM Unit__c
            WHERE Id IN (SELECT Unit__c FROM Unit_Progress__c WHERE Id IN :unitProgressWithUserAnswersMap.keySet())
        ]);

        // Iterate through the Unit Progress records and check if all associated User Answers have correct answers
        for (Unit_Progress__c unitProgressRecord : Trigger.new) {
            if (unitProgressWithUserAnswersMap.containsKey(unitProgressRecord.Id)) {
                List<User_Answer__c> userAnswers = unitProgressWithUserAnswersMap.get(unitProgressRecord.Id);
                Boolean allAnswersCorrect = true;
                for (User_Answer__c userAnswer : userAnswers) {              
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
                    Integer pointsEarned;
                    if (attempts == 1) {
                        pointsEarned = Integer.valueOf(unitsMap.get(unitProgressRecord.Unit__c).Total_Points__c);
                    } else if (attempts == 2) {
                        pointsEarned = Integer.valueOf(unitsMap.get(unitProgressRecord.Unit__c).Total_Points__c * 0.5);
                    } else if(attempts >= 3){
                        pointsEarned = Integer.valueOf(unitsMap.get(unitProgressRecord.Unit__c).Total_Points__c * 0.25);
                    }
                    unitProgressRecord.Points_Obtained__c = pointsEarned;
                    
                } else {
                    unitProgressRecord.Status__c = 'Fail';
                    unitProgressRecord.Points_Obtained__c = 0;
                    
                }
                if (unitProgressRecord.Status__c == 'Fail') {
                    unitProgressRecord.Status__c = 'Draft';                
                }  
            }
        }
    }
}