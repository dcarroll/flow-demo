({
    sendEmail : function(component) {
        var action = component.get("c.TAFlow");
        action.setParams({
            flowname: component.get("v.flowname").replace(' ', '_')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = JSON.parse(response.getReturnValue());
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Notification",
                    "message": "Team America Alerted!"
                });
                resultsToast.fire();
                console.log(JSON.parse(result));
                var columns = JSON.parse(result).columns;
                console.log('Columns\n\n' + columns);
                this.setupColumns(component, JSON.parse(result).columns);

                component.set('v.data', JSON.parse(result).records);
            }
        });
        $A.enqueueAction(action);
    },

    setupColumns: function(component, columndata) {
        component.set('v.columns', columndata);
    }
})
