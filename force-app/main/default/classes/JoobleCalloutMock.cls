public class JoobleCalloutMock implements HttpCalloutMock {
    
    public static HTTPResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);

        String responseBody = 
            '{' +
                '"jobs": [' +
                    '{' +
                        '"title": "Salesforce Developer",' +
                        '"location": "Boulder, CO",' +
                        '"salary": "$100000",' +
                        '"source": "Jooble",' +
                        '"type": "Full-time",' +
                        '"link": "https://example.com/job/123",' +
                        '"company": "Tech Co",' +
                    '}' +
                ']' +
            '}';

        response.setBody(responseBody);
        return response;
    }
}
