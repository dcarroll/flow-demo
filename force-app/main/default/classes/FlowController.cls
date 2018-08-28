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
     
    public static void test() {
        
    }

    @AuraEnabled
    public static String TAFlow(string flowname) {
        
        Flow.Interview flow = Flow.Interview.createInterview(
                flowname,
                new Map<String, List<SOBject>>());           
            
        flow.start();
        String output = '\nObjects returned: \n';
        List<Sobject> groupMembers = (List<SObject>)flow.getVariableValue('TAGroupMembers');
        List<Sobject> groups = (List<SObject>)flow.getVariableValue('TAGroups');
        List<Sobject> userList = (List<SObject>)flow.getVariableValue('TAUserList');
        List<String> emailList = (List<String>)flow.getVariableValue('EmailList');
        output += 'TAGroups: ' + groups + '\n';
        output += 'TAGroupMembers: ' + groupMembers + '\n';
        output += 'TAUserList: ' + userList + '\n';
        output += 'EmailList: ' + emailList + '\n';
        System.debug(output);
        return JSON.serialize(disassembleSObject(userList));
    }

    private static string disassembleSObject(List<SObject> objects) {
        Schema.SObjectType objType = objects.getSObjectType();
        Map<String, Schema.SObjectField> fields = objType.getDescribe().fields.getMap();

        String output = '';
        if (objects.size() > 0) {
            output = JSON.serializePretty(new DynamicResults(objects, getColumns(objects[0], fields)));
        }
        return output;
    }

    private static List<Column> getColumns(SObject obj, Map<String, Schema.SObjectField> fields) {
        Map<String, Object> fieldMap = obj.getPopulatedFieldsAsMap();
        String output = '';
        List<Column> cols = new List<Column>();
        for (String fieldName : fieldMap.keySet()) {
            Object f = fieldMap.get(fieldName);
            cols.add(new Column(fieldname, fields.get(fieldName).getDescribe().getLabel(), lookupTypeAssociation(fields.get(fieldName).getDescribe().getType()) + ''));
            
            output += 'Fieldname: ' + fieldName + ', Fieldvalue: ' + f + ', Fieldtype: ' + fields.get(fieldName).getDescribe().getType() + '\n';
        }
        System.debug('\n\n' + output + '\n');
        return cols;
    }

    private class DynamicResults {
        List<SObject> records = new List<SObject>();
        List<Column> columns = new List<Column>();

        private DynamicResults(List<SObject> recs, List<Column> cols) {
            records = recs;
            columns = cols;
        }
    }

    private class Column {
        String fieldName;
        String label;
        String type;

        private Column(String fldName, String lbl, String fldType) {
            fieldName = fldName;
            label = lbl;
            type = fldType;
        }
    }

    private static string lookupTypeAssociation(Schema.DisplayType t) {
        switch on t {
           when EMAIL {
               return 'email';
           }
           when STRING, TEXTAREA {
               return 'text';
           }
           when DOUBLE {
               return 'number';
           }
           when PHONE {
               return 'phone';
           }
           when DATE, DATETIME {
               return 'date';
           }
           when URL {
               return 'url';
           }
           when LOCATION {
               return 'location';
           }
           when else {
               return 'text';
           }
        }
    }

    /*private private enum MyEnum {
        ID,
         BOOLEAN,
        REFERENCE,
         STRING,
        PICKLIST,
        TEXTAREA,
         DOUBLE,
        ADDRESS,
         PHONE,
         EMAIL,
         DATE,
         DATETIME,
         URL,
         LOCATION
    }*/
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