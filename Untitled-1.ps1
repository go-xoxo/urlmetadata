# Install the Google API Client Library for .NET
Install-Package Google.Apis -Version 1.49.0

# Import the required namespaces
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using Google.Apis.Util.Store;
using System;
using System.IO;
using System.Threading;f

# Set the scopes for the Google API
string[] scopes = { "https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile" };

# Set the credentials for the Google API
UserCredential credential;
using (var stream = new FileStream("client_secrets.json", FileMode.Open, FileAccess.Read))
{
    string credPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Personal);
    credPath = Path.Combine(credPath, ".credentials/google-search-2fa.json");

    credential = GoogleWebAuthorizationBroker.AuthorizeAsync(
        GoogleClientSecrets.Load(stream).Secrets,
        scopes,
        "user",
        CancellationToken.None,
        new FileDataStore(credPath, true)).Result;
}

# Create the Google search service
var service = new Google.Apis.Customsearch.v1.CustomsearchService(new BaseClientService.Initializer()
{
    HttpClientInitializer = credential,
    ApplicationName = "Google Search"
});

# Set the query parameters for the Google search
var listRequest = service.Cse.List("search query");
listRequest.Cx = "search engine id";
listRequest.Num = 10;

# Execute the Google search
var search = listRequest.Execute();
foreach (var result in search.Items)
{
    Console.WriteLine(result.Title);
    Console.WriteLine(result.Link);
    Console.WriteLine(result.Snippet);
}
