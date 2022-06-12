({
    getAnimalsFunction: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        component.set('v.columns', [
            {label: 'Id', fieldName: 'id', type: 'text'},
            {label: 'Weight', fieldName: 'weight', type: 'text'},
            {label: 'Country', fieldName: 'country', type: 'text'},
            {label: 'Use Origin Data (Template)', fieldName: 'useOriginData', type: 'text'},
            {label: 'Origin Data Record Exists', fieldName: 'originDataRecordExists', type: 'text'}
        ]);
        
        var action = component.get('c.getAnimals');
        action.setParams(
            {
                zooId : recordId
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log('[Animals List Component] SUCCESS');
                let animals = response.getReturnValue();
                
                animals.forEach(animal => {
                    animal.id = animal.animal.Id;
                    animal.useOriginData = animal.animal.Animal_Template__r.Use_Origin_Data__c;
                    animal.originDataRecordExists = animal.animalOrigin == undefined ? `false (non-Origin data will be used)` : true;
            
                    if (animal.animal.Animal_Template__r.Use_Origin_Data__c && animal.animalOrigin != undefined) {
                    	animal.weight = `${animal.animalOrigin.Weight__c} (Origin Data)`;
                        animal.country = `${animal.animalOrigin.Country__c} (Origin Data)`;
                	} else {
                    	animal.weight= `${animal.animal.Weight__c} (non-Origin Data)`;
                        animal.country = `${animal.animal.Country__c} (non-Origin Data)`;
                	}
                });
                
                component.set('v.data', animals);
			} else {
				let error = response.getError();
				console.log('[Animals List Component] Something went wrong! Error message: ' + error[0].message);
            }
		});
		
		$A.enqueueAction(action);
	}
})