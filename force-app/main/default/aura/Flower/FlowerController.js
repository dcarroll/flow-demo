({
    doInit : function(component, event, helper) {

        component.set('v.columns', [
            {label: 'Record Id', fieldName: 'Id', type: 'text'},
            {label: 'Record name', fieldName: 'Name', type: 'text'}
        ]);

        helper.initializeFlowList(component);
		// component.set('v.flowname', component.find('flow').get('v.value'));
        helper.fetchData(component);
    },
        
    runFlow : function(component, event, helper) {
        component.set('v.flowname', component.find('flow').get('v.value'));
        helper.fetchData(component);
    }
})