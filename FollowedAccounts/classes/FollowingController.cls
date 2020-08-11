public class FollowingController 
{
	@AuraEnabled
    public static List<Account> getFollowedAccounts()
    {
        // polymorphic soql goes awry with EntitySubs apparently!
        List<EntitySubscription> subs = [SELECT 
            	Id, 
                ParentId
            FROM EntitySubscription 
            WHERE 
            	SubscriberId = :UserInfo.getUserId()
            	AND Parent.Type = 'Account'
        ];
        
        Set<Id> accountIds = new Set<Id>();
        for (EntitySubscription es : subs)
        {
            accountIds.add(es.ParentId);
        }
        
        return [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
    }
    
    @AuraEnabled
    public static List<Contact> getFollowedContacts()
    {
        List<EntitySubscription> subs = [SELECT 
            	Id, 
                ParentId
            FROM EntitySubscription 
            WHERE 
            	SubscriberId = :UserInfo.getUserId()
            	AND Parent.Type = 'Contact'
        ];
        
        Set<Id> contactIds = new Set<Id>();
        for (EntitySubscription es : subs)
        {
            contactIds.add(es.ParentId);
        }
        
        return [SELECT Id, FirstName, LastName, Account.Name FROM Contact WHERE Id IN :contactIds];
    }
}