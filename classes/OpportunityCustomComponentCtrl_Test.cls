/**************************************
    Name : OpportunityCustomComponentController_Test
    Decription : Test class OpportunityCustomComponentController
*****************************************/
@isTest
private class OpportunityCustomComponentCtrl_Test{

    private static testmethod void unittest(){
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
        OpportunityCustomComponentController.OpportunityWrapper oppmodel = OpportunityCustomComponentController.getOpportunityRecordwinloss(opp.Id);
        Opportunity opptest = OpportunityCustomComponentController.getOpportunityRecordmilestones(opp.id);
        OpportunityCustomComponentController.saveOpportunity(json.serialize(opp));
        List<RecordType> recordTypelist = [Select id from RecordType where sObjectType = 'Event' limit 1];
        OpportunityCustomComponentController.getEventlist(acc.Id,recordTypelist[0].Id);
    }
}