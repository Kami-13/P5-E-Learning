public class UnitWrapper {

    @AuraEnabled
    public Unit__c unit;
    @AuraEnabled
    public List<Question__c> questions = new List<Question__c>();

    public UnitWrapper(Id unitId) {

        unit = [SELECT Id, Name, Content__c, Total_Points__c, Estimated_Time__c, Module__c
                FROM Unit__c
                WHERE Id = :unitId];
        
        this.unit = unit;

        List<Question__c> questions = [SELECT Id, Name, Content__c, Unit__c, (SELECT Id, Content__c, Correct_Answer__c FROM Answers__r)
                                           FROM Question__c
                                           WHERE Unit__c = :unitId];

        this.questions = questions;

    //     for (Question__c question : unitQuestions) {
    //         questionMap(question.Id);
    //     }

    // }

    // public Map<String, List<String>> questionMap(Id questionId){

    //     Map<String, List<String>> questionMap = new Map<String, List<String>>();

    //     // Query the Question record and add the question to the map
    //     Question__c question = [SELECT Id, Name, Content__c, Unit__c 
    //                             FROM Question__c 
    //                             WHERE Id = :questionId];

    //     questionMap.put(question.Content__c, new List<String>());

    //     // Query the related options and add them to the question's list of options
    //     List<Answer__c> options = [SELECT Id, Name, Content__c, Correct_Answer__c 
    //                                FROM Answer__c 
    //                                WHERE Question__r.Id = :questionId];

    //     for (Answer__c option : options) {
    //         questionMap.get(question.Content__c).add(option.Content__c);
    //     }

    //     this.questions = questionMap;

    //     return questionMap;
    } 

}