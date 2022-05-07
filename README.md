# FTS (Full Text Search) in Ruby

This project implements a full text search by product name from a list of
products in JSON.

### Installation

```ruby
bundle
```

### Usage

```ruby
ruby search.rb <WORD1> <WORD2> ...
```

### Tests

```ruby
rspec
```

### Benchmark

Using a 32GB Macbook Pro with M1 MAX.

```bash
# using products.json (129 products)
ruby search.rb Durable  0.06s user 0.08s system 99% cpu 0.135 total

# using products_big.json (16_384 products)
ruby search.rb Durable  0.10s user 0.08s system 95% cpu 0.189 total
```
