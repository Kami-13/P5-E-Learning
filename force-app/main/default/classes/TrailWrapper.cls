public class TrailWrapper {
    
    @AuraEnabled
    public Trail__c trail;
    @AuraEnabled
    public Integer progressTrail;
    @AuraEnabled
    public List<Module__c> modules = new List<Module__c>();
    @AuraEnabled
    public List<Unit__c> units = new List<Unit__c>();
    @AuraEnabled
    public Map<Id, Boolean> completedModuleMap = new Map<Id, Boolean>();
    @AuraEnabled
    public Map<Id, Boolean> completedUnitMap = new Map<Id, Boolean>();
    
    public TrailWrapper(Id trailId) {
        
        
        Id userId = UserInfo.getUserId();
   
        trail = [SELECT Id, Name, Description__c, Total_Points__c, Total_Time__c 
                          FROM Trail__c 
                          WHERE Id = :trailId];
        
        this.trail = trail;
      

        List<Module__c> modules = [SELECT Id, Name, Description__c, Total_Points__c, Total_Time__c, Skills__c,
                                   (SELECT Status__c, Progress__c FROM Module_Progresses__r WHERE User__c = :userId LIMIT 1)
                                   FROM Module__c 
                                   WHERE Id IN 
                                       (SELECT Module__c 
                                        FROM Trail_Module__c 
                                        WHERE Trail__c = :trailId)];
        
        this.modules = modules;
        
        for (Module__c module : modules) {
            if (module.Module_Progresses__r.size() > 0) {
                completedModuleMap.put(module.Id, module.Module_Progresses__r[0].Status__c == 'Completed');
            } else {
                completedModuleMap.put(module.Id, false);
            }
        }

        List<Unit__c> units = [SELECT Id, Name, Content__c, Total_Points__c, Estimated_Time__c, Module__c,
                                (SELECT Completed__c FROM Unit_Progresses__r WHERE Module_Progress__r.User__c = :userId)
                                FROM Unit__c 
                                WHERE Module__c IN :modules];

        this.units = units;

        for (Unit__c unit : units) {
            if (unit.Unit_Progresses__r.size() > 0) {
                completedUnitMap.put(unit.Id, unit.Unit_Progresses__r[0].Completed__c == true);
            } else {
                completedUnitMap.put(unit.Id, false);
            }
        }
        
        this.completedModuleMap = completedModuleMap;
        this.completedUnitMap = completedUnitMap;
        
        this.progressTrail = calculateProgressTrail(trailId); 
    }

    public Integer calculateProgressTrail(Id trailId) {
        
        Integer totalModules = modules.size();
        Integer completedModules = 0;
        Integer totalUnits = 0;
        Integer completedUnits = 0;
    
        for (Module__c module : modules) {
            if (completedModuleMap.get(module.Id)) {
                completedModules++;
            }
            totalUnits += module.Units__r.size();
            for (Unit__c unit : module.Units__r) {
                if (completedUnitMap.get(unit.Id)) {
                    completedUnits++;
                }
            }
        }
    
        Integer progress = 0;
    
        if (totalUnits > 0) {
            progress = Math.round((completedUnits / totalUnits) * 100);
        } else if (totalModules > 0) {
            progress = Math.round((completedModules / totalModules) * 100);
        }
    
        return progress; 
    }

    @AuraEnabled(cacheable = true)
    public static TrailWrapper getTrailId(Id moduleId) {
        
        Trail_Module__c trailModule = [SELECT Id, Trail__c FROM Trail_Module__c WHERE Module__c = :moduleId LIMIT 1];

        return new TrailWrapper(trailModule.Trail__c);
        
    }

}