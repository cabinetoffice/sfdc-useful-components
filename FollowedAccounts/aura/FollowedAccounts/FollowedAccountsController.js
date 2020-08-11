({
	init : function(cmp, event, helper) {
        var action = cmp.get('c.getFollowedAccounts');
                
        action.setCallback(this, function(response)
        {
            var items = response.getReturnValue();
            cmp.set('v.followedAccounts', items);
		});
        $A.enqueueAction(action);
	}
})