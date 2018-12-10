@isTest
private class Test_ContactTrigger {
    // when user didn't specify an account
    @isTest static void testInsertContactWithoutAccount() {
        Integer lengthBefore = [SELECT Id FROM Case].size();
        
        Contact testContact = new Contact(
            LastName = 'LastNameWithout',
            Email = 'e@ma.il'
        );
        insert testContact;
        
        Integer lengthAfter = [SELECT Id FROM Case].size();
        System.assertNotEquals(lengthBefore, lengthAfter, 'Case wasn\'t created');
        
        Case testCase = [SELECT ContactId FROM Case WHERE ContactId =: testContact.Id];
        System.assertNotEquals(Null, testCase.ContactId, 'Case.ContactId doesn\'t exist');
    }
    
    // when user specified an account
    @isTest static void testInsertContactWithAccount() {
        Integer lengthBefore = [SELECT Id FROM Case].size();
        Account testAccount = new Account(
            Name = 'AccountName'
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            LastName = 'LastName',
            Email = 'e@ma.il',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        Integer lengthAfter = [SELECT Id FROM Case].size();
        System.assertNotEquals(lengthBefore, lengthAfter, 'Case wasn\'t created');
        
        Case testCase = [SELECT ContactId, AccountId FROM Case WHERE ContactId =: testContact.Id];
        System.assertNotEquals(Null, testCase.ContactId, 'Case.ContactId doesn\'t exist');
        System.assertEquals(testAccount.Id, testCase.AccountId, 'Case.AccountId doesn\'t correspond to Contact.AccountId');
    }
    
    // delete
    @isTest static void testDeleteContact() {
        Contact testContact = new Contact(
            LastName = 'LastNameWithout',
            Email = 'e@ma.il'
        );
        insert testContact;
        
        Integer lengthBefore = [SELECT Id FROM Case].size();
        
        delete testContact;
        Integer lengthAfter = [SELECT Id FROM Case].size();
        System.assertNotEquals(lengthBefore, lengthAfter, 'Case wasn\'t deleted');
    }
}