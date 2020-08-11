public class KnowledgeArticleController 
{
    @AuraEnabled
    public static string getContent(Id recordId)
    {
        Knowledge_Article__c ka = [SELECT Id, Description__c FROM Knowledge_Article__c WHERE Id = :recordId];
        return parseVideoTag(ka.Id, ka.Description__c);
    }

	private static string sanitizeVideoTitle(string title)
    {
        return title.toLowerCase().trim();
    }
    
	public static string parseVideoTag(Id id, string text)
    {                
        // Get all our MP4s.
        List<ContentDocumentLink> cdls = [SELECT Id, ContentDocument.Title, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocument.FileType = 'MP4' AND LinkedEntityId = :id];
        Set<Id> cvIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdls)
        {
            cvIds.add(cdl.ContentDocumentId);
        }
        
        List<ContentVersion> files = [SELECT Id, Title FROM ContentVersion 
                WHERE ContentDocumentId IN :cvIds
                AND FileType = 'MP4'
                AND IsLatest = true];
                
        // Build a map of MP4 title to ID.
        Map<string, Id> documents = new Map<string, Id>();   
        for (ContentVersion file : files)
        {
            documents.put(sanitizeVideoTitle(file.Title), file.Id);
        }
        
        string needle = '[video:';
        integer start = text.indexOfIgnoreCase(needle, 0);
        
        string template = '<video controls src="/sfc/servlet.shepherd/version/download/{{id}}" style="width:{{width}}; height:{{height}};"></video>';
        string result = text;
        
        do
        {
            integer endtok = text.indexOfIgnoreCase(']', start)+1;
            if (endtok == -1)
            {
                return result;
            }
            
            // Extract and sanitize the tag
            string tag = text.substring(start, endtok);
            string sanitized = tag;
            sanitized = sanitized.removeStartIgnoreCase(needle);
            sanitized = sanitized.removeEndIgnoreCase(']');
            sanitized = sanitized.replace(' ', '');
            system.debug(sanitized);
            
            string[] arguments = sanitized.split(',');
            string out = template;
            
            if (arguments.size() == 0)
            {
                out = '<b>[ERROR LOADING VIDEO: No arguments, format must be video,width,height]</b>';
           		result = result.replace(tag, out);
                start = text.indexOfIgnoreCase(needle, start+1);
                continue;
            }
            
            
            // Get the video ID.
            string video = sanitizeVideoTitle(arguments[0]);
            if (!documents.containsKey(video))
            {
                out = '<b>[ERROR LOADING VIDEO: No file named ' + video +' attached.]</b>';
                result = result.replace(tag, out);
                start = text.indexOfIgnoreCase(needle, start+1);
                continue;
            }
            out = out.replace('{{id}}', documents.get(video));
            
            
            // Get the width, if specified.
            if (arguments.size() >= 2)
            {
            	out = out.replace('{{width}}', arguments[1]);
            }
            else
            {
                out = out.replace('{{width}}', '100%');
            }
            
            
            // Get the height, if specified.
            if (arguments.size() >= 3)
            {
            	out = out.replace('{{height}}', arguments[2]);
            }
            else
            {
                out = out.replace('{{height}}', 'auto');
            }
            
            system.debug('Replacing ' + tag + ' with ' + out);
            result = result.replace(tag, out);
            
            // Set our pointer
            start = text.indexOfIgnoreCase(needle, start+1);
        }
        while (start != -1);
        
        system.debug(result);
        return result;
    }
}