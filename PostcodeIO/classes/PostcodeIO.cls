public class PostcodeIO
{
	public static PCIO_Result retrievePostCodeDetails(string input)
	{
		// trim it
		input = input.replaceAll(' ', '');
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://postcodes.io/postcodes/' + input);
		request.setMethod('GET');
		Http http = new Http();
		HttpResponse resp = http.send(request);
		PCIO_Response data = (PCIO_Response)JSON.deserialize(resp.getBody(), PCIO_Response.class);
		if(data.status != 200)
		{
			throw new PostcodeNotFoundException('Invalid postcode');
		}
		return data.result;
	}
	public class PostcodeNotFoundException extends Exception{}
	public class PCIO_Response
	{
		public integer status;
		public string error;
		public PCIO_Result result;
	}
	public class PCIO_Result
	{
		public string postcode;
		public Integer quality;
		public Integer eastings;
		public Integer northings;
		public string country;
		public string nhs_ha;
		public Decimal longitude;
		public Decimal latitude;
		public string parliamentary_constituency;
		public string european_electoral_region;
		public string primary_care_trust;
		public string region;
		public string lsoa;
		public string msoa;
		public string incode;
		public string outcode;
		public string admin_district;
		public string parish;
		public string admin_county;
		public string admin_ward;
		public string ccg;
		public string nuts;
	}
	public static PCIO_Result generateMockResult(){
		PostcodeIO.PCIO_Result mockResult = new PostcodeIO.PCIO_Result();
		mockResult.postcode = 'SW1A 2HQ';
		mockResult.quality = 1;
		mockResult.eastings = 529096;
		mockResult.northings = 187084;
		mockResult.country = 'England';
		mockResult.nhs_ha = 'London';
		mockResult.longitude = -0.138776253708989;
		mockResult.latitude = 51.567859622079;
		mockResult.parliamentary_constituency = 'Islington North';
		mockResult.european_electoral_region = 'London';
		mockResult.primary_care_trust = 'Islington';
		mockResult.region = 'London';
		mockResult.lsoa = 'Islington 004B';
		mockResult.msoa = 'Islington 004';
		mockResult.incode = '5NL';
		mockResult.outcode = 'N19';
		mockResult.admin_district = 'Islington';
		mockResult.parish = 'Islington, unparished area';
		mockResult.admin_county = null;
		mockResult.admin_ward = 'Junction';
		mockResult.ccg = 'NHS Islington';
		mockResult.nuts = 'Haringey and Islington';
		return mockResult;
	}
}