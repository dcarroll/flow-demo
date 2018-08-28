({
    showToast: function(title, message) {
        var toast = $A.get("e.force:showToast");
        toast.setParams({
            "title": title,
            "message": message
        });
        toast.fire();
    },

    validateFieldList: function(component, sobjectType) {
        var action = component.get("c.validateFieldList");
        action.setParams({
            sobjectType: sobjectType,
            fieldList: component.get("v.fieldList")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = JSON.parse(response.getReturnValue());
                if (result.length !== 0) {
                    var message = "\n\nInvalid fields for " + sobjectType + '\n';
                    for (var i=0;i<result.length;i++) {
                        message += '\t' + (i + 1) + ': ' + result[i] + '\n';
                    }
                    throw(message + '\n');
                }
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }

            }
        });
        $A.enqueueAction(action);
    },

    sendEmail : function(component) {
        var action = component.get("c.TAFlow");
        action.setParams({
            flowname: component.get("v.flowname").replace(' ', '_')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = JSON.parse(response.getReturnValue());
                this.showToast("Notification", "Team America Alerted!");
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
