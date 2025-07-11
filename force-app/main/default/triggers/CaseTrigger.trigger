trigger CaseTrigger on Case (after insert,after update) { 
    CaseTriggerHandler handler = new CaseTriggerHandler();
    if (Trigger.isAfter) {
        if (Trigger.isInsert) { 
            handler.handleAfterInsert(Trigger.New);
        } else if (Trigger.isUpdate) {
            handler.handleAfterUpdate(Trigger.New, Trigger.oldMap);
        }
    }

}