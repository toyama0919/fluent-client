# fluent-client

fluentd command line utility

## Examples

### simple post to fluentd

    $ fluent-client --post sometag --data id:1 name:toyama
    #=> 2014-09-14 17:43:40 +0900 sometag: {"id":"1","name":"toyama"}

### simple post to fluentd other host

    $ fluent-client --post sometag --data id:1 name:toyama -h aggregate-host -p 24223

### post stdin json

    $ echo '[{"hoge":"fuga"},{"hoge":"fuga2"}]' | fluent-client -j sometag
    #=> 2014-09-14 22:30:26 +0900 sometag: {"hoge":"fuga"}
    #=> 2014-09-14 22:30:26 +0900 sometag: {"hoge":"fuga2"}

### post stdin file with regular expression

    $ cat server.csv
    i-xxxxxxx web01 running
    i-xxxxxxx web02 running
    i-xxxxxxx web03 running
    i-xxxxxxx web04 running
    i-xxxxxxx batch01 running

    $ cat server.txt | fluent-client post_parse_text sometag --format "/^(?<instance_id>[^ ]*) (?<name>[^ ]*) (?<state>[^ ]*)$/"
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web01", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web02", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web03", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web04", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"batch01", "state"=>"running"}

※ multiline not support

### post stdin csv file

    $ cat server.csv
    i-xxxxxxx,web01,running
    i-xxxxxxx,web02,running
    i-xxxxxxx,web03,running
    i-xxxxxxx,web04,running
    i-xxxxxxx,batch01,running

    $ cat server.csv | fluent-client post_parse_text sometag --format csv --keys instance_id,name,state
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web01", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web02", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web03", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"web04", "state"=>"running"}
    #=> {"instance_id"=>"i-xxxxxxx", "name"=>"batch01", "state"=>"running"}



## default values

default host: localhost

default port: 24224


## Installation

Add this line to your application's Gemfile:

    gem 'fluent-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-client

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Information

* [Homepage](https://github.com/toyama0919/fluent-client)
* [Issues](https://github.com/toyama0919/fluent-client/issues)
* [Documentation](http://rubydoc.info/gems/fluent-client/frames)
* [Email](mailto:toyama0919@gmail.com)

## Copyright

Copyright (c) 2014 Hiroshi Toyama

See [LICENSE.txt](../LICENSE.txt) for details.
