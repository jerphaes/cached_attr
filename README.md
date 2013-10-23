# Introduction
Enables you to create a ruby object attribute whose value which is cached between invocations.
Use cases are methods/attributes rerieval which can be cached for the lifetime of an object, but
* they have poor performance
* are just silly to execute each time

## Installation
```
gem install cached_attr
```

## Usage
Just a few examples:

``` ruby
require 'cached_attr'

class Store
    include CachedAttr

    cached_attr :orders do
        # ... SELECT * FROM ORDERS
    end

    # Time to live for a cached item
    cached_attr :order_items, :ttl => 1.minute do
        # ... SELECT * FROM ORDER_ITEMS
    end

    # Invoke a method instead of a block
    cached_attr :items, :method => :get_items

    # Also create a writer method
    cached_attr :clients, :writer => true do
        # ....
    end

    def get_items
        ....
    end

end
```

Additionally, for each cached_attr, a few helper methods are created:
``` ruby
class Store
    include CachedAttr

    cached_attr :orders, :ttl => 1.minute do
        # ... SELECT * FROM ORDERS
    end
end
store = Store.new
store._orders_expires # The expiry time of the cached value
store._orders_call_count # The number of times the attribute is read
store._orders_invoke_count # The number of times the cached item is re-initialized
store._orders_reset! # Reset the cache
```