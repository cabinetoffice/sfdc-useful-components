public class ActionFollowRecordsController 
{
    ApexPages.StandardSetController stc;
	public ActionFollowRecordsController(ApexPages.StandardSetController controller)
    {
        stc = controller;
    }
    
    public PageReference follow()
    {
        /*Set<Id> existingSubs = new Set<Id>();
        for (EntitySubscription es : [SELECT Id, ParentId FROM EntitySubscription WHERE SubscriberId = :UserInfo.getUserId() LIMIT 1000])
        {
            existingSubs.add(es.ParentId);
        }*/
        
        List<EntitySubscription> subs = new List<EntitySubscription>();
        for (SObject sobj : stc.getRecords())
        {
            Account a = (Account)sobj;
            /*if (existingSubs.contains(a.Id))
            {
                continue;
            }*/
            
            EntitySubscription es = new EntitySubscription();
            es.SubscriberId = UserInfo.getUserId();
            es.ParentId = a.Id;
            subs.add(es);
        }
        insert subs;
        
        return new PageReference('/');
    }
}