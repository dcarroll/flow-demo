public with sharing class FlowController {
    public FlowController() {

    }

    @AuraEnabled
    public static String getpicklist() {
    	FlowsPicklist fpl = new FlowsPicklist();
        VisualEditor.DynamicPickListRows plr = fpl.getValues();
  		List<OptionValue> options = new List<OptionValue>();
        for (VisualEditor.DataRow x : plr.getDataRows()) {
            options.add(new OptionValue(x.getLabel(), (string)x.getValue(), x.isSelected()));
        }
        return JSON.serializePretty(options);
    }
    
    @AuraEnabled
    public static String funFlow(string flowname) {
        
        List<Flow.Interview> flows = new List<Flow.Interview> {
            Flow.Interview.createInterview(
                flowname,
                new Map<String, List<SOBject>>()),
            Flow.Interview.createInterview(
                flowname,
                new Map<String, List<SOBject>>())            
        };
            
        flows[0].start();
        string targetobject = (String)flows[0].getVariableValue('targetobject');
        List<SObject> objlist = Database.query('SELECT Name, Id FROM ' + targetobject);
        flows[1] = Flow.Interview.createInterview(flowname, new Map<String, List<SOBject>> { 'SomeRecords' => objlist});

        String output = '\n';
        for (SObject a : objlist) {
            output += targetobject + ' name:  ' + a.get('Name') + '\n';
        }
        System.debug(output);
        flows[1].start();
        List<Sobject> objects = (List<SObject>)flows[1].getVariableValue('FilteredAccounts');
		System.debug(PickTest__mdt.Flows__c);
        System.debug(objects.size() + ' filtered records...');
        output = '\n';
        List<ReturnValue> returnVal = new List<ReturnValue>();
        for (SObject a : objects) {
            returnVal.add(new ReturnValue((string)a.get('Id'), (string)a.get('Name')));
            output += targetobject + ' name: ' + a.get('Name') + '\n';
        }
        System.debug(output);
        return JSON.serializePretty(returnVal);
    }
    
    private class OptionValue {
        private string label;
        private string id;
        private boolean selected;

        private OptionValue(string labelval, string idval, boolean isselected) {
            this.label = labelval;
            this.id = idval;
            this.selected = false;
        }
    }
    
    private class ReturnValue {
        private string Id;
        private string Name;
        
        private ReturnValue(string idval, string nameval) {
            this.Id = idval;
            this.Name = nameval;
        }
    }
}