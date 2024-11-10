@isTest
public class mbapex1Test {
    
    @isTest static void testGetAccounts() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            Account a = new Account(Name = 'Test Account ' + i);
            accounts.add(a);
        }
        insert accounts;

        mbapex1 mba = new mbapex1();
        List<Account> testAccounts = mba.getAccounts();

        System.assertEquals(testAccounts.size(), 10);
    }

}