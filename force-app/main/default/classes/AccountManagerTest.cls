@isTest
public class AccountManagerTest {
    
    @isTest
    public static void getTestForAccount(){
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Accounts/'
            + recordId + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Account thisAccount = AccountManager.getAccount();
        Assert.areNotEqual(null, thisAccount);
        
        Contact cont = [SELECT Id, Name FROM Contact WHERE AccountId =: thisAccount.Id];
        Assert.areEqual('Test account', thisAccount.name);
        Assert.areEqual('Test contact', cont.Name);
    }
    
	static Id createTestRecord() {
        Account accountTest = new Account(
            Name='Test account', AccountNumber = '12345678');
        insert accountTest;
        Contact contactTest = new Contact(
            LastName='Test contact', AccountId = accountTest.Id);
        insert contactTest;
        return accountTest.Id;
    }          
}