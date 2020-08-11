({
	init : function(cmp) {
        var action = cmp.get('c.getContent');
        action.setParams({recordId : cmp.get('v.recordId')});
        
        action.setCallback(this, function(response)
        {
        	cmp.set("v.content", response.getReturnValue());
		});
        $A.enqueueAction(action);
	}
})