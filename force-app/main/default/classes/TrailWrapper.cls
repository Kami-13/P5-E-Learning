public class TrailWrapper {
    
    public Trail__c trail {get;set;}
    public Integer progressTrail {get;set;}
    public List<Module__c> modules {get;set;}
    public Set<Id> completedModuleIds {get;set;}
    public Set<Id> completedUnitIds {get;set;}
    
    public TrailWrapper(Id trailId) {
        trail = [SELECT Id, Name, Description__c, Total_Points__c, Total_Time__c 
                          FROM Trail__c 
                          WHERE Id = :trailId];
        
        this.trail = trail;
        this.progressTrail = calculateProgressTrail(trailId); 

        List<Module__c> modules = [SELECT Id, Name, Description__c, Total_Points__c, Total_Time__c, Skills__c,
                                   (SELECT Status__c FROM Module_Progresses__r)
                                   FROM Module__c 
                                   WHERE Id IN 
                                       (SELECT Module__c 
                                        FROM Trail_Module__c 
                                        WHERE Trail__c = :trailId)];
        
        this.modules = modules;
        this.completedModuleIds = getCompletedModuleIds(modules);

        List<Unit__c> units = [SELECT Id, Name, Content__c, Total_Points__c, Estimated_Time__c, 
                               (SELECT Completed__c FROM Unit_Progresses__r) 
                               FROM Unit__c 
                               WHERE Module__c IN :modules];
        
        this.completedUnitIds = getCompletedUnitIds(units);
    }

    public Integer calculateProgressTrail(Id trailId) {
        
        Integer totalModules = modules.size();
        Integer completedModules = completedModuleIds.size();
        Decimal totalUnits = 0;
        Decimal completedUnits = 0;
    
        for (Module__c module : modules) {
            totalUnits += module.Units__r.size();
            for (Unit__c unit : module.Units__r) {
                if (completedUnitIds.contains(unit.Id)) {
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

    public Set<Id> getCompletedModuleIds(List<Module__c> modules) {
        Set<Id> completedModuleIds = new Set<Id>();
        for (Module__c module : modules) {
            if (module.Module_Progresses__r[0].Status__c == 'Completed') {
                completedModuleIds.add(module.Id);
            }
        }
        return completedModuleIds;
    }

    public Set<Id> getCompletedUnitIds(List<Unit__c> units) {
        Set<Id> completedUnitIds = new Set<Id>();
        for (Unit__c unit : units) {
            if (unit.Unit_Progresses__r[0].Completed__c == true) {
                completedUnitIds.add(unit.Id);
            }
        }
        return completedUnitIds;
    }
}