@isTest
private class AnimalControllerTest {
    @testSetup
    static void setupTestData() {
        Zoo__c zoo = new Zoo__c();
        insert zoo;
        
        Animal_Template__c animalTemplate = new Animal_Template__c();
        insert animalTemplate;
        
        Animal__c animal = new Animal__c();
        animal.Weight__c = 100;
        animal.Zoo__c = zoo.Id;
        insert animal;
        
        Animal_Origin__c animalOrigin = new Animal_Origin__c();
        animalOrigin.Weight__c = 50;
        animalOrigin.Animal__c = animal.Id;
        insert animalOrigin;
    }
    
    @isTest
    static void shouldReturnAnimalWrapperWithAllData() {
        Zoo__c zoo = [SELECT Id FROM Zoo__c LIMIT 1];
        
        Test.startTest();
        List<AnimalController.AnimalsWrapper> animalsWrappers = AnimalController.getAnimals(zoo.Id);
        Test.stopTest();
        
        System.assert(!animalsWrappers.isEmpty(), 'animalsWrappers list should not be empty!');
        System.assert(animalsWrappers[0].animal != null, 'animal should NOT be null!');
        System.assertEquals(100, animalsWrappers[0].animal.Weight__c, 'animal.Weight__c should be 100!');
        System.assert(animalsWrappers[0].animalOrigin != null, 'animalOrigin should not be null!');
        System.assertEquals(50, animalsWrappers[0].animalOrigin.Weight__c, 'animalOrigin.Weight__c should be 50!');
    }
    
    @isTest
    static void animalWrapperAnimalOriginShouldBeNull() {
        Zoo__c zoo = [SELECT Id FROM Zoo__c LIMIT 1];
        delete [SELECT Id FROM Animal_Origin__c];
        
        Test.startTest();
        List<AnimalController.AnimalsWrapper> animalsWrappers = AnimalController.getAnimals(zoo.Id);
        Test.stopTest();
        
        System.assert(!animalsWrappers.isEmpty(), 'animalsWrappers list should not be empty!');
        System.assert(animalsWrappers[0].animalOrigin == null, 'animalOrigin should be null!');
    }
}