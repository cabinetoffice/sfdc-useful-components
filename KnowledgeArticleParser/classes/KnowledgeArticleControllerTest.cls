@IsTest
public class KnowledgeArticleControllerTest 
{
    public static testMethod void RunTest()
    {
        Knowledge_Article__c ka = new Knowledge_Article__c();
        ka.Name = 'Test Article';
        ka.Description__c = 'CONTENT [video:test123.mp4] CONTENT';
        insert ka;
        
        ContentVersion cv = new ContentVersion();
        cv.FirstPublishLocationId = ka.Id;
        cv.Title = 'test123.mp4';
        cv.VersionData = Blob.valueOf('null');
        cv.PathOnClient = 'test123.mp4';
        insert cv;
        
        system.assertEquals('CONTENT <video controls src="/sfc/servlet.shepherd/version/download/' + cv.Id + '" style="width:100%; height:auto;"></video> CONTENT', KnowledgeArticleController.getContent(ka.Id));
        
    }
}