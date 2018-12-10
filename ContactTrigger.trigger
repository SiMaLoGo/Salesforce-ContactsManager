trigger ContactTrigger on Contact (after insert, before delete) {
    // insert
    if(Trigger.isInsert) {
        List<Case> cases = new List<Case>();
        
        for(Contact element: Trigger.new) {
            if(element.AccountId != Null) {
                cases.add(new Case(
                    ContactId = element.Id,
                    AccountId = element.AccountId
                ));
            } else {
                cases.add(new Case(
                    ContactId = element.Id
                ));
            }  
        }
        
        try {
        	insert cases;
        } catch(DmlException e) {
                System.debug('Error New Contact page : ' + e.getMessage());
        }
    }
    
    // delete
    if(Trigger.isDelete) {
        List<Id> idCases = new List<Id>();
        
        for(Contact element: Trigger.old) idCases.add(element.Id);
        
        List<Case> casesDel = [SELECT Id FROM Case WHERE ContactId IN: idCases];
        try {
        	delete casesDel;
        } catch(DmlException e) {
                System.debug('Error New Contact page : ' + e.getMessage());
        }
    }
}