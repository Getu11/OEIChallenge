# Course Selection API

A Rails API for selecting and filtering course editions based on multiple criteria.

------------------------------------------------------------------------

## Features

-   Filter courses by date (`closest`, `latest`), school (`school-XYZ`) and type (`type-XYZ`).\
-   Includes **RSpec request tests**.

------------------------------------------------------------------------

## Setup

``` bash
git clone https://github.com/Getu11/OEIChallenge.git
cd OEIChallenge
bundle install
```

Start the Rails server:

``` bash
bin/rails server
```

------------------------------------------------------------------------

## Usage

### Example Request

The example included has the `test-case1.sh` script updated
NOTE: the script had a `unknown operator` error (probably because I used ZSH), the original file is `test-case1-original.sh`. 
``` bash
./test-case1.sh
Test 1 : [  OK  ]
Test 2 : [  OK  ]
Test 3 : [  OK  ]
Test 4 : [  OK  ]
```
------------------------------------------------------------------------

## Testing

Run all tests:

``` bash
bundle exec rspec --format documentation
```

Example output:
``` bash
Course Selection API
  criteria: closest
    selects the edition with the earliest future date
  criteria: latest
    selects the edition with the furthest future date
  criteria: type-name
    filters courses by given type
  criteria: school-name
    filters courses by school
  ...
```
