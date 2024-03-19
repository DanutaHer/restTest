@RestResource(urlMapping='/Cases/*')
global without sharing class CaseManager {

    @HttpGet
    global static Case getCaseById() {
        RestRequest request = RestContext.request;
        String caseFromUri = request.requestURI.substring(request.requestURI.lastIndexOf('Cases/')+6);
        Id caseId = Id.valueOf(caseFromUri);

        if(caseId.getSobjectType() == Case.getSObjectType()){
            Case result;
            List<Case> cases = [SELECT CaseNumber,Subject,Status,Origin,Priority
                            FROM Case
                            WHERE Id = :caseId];
            if(!cases.isEmpty()){
                result = cases[0];
            }
            return result;
        } else {
            throw new CaseManagerException('Provided id is not correct');
        }
    }

    @HttpPost
    global static Id createCase() {
        RestRequest request = RestContext.request;
        Blob body = request.requestBody;
        Map<String,Object> params = (Map<String,Object>) JSON.deserializeUntyped(body.toString());
        Case newCase = new Case();

        for(String field: params.keySet()){
            newCase.put(field, params.get(field));
        }
        insert newCase;
        return newCase.Id;
    } 

    @HttpDelete
    global static Id deleteCase() {
        RestRequest request = RestContext.request;
        String caseFromUri = request.requestURI.substring(request.requestURI.lastIndexOf('Cases/')+6);
        Id caseId = Id.valueOf(caseFromUri);

        if(caseId.getSobjectType() == Case.getSObjectType()){
            List<Case> cases = [SELECT Id 
                                FROM Case 
                                WHERE Id = :caseId];
            delete cases;
            return caseId;
        } else {
            throw new CaseManagerException('Provided id is not correct');
        }
    }     

    @HttpPut
    global static Id upsertCase() {
        RestRequest request = RestContext.request;
        Blob body = request.requestBody;
        Map<String,Object> params = (Map<String,Object>) JSON.deserializeUntyped(body.toString());
        Case thisCase = new Case();

        for(String field: params.keySet()){
            thisCase.put(field, params.get(field));
        }
           
        upsert thisCase;  
        return thisCase.Id;
    }

    @HttpPatch
    global static Id updateCaseFields() {
        RestRequest request = RestContext.request;
        String caseFromUri = request.requestURI.substring(request.requestURI.lastIndexOf('Cases/')+6);
        Id caseId = Id.valueOf(caseFromUri);

        if(caseId.getSobjectType() == Case.getSObjectType()){
            List<Case> cases = [SELECT Id 
                                FROM Case 
                                WHERE Id = :caseId];
            Case thisCase = cases[0];
            Blob body = request.requestBody;
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(body.tostring());
            
            for(String fieldName : params.keySet()) {
                thisCase.put(fieldName, params.get(fieldName));
            } 

            update thisCase;
            return thisCase.Id;    
        } else {
            throw new CaseManagerException('Provided id is not correct');
        }
    }  

    public class CaseManagerException extends Exception{}
}