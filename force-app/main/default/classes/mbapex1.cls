public class mbapex1 {

public static void welcomeMessage() {
        System.debug('Welcome to the contact management app.');
    }

    public static List<Account> listAccounts(){
        return [SELECT Id, Name FROM Account];
    }


}

