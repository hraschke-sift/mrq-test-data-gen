# mrq-test-data-gen
scripted data generator for manual review queue testing

# Usage

This script is designed to automate the process of making requests. It uses command line options to take arguments and makes multiple requests based on the quantity specified.

Entity type, environment, and number of entities must be passed each time. API key can be set once and it will be remembered.

## Usage

```bash
sh ./mrq-test-data-gen.sh  -t entity_type -e environment -q number_of_entities -a api_key
