@isTest
private class Test_ContactsManagerController {
    // insert to the database test records
    private static void insertData(Integer records) {
        List<Account> listAccount = new List<Account>();
        Account accA = new Account(Name = 'A');
        listAccount.add(accA);
        Account accB = new Account(Name = 'B');
        listAccount.add(accB);
        Account accC = new Account(Name = 'C');
        listAccount.add(accC);
        
        insert listAccount;
        
        List<Contact> testContactList = new List<Contact>();
        
        for(Integer i = 0; i < records; i++) {
            Contact cont = new Contact(
                FirstName = 'Name' + i,
                LastName = 'Surname' + i,
                Email = 'e' + i + '@mail.com'
            );
            
            if(i < 65) {
                cont.AccountId = accA.Id;
                cont.Contact_Level__c = 'Primary';
            } else if(i < 130) {
                cont.AccountId = accB.Id;
                cont.Contact_Level__c = 'Secondary';
            } else {
                cont.AccountId = accC.Id;
                cont.Contact_Level__c = 'Tertiary';
            }
            
            testContactList.add(cont);
        }
        
        insert testContactList;
    }
    
    // get variants of display / pagination
    private static List<SelectOption> getVue() {
        List<SelectOption>  vue = new List<SelectOption>();
        vue.add(new selectOption('All','All contacts'));
        vue.add(new selectOption('carousel','10 carousel'));
        vue.add(new selectOption('arrow','10 arrow'));
        
		return vue;
    }
    
    // available values of Contact Level
    private static List<SelectOption> getLevels() {
        List<SelectOption> testLevels = new List<SelectOption>();
        testLevels.add(new SelectOption('Primary', 'Primary'));
        testLevels.add(new SelectOption('Secondary', 'Secondary'));
        testLevels.add(new SelectOption('Tertiary', 'Tertiary'));
        
        return testLevels;
    }
    
    // test when number of records is less than pagination
    @isTest static void smallList() {
        Integer records = 9;
        Integer pagination = 10;
        insertData(records);
        Test.startTest();
        Test.setCurrentPage(Page.ContactsManager);
        List<SelectOption> testVue = getVue();
        List<SelectOption> testLevels = getLevels();
        String testQuery = 'SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact';
        String testCurrentQuery = testQuery;
        ApexPages.StandardSetController testDef = new ApexPages.StandardSetController(Database.query(testQuery));
        testDef.setSelected(Database.query(testQuery));
        ContactsManagerController cmc = new ContactsManagerController();
        
        System.assertEquals(testQuery, cmc.dbQuery, 'dbQuery is invalid');
        System.assertEquals(testCurrentQuery, cmc.currentQuery, 'currentQuery is invalid');
        System.assertEquals(Null, cmc.isPopupOpened, 'isPopupOpened isn\'t Null');
        System.assertEquals(Null, cmc.refresh, 'refresh isn\'t Null');
        System.assert(cmc.order, 'order isn\'t true');
        System.assertEquals(Null, cmc.selectedContactId, 'selectedContactId isn\'t Null');
        System.assertEquals(Null, cmc.selectedLevel, 'selectedLevel isn\'t Null');
        System.assertEquals(Null, cmc.paramSearch, 'paramSearch isn\'t Null');
        System.assertEquals(Null, cmc.paramSort, 'paramSort isn\'t Null');
        System.assertEquals(Null, cmc.oldValue, 'oldValue isn\'t Null');
        System.assertEquals(Null, cmc.paramSwitch, 'paramSwitch isn\'t Null');
        System.assertEquals(Null, cmc.firstName, 'firstName isn\'t Null');
        System.assertEquals(Null, cmc.lastName, 'lastName isn\'t Null');
        System.assertEquals(Null, cmc.email, 'email isn\'t Null');
        System.assertEquals(Null, cmc.account, 'account isn\'t Null');
        System.assertEquals(testLevels, cmc.levels, 'ContactLevels is invalid');
        System.assertNotEquals(Null, cmc.defContacts, 'StandardSetController is invalid');
        System.assertEquals('All', cmc.navigationType, 'navigationType not All');
        System.assertEquals(10000, cmc.PageSize, 'PageSize isn\'t equals 10000');
        cmc.navigationType = 'arrow';
        System.assertEquals(10, cmc.PageSize, 'PageSize isn\'t equals 10');
        System.assertNotEquals(Null, cmc.getContact(), 'Contact is invalid');
		System.assertEquals(testDef.getResultSize(), cmc.MaxNumberOfRecords, 'MaxNumberOfRecords is invalid');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        System.assertEquals(1, cmc.PageNumber, 'PageNumber isn\'t equals 1');
        System.assertEquals(1, cmc.QuantityOfPages, 'QuantityOfPages is invalid');
        System.assertEquals(testVue, cmc.getPageView(), 'PageView is invalid');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        
		Test.stopTest();
    }
    
    // test when number of records is more than pagination
    // test navigation, change of pagination, search, sort
    @isTest static void bigListNavigationPaginationSearchSort() {
        Integer records = 200;
        Integer pagination = 10;
        insertData(records);
        Test.startTest();
        Test.setCurrentPage(Page.ContactsManager);
        List<SelectOption> testVue = getVue();
        List<SelectOption> testLevels = getLevels();
        String testQuery = 'SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact';
        String testCurrentQuery = testQuery;
        ApexPages.StandardSetController testDef = new ApexPages.StandardSetController(Database.query(testQuery));
        testDef.setSelected(Database.query(testQuery));
        ContactsManagerController cmc = new ContactsManagerController();
        
        System.assertEquals(testQuery, cmc.dbQuery, 'dbQuery is invalid');
        System.assertEquals(testCurrentQuery, cmc.currentQuery, 'currentQuery is invalid');
        System.assertEquals(Null, cmc.isPopupOpened, 'isPopupOpened isn\'t Null');
        System.assertEquals(Null, cmc.refresh, 'refresh isn\'t Null');
        System.assert(cmc.order, 'order isn\'t true');
        System.assertEquals(Null, cmc.selectedContactId, 'selectedContactId isn\'t Null');
        System.assertEquals(Null, cmc.selectedLevel, 'selectedLevel isn\'t Null');
        System.assertEquals(Null, cmc.paramSearch, 'paramSearch isn\'t Null');
        System.assertEquals(Null, cmc.paramSort, 'paramSort isn\'t Null');
        System.assertEquals(Null, cmc.oldValue, 'oldValue isn\'t Null');
        System.assertEquals(Null, cmc.paramSwitch, 'paramSwitch isn\'t Null');
        System.assertEquals(Null, cmc.firstName, 'firstName isn\'t Null');
        System.assertEquals(Null, cmc.lastName, 'lastName isn\'t Null');
        System.assertEquals(Null, cmc.email, 'email isn\'t Null');
        System.assertEquals(Null, cmc.account, 'account isn\'t Null');
        System.assertEquals(testLevels, cmc.levels, 'ContactLevels is invalid');
        System.assertNotEquals(Null, cmc.defContacts, 'StandardSetController is invalid');
        System.assertEquals('All', cmc.navigationType, 'navigationType not All');
        System.assertEquals(10000, cmc.PageSize, 'PageSize isn\'t equals 10000');
        System.assertNotEquals(Null, cmc.getContact(), 'Contact is invalid');
		System.assertEquals(testDef.getResultSize(), cmc.MaxNumberOfRecords, 'MaxNumberOfRecords is invalid');
        Integer firstPage = 1;
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        System.assertEquals(firstPage, cmc.PageNumber, 'PageNumber isn\'t equals 1');
        System.assertEquals(1, cmc.QuantityOfPages, 'QuantityOfPages is invalid');
        System.assertEquals(testVue, cmc.getPageView(), 'PageView is invalid');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        
        // test arrow navigation
        cmc.navigationType = 'arrow';
        System.assertEquals(10, cmc.PageSize, 'PageSize isn\'t equals 10');
        System.assertEquals(records / pagination, cmc.QuantityOfPages, 'QuantityOfPages is invalid');
        cmc.forward();
        System.assertEquals(++firstPage, cmc.PageNumber, 'PageNumber isn\'t equals ' + firstPage);
        System.assertEquals(pagination, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals ' + pagination);
        cmc.forward();
        System.assertEquals(++firstPage, cmc.PageNumber, 'PageNumber isn\'t equals ' + firstPage);
        System.assertEquals(pagination * 2, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals ' + pagination * 2);
        cmc.back();
        System.assertEquals(--firstPage, cmc.PageNumber, 'PageNumber isn\'t equals ' + firstPage);
        System.assertEquals(pagination, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals ' + pagination);
        // first
        cmc.paramSwitch = 1;
        cmc.switchPage();
        System.assertEquals(1, cmc.PageNumber, 'PageNumber isn\'t equals 1');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals ' + 0);
        
        // test carousel navigation
        cmc.paramSwitch = 3;
        cmc.switchPage();
        System.assertEquals(3, cmc.PageNumber, 'PageNumber isn\'t equals 3');
        System.assertEquals(20, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals ' + 20);
        //last
        cmc.paramSwitch = cmc.QuantityOfPages;
        cmc.switchPage();
        System.assertEquals(cmc.QuantityOfPages, cmc.PageNumber, 'PageNumber isn\'t last');
        System.assertEquals((cmc.QuantityOfPages - 1) * 10, cmc.previousNumberOfRecords, 'previousNumberOfRecords is invalid');
        
        // disable pagination
        cmc.navigationType = 'All';
        System.assertEquals(10000, cmc.PageSize, 'PageSize isn\'t equals 10000');
        System.assertEquals(1, cmc.PageNumber, 'PageNumber isn\'t equals 1');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        
        // enable pagination
        cmc.navigationType = 'carousel';
        System.assertEquals(1, cmc.PageNumber, 'PageNumber isn\'t equals 1');
        System.assertEquals(10, cmc.PageSize, 'PageSize isn\'t equals 10');
        
        // search
        cmc.paramSearch = ' ame2 ';
        cmc.searchName();
        testCurrentQuery = testQuery + ' WHERE (Name LIKE\'%ame2%\') OR (LastName LIKE\'%ame2%\')';
        testDef = new ApexPages.StandardSetController(Database.query(testCurrentQuery));

        System.assertEquals('ame2', cmc.paramSearch, 'paramSearch not trimed');
        System.assertEquals(testCurrentQuery, cmc.currentQuery, 'currentQuery is invalid');
        System.assertNotEquals(Null, cmc.defContacts, 'defContacts is invalid');
        
        // sort
        cmc.paramSort = 'Name';
        Boolean last = cmc.order;
        cmc.sortColumn();
        System.assertEquals(testQuery + ' ORDER BY ' + cmc.paramSort, cmc.currentQuery, 'currentQuery is invalid');
        System.assertEquals(cmc.paramSort, cmc.oldValue, 'oldValue is invalid');
        System.assertNotEquals(last, cmc.order, 'order wasn\'t changed');
        last = cmc.order;
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        // sort DESC
        cmc.paramSort = 'Name';
        cmc.sortColumn();
        System.assertEquals(testQuery + ' ORDER BY ' + cmc.paramSort + ' DESC', cmc.currentQuery, 'currentQuery is invalid');
        System.assertEquals(cmc.paramSort, cmc.oldValue, 'oldValue is invalid');
        System.assertNotEquals(last, cmc.order, 'order wasn\'t changed');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords isn\'t equals 0');
        
        Test.stopTest();
    }
    
    // test when number of records is more than pagination
    // test delete Contact, create Contact
    @isTest static void bigListDeleteCreate() {
        Integer records = 200;
        Integer pagination = 10;
        insertData(records);
        Test.startTest();
        Test.setCurrentPage(Page.ContactsManager);
        List<SelectOption> testVue = getVue();
        List<SelectOption> testLevels = getLevels();
        String testQuery = 'SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact';
        String testCurrentQuery = testQuery;
        ApexPages.StandardSetController testDef = new ApexPages.StandardSetController(Database.query(testQuery));
        testDef.setSelected(Database.query(testQuery));
        ContactsManagerController cmc = new ContactsManagerController();
        cmc.navigationType = 'arrow';

         // open popup
        cmc.openPopup();
        System.assert(cmc.isPopupOpened, 'isPopupOpened isn\'t true');
        // close popup
        cmc.closePopup();
        System.assert(!cmc.isPopupOpened, 'Popup not closed');
        
        // delete not sorted
        Contact testDelCont = [SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact LIMIT 1];
        cmc.selectedContactId = testDelCont.Id;
        cmc.deleteContact();
        testDef = new ApexPages.StandardSetController(Database.query(testCurrentQuery));
        List<Contact> checkList = [SELECT Name FROM Contact WHERE Id =: testDelCont.Id];
        List<Contact> testListContacts = [SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact];
        System.assertEquals(0, checkList.size(), 'Contact wasn\'t deleted');
        System.assertEquals(--records, testListContacts.size(), 'Contact wasn\'t deleted');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords != 0');
        System.assertEquals(Null, cmc.selectedContactId, 'selectedContactId != Null');
        
        // sort
        cmc.paramSort = 'Email';
        cmc.sortColumn();
        // delete sorted
        testDelCont = [SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact ORDER BY Email LIMIT 1];
        cmc.selectedContactId = testDelCont.Id;
        testDef = new ApexPages.StandardSetController(Database.query(testCurrentQuery + ' ORDER BY ' + cmc.paramSort));
        cmc.deleteContact();
        checkList = [SELECT Name FROM Contact WHERE Id =: testDelCont.Id];
        testListContacts = [SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact];
        System.assertEquals(0, checkList.size(), 'Contact wasn\'t deleted');
        System.assertEquals(--records, testListContacts.size(), 'Contact wasn\'t deleted');
        System.assertEquals(0, cmc.previousNumberOfRecords, 'previousNumberOfRecords != 0');
        System.assertEquals(Null, cmc.selectedContactId, 'selectedContactId != Null');
        
        // open popup
        cmc.openPopup();
        System.assert(cmc.isPopupOpened, 'isPopupOpened isn\'t true');
        
        Integer messages = 2;
        // save without LastName without Email
        cmc.save();
        System.assertEquals(messages, ApexPages.getMessages().size());
        testListContacts = [SELECT Id FROM Contact];
        System.assertEquals(records, testListContacts.size());
        System.assert(!cmc.refresh);
        
        // save with invalid Email
        cmc.lastName = 'Lname';
        cmc.email = 'try';
        cmc.save();
        messages += 2;
        System.assertEquals(messages, ApexPages.getMessages().size());
        testListContacts = [SELECT Id FROM Contact];
        System.assertEquals(records, testListContacts.size());
        System.assert(cmc.refresh);
        
        // save correctly without Account
        cmc.firstName = 'Fname';
        cmc.lastName = 'Lname';
        cmc.email = 'some@mail.com';
        cmc.save();
        System.assertEquals(++messages, ApexPages.getMessages().size());
        testListContacts = [SELECT Id FROM Contact];
        System.assertEquals(++records, testListContacts.size(), 'Contact wasn\'t created');
        System.assert(cmc.refresh);
        
        // save correctly with new Account
        cmc.firstName = 'FFname';
        cmc.lastName = 'LLname';
        cmc.email = 'test@at.last';
        cmc.account = 'something new';
        cmc.save();
        testListContacts = [SELECT Id FROM Contact];
        System.assertEquals(++records, testListContacts.size(), 'Contact wasn\'t created');
        System.assertEquals(messages, ApexPages.getMessages().size());
		System.assert(cmc.refresh);
         
        // save correctly with existing Account
        cmc.firstName = 'Fffname';
        cmc.lastName = 'Lllname';
        cmc.email = 'test@at.last';
        cmc.account = [SELECT Name FROM Account LIMIT 1].Name;
        cmc.save();
        testListContacts = [SELECT Id FROM Contact];
        System.assertEquals(++records, testListContacts.size(), 'Contact wasn\'t created');
        System.assertEquals(messages, ApexPages.getMessages().size());
		System.assert(cmc.refresh);
        
        // close popup
        cmc.closePopup();
        System.assert(!cmc.isPopupOpened, 'Popup not closed');
        
        Test.stopTest();
    }
}
