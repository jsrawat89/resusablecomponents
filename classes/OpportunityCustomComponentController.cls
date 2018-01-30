/******************************************************
    Name        :    OpportunityCustomComponentController
    Description :    Custom component for lightning detail page 
*******************************************************/
public class OpportunityCustomComponentController{

    @AuraEnabled
    public static OpportunityWrapper getOpportunityRecordwinloss(String oppId){
       OpportunityWrapper model = new OpportunityWrapper();
       List<Opportunity> opplst = [Select id,StageName,closedate,Loss_Reason__c,Won_Reason__c,Win_Loss_Reason_Description__c,Competitor_loss_to__c from Opportunity where id =: oppId];
       if(opplst.size()>0){
           model.oppObj = opplst[0];
           model.lossreasonOpts = getPicklistOptions('Opportunity','Loss_Reason__c',model.oppObj.Loss_Reason__c);
           model.winreasonOpts = getPicklistOptions('Opportunity','Won_Reason__c',model.oppObj.Won_Reason__c);
           model.complosstoOpts= getPicklistOptions('Opportunity','Competitor_loss_to__c',model.oppObj.Competitor_loss_to__c);
           model.stagenameOpts = getPicklistOptions('Opportunity','StageName',model.oppObj.StageName);
           
           
       }
       return  model;
    }
    
    //stage name options
   /* private static String getStageNameOptions(String selectedValue){
       
        String picklistOptions = '';
        picklistOptions += '{';
        picklistOptions += '"label": "' + '--None--' + '",';
        picklistOptions += '"value": "' + '' + '"';
                        if(selectedValue != 'Closed Won' && selectedValue != 'Closed Lost')
                            picklistOptions  += ',"selected": "true"';
        picklistOptions += '}';
        
        picklistOptions += ',{';
        picklistOptions += '"label": "' + 'Closed Won' + '",';
        picklistOptions += '"value": "' + 'Closed Won' + '"';
                        if(selectedValue == 'Closed Won')
                            picklistOptions  += ',"selected": "true"';
        picklistOptions += '}';
        
        picklistOptions += ',{';
        picklistOptions += '"label": "' + 'Closed Lost' + '",';
        picklistOptions += '"value": "' + 'Closed Lost' + '"';
                        if(selectedValue == 'Closed Lost')
                            picklistOptions  += ',"selected": "true"';
        picklistOptions += '}';
        
        
        return '[' + picklistOptions + ']';
    }*/
    
    //for milestone section
    @AuraEnabled
    public static Opportunity getOpportunityRecordmilestones(String oppId){
        Opportunity oppObj = new Opportunity();
        if(oppId != null)
            oppObj = [Select id,PDQ_ID__c,MOU__c,Proposal_Accepted__c,Definitive_Agreement_Complete__c from Opportunity where id =: oppId];
        return oppObj;
    }
    
    @AuraEnabled
    public static void saveOpportunity(String oppObjJson){
         Opportunity oppobj = (Opportunity) JSON.deserialize(oppObjJson, Opportunity.class);
         update oppobj;
    }
    
    @AuraEnabled
    public static List<Event> getEventlist(String recordId,String recordTypeId){
        List<Event> eventlst = new List<Event>();
        if(recordId != null){
            Set<String> recordIds = new Set<String>();
            if(recordId.startswith('001')){
                Map<String,Opportunity> oppmap = new Map<String,Opportunity>([Select id from Opportunity where accountId =: recordId]);
                if(oppmap.size()>0)
                    recordIds.addAll(oppmap.keyset());
            }
            recordIds.add(recordId);
            eventlst = [Select id,subject,whatId,What.name,whoId,who.name,ownerid,owner.name,activitydate,EndDateTime 
                        from Event where whatId IN : recordIds AND RecordTypeId =: recordTypeId ORDER BY activitydate DESC limit 10000 ];
        }
        return eventlst;
    }
    
    private static String getPicklistOptions(String objectName,String fieldName,String selectedValue){
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{objectName});
        Schema.DescribeFieldResult fieldResult = descResult[0].fields.getMap().get(fieldName).getDescribe();
        String picklistOptions = '';
        picklistOptions += '{';
        picklistOptions += '"label": "' + '--None--' + '",';
        picklistOptions += '"value": "' + '' + '"';
                     //   if(!(selectedValue != null && selectedValue.length() > 0))
                       //     picklistOptions  += ',"selected": "true"';
        picklistOptions += '}';
        for(Schema.PicklistEntry ple : fieldResult.getPicklistValues()){
            picklistOptions += ',{';
            picklistOptions += '"label": "' + ple.getLabel() + '",';
            picklistOptions += '"value": "' + ple.getValue() + '"';
                            if(ple.getValue() == selectedValue)
                                picklistOptions  += ',"selected": "true"';
            picklistOptions += '}';
        }
        
        return '[' + picklistOptions + ']';
    }
    
    public class OpportunityWrapper{
        @AuraEnabled
        public Opportunity oppObj;
        @AuraEnabled
        public String lossreasonOpts;
        @AuraEnabled
        public String winreasonOpts;
        @AuraEnabled
        public String complosstoOpts;
        @AuraEnabled
        public String stagenameOpts;
    }
}