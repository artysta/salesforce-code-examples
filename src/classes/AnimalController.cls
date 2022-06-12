public class AnimalController {
    
    public class AnimalsWrapper {
        @AuraEnabled
        public Animal__c animal;
        @AuraEnabled
        public Animal_Origin__c animalOrigin;
    }
    
    @AuraEnabled
    public static List<AnimalsWrapper> getAnimals(Id zooId) {
        List<Animal__c> animals = [SELECT Id, Name, Weight__c, Country__c, Animal_Template__r.Use_Origin_Data__c FROM Animal__c WHERE Zoo__c = :zooId];
        List<Animal_Origin__c> animalOrigins = [SELECT Id, Name, Weight__c, Country__c, Animal__c FROM Animal_Origin__c WHERE Animal__c IN :animals];
        
        List<AnimalsWrapper> animalsWrappers = new List<AnimalsWrapper>();
        
        for (Animal__c animal : animals) {
            AnimalsWrapper animalWrapper = new AnimalsWrapper();
            animalWrapper.animal = animal;
            
            for (Animal_Origin__c animalOrigin : animalOrigins) {
                if (animalOrigin.Animal__c != animal.Id) {
                    continue;
                }
                
                animalWrapper.animalOrigin = animalOrigin;
            }
            
            animalsWrappers.add(animalWrapper);
        }
        
        return animalsWrappers;
    }
}