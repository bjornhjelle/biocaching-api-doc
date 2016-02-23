#REST-API for Biocaching

This page documents the Biocaching REST-based APIs. To access Biocaching through the API you also need a username and a password. If you have that, you can invoke the API with curl on the command line: 

    curl  -H 'Content-Type: application/json' -H 'Accept: application/json' \
      -X POST "http://api.biocaching.com:82/users/sign_in" \
      -d '{"user" : { "email" : "bjorn@biocaching.com", "password" : "<PASSWORD>"}}' \

If successful, the command will return something like this: 

    {"id":1,"email":"bjorn@biocaching.com","created_at":"2016-02-16T12:36:44.000Z",
    "updated_at":"2016-02-17T13:22:08.320Z","authentication_token":"zCC868dPzS2Gp1y-UE1M"}

The token can then be used to invoke further services, for example list available taxonomies: 

    curl  -H 'Content-Type: application/json' -H 'Accept: application/json' \
    -H 'X-User-Email: bjorn@biocaching.com' -H 'X-User-Token: zCC868dPzS2Gp1y-UE1M' \
    -X GET "http://api.biocaching.com:82/api/taxonomies" 

Also see the example programs provided.
All requests must use Content-Type application/json and must accept a response in the same content type. 


##Taxonomies
The Taxonomies service gives a list of the taxonomies in the Species database.

    GET /api/taxonomies

## Retreieve a subset of taxa
The Taxa services give access to the species database.

    GET /api/taxonomies/<taxonomy_id>/taxa

Retrieves taxa from a specific taxonomy in json format.

Called with no extra parameters, this service returns the taxa with rank "kingdom".

### Optional parameters

| Parameter  | Description |
| ------------- | ------------- |
| from  | Return a subset of the taxa, start at 'from', default = 0  |
| size | Return 'size' number of taxa, default = 10  |
| parent_id | Return taxa that are immediate children of another taxa. If omitted, return taxa on the highest level (the kingdoms: animalia, plantae and fungi) |
| fields | If omitted, only a subsets of the available fields are included in the response. Pass value "all" to have all available fields returned |
| region | Only return taxa that are found in a specific region. E.g. ®ion=nor |
|  |  |


### Examples

Get taxa without parents (the kingdoms):

    GET /api/taxonomies/1/taxa

Get all 35 taxa in the animal kingdom:

    GET /api/taxonomies/1/taxa?parent_id=1&size=40

Get all taxa in the chordata phylum:

    GET /api/taxonomies/1/taxa?parent_id=11&size=40

## Retrieve a single taxon

    GET /api/taxonomies/<taxonomy_id>/taxa/<taxa_id>

Retrieves one specific taxa.

### Optional parameters

| Parameter  | Description |
| ------------- | ------------- |
| fields | If omitted, only a subsets of the available fields are included in the response. Pass value "all" to have all available fields returned |

## Search for taxa
Search for taxa

    GET /api/taxonomies/<taxonomy_id>/taxa/search?term=<search_term>

Search, by name, for taxa in a specific taxonomy.


### Parameters

| Parameter  | Description |
| ------------- | ------------- |
| term  |  Search for search_term in scientific and common names of taxa with rank genus, species and infraspecific.  |

### Optional parameters

| Parameter  | Description |
| ------------- | ------------- |
| from  | Return a subset of the taxa, start at 'from', default = 0  |
| size | Return 'size' number of taxa, default = 10  |
| below_rank, below_rank_value | return only taxa below a certain rank in the taxonomy.|
| fields | If omitted, only a subsets of the available fields are included in the response. Pass value "all" to have all available fields returned |
| region | Only return taxa that are found in a specific region. For now, only region "nor" is available |
| languages | Only return taxa that have common names in one of the specified languages (ISO 639-2), default is "eng" |


### Examples

Get the 5 first species in the mammalia class (mammals):

    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=mammalia&size=5

Get the 5 next species in the mammalia class (mammals):

    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=mammalia&size=5&from=5

Search for birds named something with "meis" in Norwegian bokmål or nynorsk, return at most 10 results:

    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=aves&size=10&term=meis&languages=nob,nno

## Observations

Retrieve observations

   GET /api/observations.json

Get a listing of observations

### Optional parameters

| Parameter  | Description |
| ------------- | ------------- |
| all  | Get observations regardless of user. Without this only the authenticated user's observations are returned.  |
| latitude  | Latitude |
| longitude  | Longitude |
| distance  | Get observations from within distance from the location given by the latitude and longitude coordinates. See this for allowed formats: https://www.elastic.co/guide/en/elasticsearch/reference/1.4/common-options.html#distance-units  |


### Examples

Get all observations with 20km from a location:
    
    GET /api/observations.json?all=true&latitude=61&longitude=12.4&distance=20km

## Create an observation

  POST /api/observations
  
Creates an observation with date/time, location, a taxon and a picture. 

### Parameters

| Parameter | Description |
| ------------- | ------------- |
| taxon_id | The id of the taxon observed, as returned by the taxa-servies |
| observed_at | Date and time in ISO 8601 format, e g "2016-02-19 13:50:58 +0100" |
| latitude | The latitude of the location |
| longitude | The longitude of the location |
| comments | A free text comment |
| picture[content_type] | Content type of the picture, e g "image/jpg" |
| picture[headers] |  |
| picture[original_filename] |  |
| picture[tempfile] |  |

The parameters must be supplied as the content of the HTTP POST in a JSON hash with key "observation". 
See example programs for details (create_observation.rb)   

Ikke lagd:
GET /taxa/<id>?format=json

Retrieves a single species, given it's id.
