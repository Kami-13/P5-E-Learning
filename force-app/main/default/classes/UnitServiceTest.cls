@IsTest
public class UnitServiceTest {
    
    @IsTest
    static void testSubmitAnswer() {
        
        // Crear un nuevo usuario
        User usuarioPrueba = new User(
            FirstName = 'Pepe',
            LastName = 'Pompin',
            Email = 'pepetest@test.com',
            Alias = 'pepito',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'es',
            LocaleSidKey = 'es_AR',
            TimeZoneSidKey = 'America/Argentina/Buenos_Aires',
            Username = 'pepetesting@test.com'
            
         );
        insert usuarioPrueba;
        
        // Crear un nuevo módulo
        Module__c moduloPrueba = new Module__c(
            Name = 'Módulo de prueba'
        );
        insert moduloPrueba;
        
        // Crear una nueva unidad
        Unit__c unidadPrueba = new Unit__c(
            Name = 'Unidad de prueba', 
            Module__c = moduloPrueba.Id, 
            Total_Points__c = 400
        );
        insert unidadPrueba;
        
        // Configurar los datos de prueba
        Module_Progress__c progresoModulo = new Module_Progress__c(
            User__r = usuarioPrueba, // Usar User__r en lugar de User__c
            Module__r = moduloPrueba, // Usar Module__r en lugar de Module__c
            Name = 'Progreso del módulo de prueba'
        );
        insert progresoModulo;
        
        Unit_Progress__c unidadProgresoPrueba = new Unit_Progress__c(
            Unit__c = unidadPrueba.Id,
            Module_Progress__c = progresoModulo.Id // Usar la ID del registro de progreso del módulo insertado
        );
        insert unidadProgresoPrueba;
        
        Map<String, Object> respuestasPrueba = new Map<String, Object>{
            'pregunta1' => 'opcion1',
            'pregunta2' => 'opcion2',
            'pregunta3' => 'opcion3'
        };
        
        // Llamar al método submitAnswer
        Test.startTest();
        UnitService.submitAnswer(unidadPrueba.Id, JSON.serialize(respuestasPrueba));
        Test.stopTest();
        
        // Verificar que el registro de progreso de la unidad se actualizó correctamente
        Unit_Progress__c unidadProgresoActualizada = [SELECT Id, Status__c, Unit_Attempts__c FROM Unit_Progress__c WHERE Id = :unidadProgresoPrueba.Id];
        System.assertEquals('Answered', unidadProgresoActualizada.Status__c);
        System.assertEquals(1, unidadProgresoActualizada.Unit_Attempts__c);
        
        // Verificar que se crearon registros de respuesta de usuario
        List<User_Answer__c> respuestasUsuario = [SELECT Id, Question__c, Answer__c, Unit_Progress__c FROM User_Answer__c WHERE Unit_Progress__c = :unidadProgresoPrueba.Id];
        System.assertEquals(3, respuestasUsuario.size());
        System.assertEquals('opcion1', respuestasUsuario[0].Answer__c);
        System.assertEquals('opcion2', respuestasUsuario[1].Answer__c);
        System.assertEquals('opcion3', respuestasUsuario[2].Answer__c);
    }
}