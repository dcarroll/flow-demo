public with sharing class FlowController {
     
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
        return JSON.serialize(FlowUtility.disassembleSObject(userList));
    }

    @AuraEnabled
    public static string validateFieldList(string sobjectType, string fieldList) {
        return FlowUtility.validateFieldList(sobjectType, fieldList);
    }
}