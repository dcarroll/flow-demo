({
    fetchData : function(component) {
        var action = component.get("c.funFlow");
        action.setParams({
            flowname: component.get("v.flowname")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.data', JSON.parse(result));
            }
        });
        $A.enqueueAction(action);
    },
    
    initializeFlowList: function(component) {
        var action = component.get('c.getpicklist');
        var options = [];
        action.setCallback(this, function(response) {
            var result = JSON.parse(response.getReturnValue());
            for (var i=0;i<result.length;i++) {
                var option = result[i];
                if (result[i].label === component.get('v.flowname')) {
                    result[i].selected = true;
                    break;
                }
            }
            component.set('v.flows', result);
        });
        $A.enqueueAction(action);
    }
})