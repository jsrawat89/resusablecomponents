/**
  * Name        : OppTerrAssignLogicFilter
  * Description : get the opportunity and it's territory id map based on account's territory, if mulitple territory for an account then assigned to the 
                  created by user's territory
  */
global class OppTerrAssignLogicFilter implements TerritoryMgmt.OpportunityTerritory2AssignmentFilter { 
    /**
     * No-arg constructor.
     */ 
     global OppTerrAssignLogicFilter() {}

     /**
      * get the opportunity and it's territory id map based on account's territory, if mulitple territory for an account then assigned to the 
        created by user's territory
      */
    global Map<Id,Id> getOpportunityTerritory2Assignments(List<Id> opportunityIds) { 
       
        Map<Id, Id> OppIdTerritoryIdResult = new Map<Id, Id>();

        // Get the active territory model Id
        Id activeModelId = getActiveModelId();
        
        //Get user role id
        Id salesDirectorRoleId = getUserRoleId('Sales Director');
        
        

        if(activeModelId != null){
            List<Opportunity> opportunities =
              [Select Id, AccountId, Territory2Id,CreatedById,CreatedBy.userRoleId from Opportunity where Id IN :opportunityIds];
            Set<Id> accountIds = new Set<Id>();
            Set<Id> userIds = new Set<Id>();
            // Create set of parent accountIds
            for(Opportunity opp:opportunities){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                    if(salesDirectorRoleId == opp.CreatedBy.userRoleId )
                        userIds.add(opp.CreatedById);
                }                               
            }

            Map<Id,Territory2Wrapper> accountterritory2IdMap = getaccountTerritoryMap(activeModelId, accountIds);
            Map<Id,Territory2Wrapper> userTerritoryMap = getUserTrritoryMap(userIds);

            // For each opportunity, assign the highest priority territory if there is no conflict, else assign null.
            for(Opportunity opp: opportunities){
               Territory2Wrapper tw = accountterritory2IdMap.get(opp.AccountId);
               // Assign if account don't have multiple territories
              if(tw != null && tw.mulitipleTerritory == false){
                   OppIdTerritoryIdResult.put(opp.Id, tw.territory2Id);
               }else if(userTerritoryMap.containskey(opp.CreatedById) && userTerritoryMap.get(opp.CreatedById).mulitipleTerritory == false){
                   // if multiple territory then assign the created by user's territory if user is sales director and has only one territory assigned
                   OppIdTerritoryIdResult.put(opp.Id, userTerritoryMap.get(opp.CreatedById).territory2Id);
               }else{
                   OppIdTerritoryIdResult.put(opp.Id, null);
               }
            }
        }
        return OppIdTerritoryIdResult;
    }
    
    /**
      * get user territory map 
      */
    private static Map<Id,Territory2Wrapper> getUserTrritoryMap(Set<Id> userIds){
        Map<Id,Territory2Wrapper> userTerritoryMap = new Map<Id,Territory2Wrapper>();
        for(UserTerritory2Association ut : [SELECT Territory2Id,UserId FROM UserTerritory2Association
                                            where UserId IN : userIds AND IsActive = true]){
            Territory2Wrapper tw = userTerritoryMap.get(ut.UserId);
            if(tw == null){
                tw = new Territory2Wrapper(ut.Territory2Id,false);
            }else if(tw != null){
                tw.mulitipleTerritory = true;
            }
            userTerritoryMap.put(ut.UserId,tw);
        }
        return userTerritoryMap;
    }
      
    /**
      * Get the map of 
      */
     private Map<Id,Territory2Wrapper> getaccountTerritoryMap(Id activeModelId, Set<Id> accountIds){
        
        Map<Id,Territory2Wrapper> accountTerritoryMap = new Map<Id,Territory2Wrapper>();
        
        
        for(ObjectTerritory2Association ota:[Select ObjectId, Territory2Id, Territory2.Territory2Type.Priority 
                                            from ObjectTerritory2Association 
                                            where objectId IN :accountIds and Territory2.Territory2ModelId = :activeModelId]){
            Territory2Wrapper tw = accountTerritoryMap.get(ota.ObjectId);

            if(tw == null){                
                tw = new Territory2Wrapper(ota.Territory2Id,false);
            }else if(tw != null){
                //if mulitple account territories then mark this boolean true
                tw.mulitipleTerritory = true;                
            }
            
            accountTerritoryMap.put(ota.ObjectId, tw);
        }
        return accountTerritoryMap;
    }


    /**
     * Get the Id of the Active Territory Model.
     * If none exists, return null.
     */
    private Id getActiveModelId() {
        List<Territory2Model> models = [Select Id from Territory2Model where State = 'Active'];
        Id activeModelId = null;
        if(models.size() == 1){
            activeModelId = models.get(0).Id;
        }

        return activeModelId;
    }
    
     /**
     * Get the Id of the user role id based on passed name
     * If none exists, return null.
     */
    private Id getUserRoleId(String roleName) {
        List<UserRole> userrolelist = [SELECT Id,Name FROM UserRole where name =: roleName];
        Id userRoleId = null;
        if(userrolelist.size() == 1){
            userRoleId = userrolelist.get(0).Id;
        }

        return userRoleId;
    }

    /**
    * Helper class to help capture territory2Id, wheter account has mulitple territories
    */
    private class Territory2Wrapper {
        public Id territory2Id { get; set; }        
        public Boolean mulitipleTerritory { get; set; }

        Territory2Wrapper(Id territory2Id,Boolean mulitipleTerritory){
            this.territory2Id = territory2Id;            
            this.mulitipleTerritory = mulitipleTerritory;
        }
    }
}