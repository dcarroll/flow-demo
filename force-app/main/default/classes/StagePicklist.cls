global class StagePicklist extends VisualEditor.DynamicPickList{
    
    private VisualEditor.DataRow defaultValue;
    private VisualEditor.DynamicPickListRows myValues;
    
    global override VisualEditor.DataRow getDefaultValue(){
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        Schema.DescribeFieldResult p = Opportunity.StageName.getDescribe(); // PickTest__mdt.Flows__c.getDescribe();
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        myValues = new VisualEditor.DynamicPickListRows();
        for (PicklistEntry plentry : p.getPicklistValues()) {
            if (plentry.isDefaultValue()) {
                defaultValue = new VisualEditor.DataRow(plentry.getLabel(), plentry.getValue());
                myValues.addRow(defaultValue);
            } else {
	            myValues.addRow(new VisualEditor.DataRow(plentry.getLabel(), plentry.getValue()));
            }
        }
        return myValues;
    }
}