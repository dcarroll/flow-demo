({
    doInit : function(component, event, helper) {
        helper.setupColumns(component);
    },

    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
            var changedFields = JSON.parse(JSON.stringify(eventParams.changedFields));
            console.log(changedFields);
            if (changedFields.StageName.value !== changedFields.StageName.oldValue 
                && changedFields.StageName.value === component.get('v.triggerstage')) {
                helper.sendEmail(component);
            }
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
})