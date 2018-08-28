// FlowController.TAFlow('Team_America_Email');
// FlowController.disassembleSObject((List<SObject>)[Select Id, Name, Email From Contact]);
System.debug(FlowController.validateFieldList('Contact', 'Name,Email,OutOfOfficeMessage'));