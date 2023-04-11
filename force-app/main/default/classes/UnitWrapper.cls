public class UnitWrapper {
    public Unit__c unit;
    public List<QuestionWrapper> questions;

    public UnitWrapper(Id unitId) {
        // Query the Unit record and populate the unit field
        unit = [SELECT Id, Name, Content__c, Total_Points__c, Estimated_Time__c, Module__c
                FROM Unit__c
                WHERE Id = :unitId];
        
        // Query the related questions and options and populate the questions field
        List<Question__c> unitQuestions = [SELECT Id, Name, Content__c, Unit__c
                                           FROM Question__c
                                           WHERE Unit__c = :unitId];
        questions = new List<QuestionWrapper>();
        for (Question__c q : unitQuestions) {
            questions.add(new QuestionWrapper(q.Id));
        }
    }

    public class QuestionWrapper {
        public Question__c question;
        public List<Answer__c> options;
        public String userAnswer;

        public QuestionWrapper(Id questionId) {
            // Query the Question record and populate the question field
            question = [SELECT Id, Name, Content__c, Unit__c FROM Question__c WHERE Id = :questionId];
            
            // Query the related options and populate the options field
            options = [SELECT Id, Name, Content__c, Correct_Answer__c FROM Answer__c WHERE Question__c = :questionId];
        }
    }
}