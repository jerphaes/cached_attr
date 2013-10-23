# This module implements attributes whose reader method executes once, and the returned value is cached for later use.
# This might be handy for expensive operations.
#
# An example, given the following method:
#
# def object_to_get
#   if @object_to_get.nil?
#     @object_to_get = [code_to_retrieve_object]
#   end
#   @object_to_get
# end
#
# ...the cached attribute format would be:
#
# cache_attr :object_to_get do
#   [code_to_retrieve_object]
# end
module CachedAttr

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    # Defines an attribute on the including class.
    #
    # @param name [Symbol] the name of the attribute
    # @param options [Hash] options
    # @option options :writer if set to true, also define a writer method for the property
    # @option options :ttl the time to live for a value. Ignored if nil or false
    # @option options :method the method to call if no block is given
    def cached_attr(name, options = {}, &block)
      default_opts = {
          :writer => false,
          :method => false,
          :ttl => false
      }
      opts = default_opts.merge(options)

      class_eval do
        internal_retrieve_method = "__internal_retrieve_#{name}".to_sym
        define_method(internal_retrieve_method) do
          if block.nil?
            val = self.send(opts[:method])
          else
            val = self.instance_exec(&block)
          end
          cached_attributes_store[name][:invoke_count] += 1
          val
        end
        internal_init_method = "__internal_init_#{name}".to_sym
        define_method(internal_init_method) do |val = nil|
          unless cached_attributes_store.has_key?(name)
            cached_attributes_store[name] = {:call_count => 0, :invoke_count => 0}
            if val.nil?
              cached_attributes_store[name][:value] = self.send(internal_retrieve_method)
              cached_attributes_store[name][:expires] = Time.now + opts[:ttl] if opts[:ttl]

            else
              cached_attributes_store[name][:value] = val
            end
          end
          cached_attributes_store[name]
        end


        define_method("_#{name}_reset!".to_sym) do
          cached_attributes_store.delete(name)
        end

        define_method("_#{name}_expires".to_sym) do
          self.send(internal_init_method)[:expires]
        end

        define_method("_#{name}_call_count".to_sym) do
          self.send(internal_init_method)[:call_count]
        end

        define_method("_#{name}_invoke_count".to_sym) do
          self.send(internal_init_method)[:invoke_count]
        end

        define_method(name) do

          cache_val = self.send(internal_init_method)

          if opts[:ttl] && cache_val[:expires] && Time.now > cache_val[:expires]
            cache_val[:value] = self.send(internal_retrieve_method)
            cache_val[:expires] = Time.now + opts[:ttl]
          end

          cache_val[:call_count] = cached_attributes_store[name][:call_count] + 1
          cache_val[:value]
        end

        if opts[:writer]
          define_method("#{name}=") do |val|
            self.send(internal_init_method, val)
          end
        end
      end

    end

  end

  #private

  # The store of cached properties
  def cached_attributes_store
    @cached_attributes_store ||= {}
  end

end