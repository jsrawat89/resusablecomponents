/******************************************
    Name        :    OppTerrAssignLogicFilter_Test
    Description :    Test class for OppTerrAssignLogicFilter
********************************************/
@isTest
private class OppTerrAssignLogicFilter_Test{

    private static testmethod void oppTerrAssigntest(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.closedate = date.today();
        opp.stagename = 'Needs Analysis';
        opp.accountId = acc.Id;
        opp.Campaign_Status_Description__c = 'Test';
        //opp.Orders_Walk_Status_Update__c = 'Test';
        opp.Opportunity_Rating_Code__c = 'Low';
        insert opp;
        
        List<Territory2> territroylist = [SELECT Id,Territory2ModelId FROM Territory2 limit 1];
        ObjectTerritory2Association tAss = new ObjectTerritory2Association(Territory2Id = territroylist[0].Id,objectId = acc.Id,AssociationCause = 'Territory2Manual');
        insert tAss;
        
        OppTerrAssignLogicFilter filterctrl = new OppTerrAssignLogicFilter();
        
        filterctrl.getOpportunityTerritory2Assignments(new List<Id>{opp.Id});
    }
}