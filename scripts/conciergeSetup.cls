// update some Concierge settings
list<cncrgdemo2__Concierge_Settings__c> settings = [select id, name, cncrgdemo2__Value__c from cncrgdemo2__Concierge_Settings__c];
for (cncrgdemo2__Concierge_Settings__c setting:settings) {
    if (setting.name == 'Background file name for App') {
        setting.cncrgdemo2__Value__c = 'Bridge';
    } else if (setting.name == 'Display Company Logo') {
        setting.cncrgdemo2__Value__c = 'false';
    } else if (setting.name == 'Text to Display in Article Preview'){
        setting.cncrgdemo2__Value__c = 'false';
    }
}
update settings;

// put the contact on our user
List<case> cases = new List<case>();

contact jn = new contact(FirstName = 'Jenny', LastName = 'Nunez', Email = 'shane.mclaughlin@salesforce.com', cncrgdemo2__UserId__c = UserInfo.getUserId());
insert jn;

// let's have some ticket history for Jenny
cases.add(new case(Subject = 'Laptop Replacement', ContactId = jn.Id, Status='Closed', Origin='Concierge'));
cases.add(new case(Subject = 'Badge Renewal', ContactId = jn.Id, Status='Closed', Origin='Concierge'));
cases.add(new case(Subject = 'Address Change', ContactId = jn.Id, Status='Closed', Origin='Concierge'));
cases.add(new case(Subject = 'VPN problems', ContactId = jn.Id, Status='Closed', Origin='Concierge'));
cases.add(new case(Subject = 'Beneficiary Changes (new baby!)', ContactId = jn.Id, Status='Closed', Origin='Concierge'));
cases.add(new case(Subject = 'Starting maternity leave', ContactId = jn.Id, Status='Closed', Origin='Concierge'));

List<Contact> otherEmployees = new List<Contact>();
otherEmployees.add(new contact(FirstName = 'Isaac', LastName = 'Payne', Title = 'CFO', Phone = '8324728021'));
otherEmployees.add(new contact(FirstName = 'Bandar', LastName = 'El-Eita', Title = 'VP Manufacturing', Phone = '8324728021'));
otherEmployees.add(new contact(FirstName = 'Jessica', LastName = 'Liu', Title = 'VP PR and Events', Phone = '8324728021'));
otherEmployees.add(new contact(FirstName = 'Shannon', LastName = 'Duffy', Title = 'CEO', Phone = '8324728021'));
otherEmployees.add(new contact(FirstName = 'Eric', LastName = 'Igerbase', Title = 'Director Customer Support', Phone = '8324728021'));
insert otherEmployees;

cases.add(new case(Subject = 'Laptop Replacement', ContactId = otherEmployees[0].Id, Status='Working', Origin='Concierge', Type='IT'));
cases.add(new case(Subject = 'Lost my phone again (sorry!)', ContactId = otherEmployees[1].Id, Status='New', Origin='Concierge', Type='IT'));
cases.add(new case(Subject = 'Laptop screen has weird glowing ring in the middle', ContactId = otherEmployees[2].Id, Status='Working', Origin='Concierge', Type='IT'));
cases.add(new case(Subject = 'VPN is super slow', ContactId = otherEmployees[3].Id, Status='Escalated', Origin='Concierge', Type='IT'));
cases.add(new case(Subject = 'I need Access to Photoshop', ContactId = otherEmployees[4].Id, Status='New', Origin='Concierge', Type='IT'));

insert cases;

// get record type
Id ConciergeRT = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Concierge').getRecordTypeId();

List<Knowledge__kav> kavs = [select id, recordTypeId, PublishStatus from Knowledge__kav];
for (Knowledge__kav ka:kavs){
    ka.recordTypeId = ConciergeRT;
}
update kavs;

// publish the articles
for (Knowledge__ka ka:[select id from Knowledge__ka]){
    KbManagement.PublishingService.publishArticle(ka.Id, true);
}
