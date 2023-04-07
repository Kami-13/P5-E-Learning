public class DummyData {

    public static void createExampleData() {
        // Create example Trail
        Trail__c dummyTrail = new Trail__c(Name='Salesforce Trail', Description__c='This is an example trail.');
        insert dummyTrail;
        
        // Create example Modules
        Module__c dummyModule1 = new Module__c(Name='Salesforce Basics', Type__c='Modulo', Description__c='Learn the basics of Salesforce', Skills__c='Salesforce Administration', Roles__c = 'Admin', Badge__c = false, Is_Active__C= false);
        Module__c dummyModule2 = new Module__c(Name='Salesforce Advanced', Type__c='Proyecto', Description__c='Learn advanced topics in Salesforce', Skills__c='Salesforce Development', Roles__C='Admin',Badge__c = false, Is_Active__C= false);
        insert new List<Module__c>{dummyModule1, dummyModule2};
        
        // Create example Units
        Unit__c dummyUnit1 = new Unit__c(Module__c=dummyModule1.Id, Name='Getting Started', Time__c=30, Total_Points__c=50, Content__c='This unit covers the basics of Salesforce');
        Unit__c dummyUnit2 = new Unit__c(Module__c=dummyModule1.Id, Name='Data Management', Time__c=60, Total_Points__c=100, Content__c='This unit covers data management in Salesforce');
        Unit__c dummyUnit3 = new Unit__c(Module__c=dummyModule2.Id, Name='Apex Programming', Time__c=90, Total_Points__c=200, Content__c='This unit covers Apex programming in Salesforce');
        insert new List<Unit__c>{dummyUnit1, dummyUnit2, dummyUnit3};
        
        // Create example Questions
        Question__c dummyQuestion1 = new Question__c(Name='Salesforce Basics Question 1', Unit__c=dummyUnit1.Id, Content__c='What is Salesforce?');
        Question__c dummyQuestion2 = new Question__c(Name='Salesforce Basics Question 2', Unit__c=dummyUnit2.Id, Content__c='What are the benefits of using Salesforce?');
        Question__c dummyQuestion3 = new Question__c(Name='Data Management Question 1', Unit__c=dummyUnit3.Id, Content__c='What is data import wizard in Salesforce?');
        insert new List<Question__c>{dummyQuestion1, dummyQuestion2, dummyQuestion3};
        
       // Create example Answers
        Answer__c dummyAnswer1 = new Answer__c(Name='Salesforce Basics Answer 1', Question__c=dummyQuestion1.Id, Content__c='Salesforce is a cloud-based CRM platform.');
        Answer__c dummyAnswer2 = new Answer__c(Name='Salesforce Basics Answer 2', Question__c=dummyQuestion1.Id, Content__c='Salesforce is a cloud-based CRM platform that offers a range of features and capabilities to help businesses manage their customer relationships.');
        Answer__c dummyAnswer3 = new Answer__c(Name='Salesforce Basics Answer 3', Question__c=dummyQuestion1.Id, Content__c='Salesforce is a cloud-based CRM platform designed to help businesses manage their customer relationships and streamline their sales processes.');
        dummyAnswer1.Correct_Answer__c = true;
        dummyAnswer2.Correct_Answer__c = false;
        dummyAnswer3.Correct_Answer__c = false;
        insert new List<Answer__c>{dummyAnswer1, dummyAnswer2, dummyAnswer3};
        
        Answer__c dummyAnswer4 = new Answer__c(Name='Salesforce Basics Answer 4', Question__c=dummyQuestion2.Id, Content__c='Benefits of Salesforce include improved customer relationships, increased productivity, and streamlined sales processes.');
        Answer__c dummyAnswer5 = new Answer__c(Name='Salesforce Basics Answer 5', Question__c=dummyQuestion2.Id, Content__c='Salesforce offers a range of features and capabilities to help businesses manage their customer relationships, including sales automation, marketing automation, and customer service automation.');
        Answer__c dummyAnswer6 = new Answer__c(Name='Salesforce Basics Answer 6', Question__c=dummyQuestion2.Id, Content__c='Salesforce helps businesses improve their customer relationships by providing a central location for customer data and by automating key sales and marketing processes.');
        dummyAnswer4.Correct_Answer__c = false;
        dummyAnswer5.Correct_Answer__c = true;
        dummyAnswer6.Correct_Answer__c = false;
        insert new List<Answer__c>{dummyAnswer4, dummyAnswer5, dummyAnswer6};
        
        Answer__c dummyAnswer7 = new Answer__c(Name='Data Management Answer 1', Question__c=dummyQuestion3.Id, Content__c='Data import wizard is a tool that allows users to import data into Salesforce from external sources.');
        Answer__c dummyAnswer8 = new Answer__c(Name='Data Management Answer 2', Question__c=dummyQuestion3.Id, Content__c='Data import wizard is a tool that allows users to export data from Salesforce to external sources.');
        Answer__c dummyAnswer9 = new Answer__c(Name='Data Management Answer 3', Question__c=dummyQuestion3.Id, Content__c='Data import wizard is a tool that allows users to delete data from Salesforce.');
        dummyAnswer7.Correct_Answer__c = true;
        dummyAnswer8.Correct_Answer__c = false;
        dummyAnswer9.Correct_Answer__c = false;
        insert new List<Answer__c>{dummyAnswer7, dummyAnswer8, dummyAnswer9};
		
       
	}
}


/* // Set the correct answer for each question
        dummyAnswer1.Correct_Answer__c = true;
        dummyAnswer4.Correct_Answer__c = true;
        dummyAnswer7.Correct_Answer__c = true;
        
        // Insert the new answers
        insert new List<Answer__c>{dummyAnswer1, dummyAnswer2, dummyAnswer3, dummyAnswer4, dummyAnswer5, dummyAnswer6, dummyAnswer7, dummyAnswer8, dummyAnswer9};*/