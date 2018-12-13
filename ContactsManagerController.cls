public with sharing class ContactsManagerController {
    // determines is popup opened
    public Boolean isPopupOpened {get; set;}
    // determines whether to refresh a form in popup
    public Boolean refresh {get; set;}
    // order of sorting ASC or DESC
    public Boolean order {get; set;}
    // Id of Contact which need delete
    public Id selectedContactId {get; set;}
    // determines size of pagination
    public Integer pagination {get; set;}
    // text of database query
    public String dbQuery {get; set;}
    // current query for correct rendering after deleting of Contact
    // for correct rendering after close popup
    public String currentQuery {get; set;}
    // level(parameter) which user select
    public String selectedLevel {get; set;}
    // parameter which user typied for search
    public String paramSearch {get; set;}
    // field(parameter) for sort a list of contacts
    public String paramSort {get; set;}
    // old value of paramSort
    public String oldValue {get; set;}
    // PageNumber for switch in page navigation
    public Integer paramSwitch {get; set;} 
    // parameter for save
    public String firstName {get; set;}
    // parameter for save
    public String lastName {get; set;}
    // parameter for save
    public String email {get; set;}
    // parameter for save
    public String account {get; set;}
    // available values of Contact Level
    public List<SelectOption> levels {get; set;}
    
    public ApexPages.StandardSetController defContacts {
        get {
            if(defContacts == Null) {
                defContacts = new ApexPages.StandardSetController(Database.query(dbQuery));
            }
            
            if(PageSize == Null) navigationType = 'All';

            defContacts.setPageSize(PageSize);
            return defContacts;
    	} set;
    }
    
    public List<Contact> getContact() {
		return (List<Contact>) defContacts.getRecords();
	}
    
    public Integer MaxNumberOfRecords{                                    
        get{
            return defContacts.getResultSize();
        }
        set;
    }

    // determines number of records in previous pages
    public Integer previousNumberOfRecords {get; set;}
    
    // constructor
    public ContactsManagerController() {
        pagination = 10;
        previousNumberOfRecords = 0;
        order = true;
        dbQuery = 'SELECT Name, Email, Contact_Level__c, AccountId, OwnerId, CreatedById, CreatedDate FROM Contact';
        currentQuery = dbQuery;
        levels = new List<SelectOption>();
        levels.add(new SelectOption('Primary', 'Primary'));
        levels.add(new SelectOption('Secondary', 'Secondary'));
        levels.add(new SelectOption('Tertiary', 'Tertiary'));
    }
    
    // page navigation
    public void back() {
        previousNumberOfRecords -= PageSize;
        defContacts.previous();
    }
    
    // page navigation
    public void forward() {
        previousNumberOfRecords += PageSize;
        defContacts.next();
    }
    
    // page navigation
    public void switchPage() {
        previousNumberOfRecords = (paramSwitch - 1) * 10;
        defContacts.setPageNumber(paramSwitch);
    }

    // property of StandardSetController object
    public Integer PageSize {
        get; set {
            PageSize = value;
        }
    }
    
    // property of StandardSetController object
    public Integer PageNumber {
        get {
            PageNumber = defContacts.getPageNumber();
            return PageNumber;
        }
        set {
            defContacts.setPageNumber(value);
        }
    }

    // how many pages to display
    public Integer QuantityOfPages {
        get {
            if(defContacts.getResultSize() <= pagination) {
                return QuantityOfPages = 1;
            }
            
            if(Math.Mod(defContacts.getResultSize(), defContacts.getPageSize()) != 0) {
                QuantityOfPages = defContacts.getResultSize() / defContacts.getPageSize() + 1;
            } else {
               QuantityOfPages = defContacts.getResultSize() / defContacts.getPageSize();
            }
            
            return QuantityOfPages;
        }
        set;
    }
    
    // All Contacts or carousel or arrow navigation
    public String navigationType {
        get; set {
            navigationType = value;
            
            if(value == 'All') {
                PageSize = 10000;
                previousNumberOfRecords = 0;
            } else PageSize = 10;
        }
    }
    
    // get variants of display / pagination
    public List<SelectOption> getPageView(){
        List<SelectOption>  vue = new List<SelectOption>();
        vue.add(new selectOption('All','All contacts'));
        vue.add(new selectOption('carousel','10 carousel'));
        vue.add(new selectOption('arrow','10 arrow'));
		return vue;
    }

    // search a word in FirstName or LastName of the Contacts
    public void searchName() {
        paramSearch = paramSearch.trim();
        currentQuery = dbQuery + ' WHERE (Name LIKE\'%' + paramSearch + '%\') OR (LastName LIKE\'%' + paramSearch + '%\')';
        defContacts = new ApexPages.StandardSetController(Database.query(currentQuery));
    }
    
    public void openPopup() {
        isPopupOpened = true;
    }
    
    public void closePopup() {
        defContacts = new ApexPages.StandardSetController(Database.query(currentQuery));
        
        previousNumberOfRecords = 0;
        isPopupOpened = false;
    }

	// save new Contact which fields user typied    
    public void save() {
        Boolean trouble = false;
        
        if(String.isBlank(lastName)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Last Name is required'));
            trouble = true;
        }
        
        if(String.isBlank(email)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Email is required'));
            trouble = true;
        }
        
        // if LastName is empty or Email is empty
        if(trouble) {
            refresh = false;
            return;
        }
        
        // if account not specified
    	if(String.isBlank(account)) {
        	Contact newContact = new Contact(
            	FirstName = firstName,
                LastName = lastName,
                Email = email,
                Contact_Level__c = selectedLevel
            );
            
            try {
                insert newContact;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contact was created'));
            } catch(DmlException e) {
                System.debug('Error New Contact page : ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data aren\'t correct. Contact can\'t be created.'));
                refresh = false;
        	}
        // if account specified
		} else {
        	List<Account> acc = [SELECT Name FROM Account WHERE Name =: account];
               
            // existing account
            if(!acc.isEmpty()) {
            	Contact newContact = new Contact(
                	FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    AccountId = acc.get(0).Id,
                    Contact_Level__c = selectedLevel
                );
                
                try {
                	insert newContact;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contact was created'));
                } catch(DmlException e) {
                    System.debug('Error New Contact page : ' + e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data aren\'t correct! Contact can\'t be created.'));
                    refresh = false;
                }
            // new account
			} else {
                Account newAccount = new Account(Name = account);
                try {
                	insert newAccount;
                } catch(DmlException e) {
                    System.debug('Error New Contact page : ' + e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data aren\'t correct! Account can\'t be created.'));
                    refresh = false;
                }
            
                Contact newContact = new Contact(
                	FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    AccountId = newAccount.Id,
                    Contact_Level__c = selectedLevel
                );
                
                try {
                    insert newContact;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Contact was created'));
                } catch(DmlException e) {
                    System.debug('Error New Contact page : ' + e.getMessage());
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Data aren\'t correct! Contact can\'t be created.'));
                    refresh = false;
                }
            }
        }

        firstName = lastName = email = account = selectedLevel = Null;
        refresh = true;
    }
    
    // delete Contact
    public void deleteContact() {
        if(selectedContactId != Null) {
            delete [SELECT Id FROM Contact WHERE Id =: selectedContactId];
            
            defContacts = new ApexPages.StandardSetController(Database.query(currentQuery));
            
            previousNumberOfRecords = 0;
            selectedContactId = Null;
        }
    }
    
    // sort a Contact list by a field
    public void sortColumn() {
        // DESC only when re-click column
        if(!order && (paramSort == oldValue)) {
            currentQuery = dbQuery + ' ORDER BY ' + paramSort + ' DESC';
            defContacts = new ApexPages.StandardSetController(Database.query(currentQuery));
        } else {
            currentQuery = dbQuery + ' ORDER BY ' + paramSort;
            defContacts = new ApexPages.StandardSetController(Database.query(currentQuery));
        }
        
        order = !order;
        oldValue = paramSort;
        previousNumberOfRecords = 0;
	}
}
