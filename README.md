#REST-API for Biocaching

This page documents the Biocaching REST-based APIs.

##Taxonomies
The Taxonomies service gives a list of the taxonomies in the Species database.

    GET /api/taxonomies?format=json

## Taxa
The Taxa services give access to the species database.

    GET /taxonomies/<taxonomy_id>/taxa

Retrieves taxa from a specific taxonomy in json format.

Called with no extra parameters, this service returns the taxa with rank "kingdom".
Optional parameters

from
    Return a subset of the taxa, start at 'from', default = 0
size
    Return 'size' number of taxa, default = 10
parent_id
    Return taxa that are immediate children of another taxa. If omitted, return taxa on the highest level (the kingdoms: animalia, plantae and fungi)
fields
    If omitted, only a subsets of the available fields are included in the response. Pass value "all" to have all available fields returned
region
    Only return taxa that are found in a specific region. E.g. ®ion=nor

Examples

Get taxa without parents (the kingdoms):
    GET /api/taxonomies/1/taxa
Get all 35 taxa in the animal kingdom:
    GET /api/taxonomies/1/taxa?parent_id=1&size=40
Get all taxa in the chordata phylum:
    GET /api/taxonomies/1/taxa?parent_id=11&size=40

GET /taxonomies/<taxonomy_id>/taxa/search?term=<search_term>

Search, by name, for taxa in a specific taxonomy.
Optional parameters

term
    Search for search_term in scientific and common names of taxa with rank genus, species and infraspecific. If omitted, all taxa are returned
from
    Return a subset of the taxa, start at 'from', default = 0
size
    Return 'size' number of taxa, default = 10
below_rank, below_rank_value
    return only taxa below a certain rank in the taxonomy. E. g.: to only retrieve birds add parameters: below_rank=class and below_rank_value=aves
fields
    If omitted, only a subsets of the available fields are included in the response. Pass value "all" to have all available fields returned
language
    Only return taxa that have common names in the specified language (ISO 639-2). E.g. &language=fra, default is eng
region
    Only return taxa that are found in a specific region. E.g. ®ion=nor

Examples

Get the 5 first species in the mammalia class (mammals):
    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=mammalia&size=5
Get the 5 next species in the mammalia class (mammals):
    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=mammalia&size=5&from=5
Search for birds named something with "fody", return at most 10 results:
    GET /api/taxonomies/1/taxa/search?below_rank=class&below_rank_value=aves&size=10&term=fody

GET /api/observations.json?all=true

Get a listing of observations
Optional parameters

all
    Get observations regardless of user. Without this only the authenticated user's observations are returned.

Examples

Get observations:
    GET /api/observations.json?all=true

Ikke lagd:
GET /taxa/<id>?format=json

Retrieves a single species, given it's id.@
