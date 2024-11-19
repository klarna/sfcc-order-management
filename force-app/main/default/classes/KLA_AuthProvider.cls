public class KLA_AuthProvider {
    private ApiSettings__mdt serviceSettings;

    public KLA_AuthProvider (ApiSettings__mdt serviceSettings) {
        this.serviceSettings = serviceSettings;
    }
    public String getBasicToken() {
        KLA_AccessSetting__c AccessCS = KLA_AccessSetting__c.getOrgDefaults();
        return AccessCS.Page_Access_Token__c;
	}
}