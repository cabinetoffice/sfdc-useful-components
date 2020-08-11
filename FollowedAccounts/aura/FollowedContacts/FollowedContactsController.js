({
	init : function(cmp, event, helper) {
        var action = cmp.get('c.getFollowedContacts');
                
        action.setCallback(this, function(response)
        {
            var items = response.getReturnValue();
            cmp.set('v.followedContacts', items);
		});
        $A.enqueueAction(action);
	}
})