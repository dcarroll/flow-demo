public with sharing class FlowUtility {
    public FlowUtility() {

    }

    public static string disassembleSObject(List<SObject> objects) {
        Schema.SObjectType objType = objects.getSObjectType();
        Map<String, Schema.SObjectField> fields = objType.getDescribe().fields.getMap();

        String output = '';
        if (objects.size() > 0) {
            output = JSON.serializePretty(new DynamicResults(objects, getColumns(objects[0], fields)));
        }
        return output;
    }

    public static string validateFieldList(string sobjectType, string fieldList) {
        // Get describe for passed in sobject type name
        Schema.DescribeSObjectResult[] descResults = Schema.describeSObjects(new String[]{sobjectType});
        // Convert the fieldlist keys to lower case
        Map<String, String> lcaseFieldList = new Map<String, String>();
        List<String> invalidFields = new List<String>();
        // Make sure that we have valid describe results
        if (descResults != null && descResults.size() > 0) {
            Schema.DescribeSObjectResult descResult = descResults[0];
            // Get a map of the fields on the sobject
            Map<String, Schema.SObjectField> fields = descResult.fields.getMap();
            // Convert to lower case so that we have a case insensitive comparison
            for (String key : fields.keySet()) {
                System.debug('\n' + key);
                lcaseFieldList.put(fields.get(key).getDescribe().getName().toLowerCase(), key);
            }
            // Turn the field list to validate into an array
            List<String> flist = fieldList.split(',');
            for (String fname : flist) {
                // Look to see if the field name is a key in the case insensitive map,
                // if it isn't, then add it to the list of invaled fields to be returned
                // to the colling code.
                if (!lcaseFieldList.containsKey(fname.toLowerCase())) {
                    invalidFields.add(fname);
                }
            }
        }
        System.debug('Validate: ' + JSON.serialize(invalidFields));
        return JSON.serialize(invalidFields);
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

}
