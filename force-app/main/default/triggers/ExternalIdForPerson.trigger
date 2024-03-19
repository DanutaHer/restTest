trigger ExternalIdForPerson on Person__c (before insert, before update) {

        ExternalIdForPerson.updatePersonWithExternalId(Trigger.New);
}