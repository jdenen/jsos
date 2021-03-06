# CHANGELOG

## v1.2.1 (Feb 08, 2016)
* Hashes are converted into JSOS objects when part of an array value

```ruby
json = "{\"foo\":[{\"foo\":\"bar\"}, \"baz\"]}"
jsos = JSOS.new(json)

jsos.foo
#=> ["#<JSOS foo=\"bar\">", "baz"]

jsos.foo.first.foo
#=> "bar"
```

## v1.2.0 (Jan 13, 2016)
* Add `JSOS#to_a`
* Alias `JSOS#to_a` to `JSOS#to_ary`

## v1.1.0 (Jan 12, 2016)
* Add `JSOS#each`

## v1.0.1 (Jan 07, 2016)
* Fix issue where initial nested data was not converted into new JSOS objects (#1)
* Create CHANGELOG

## v1.0.0 (Dec 31, 2015)
* Initial release
