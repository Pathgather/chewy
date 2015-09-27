require 'active_support/callbacks'

module Sequel
  module Plugins
    # This Sequel plugin adds support for chewy's model-observing hook for
    # updating indexes after model save or destroy.
    #
    # Usage:
    #
    #   # Make all model subclasses support the `update_index` hook (called
    #   # before loading subclasses).
    #   Sequel::Model.plugin :chewy_observe
    #
    #   # Make the Album class support the `update_index` hooks.
    #   Album.plugin :chewy_observe
    #
    #   # Declare one or more `update_index` observers in model.
    #   class Album < Sequel::Model
    #     update_index('albums#album') { self }
    #   end
    #
    module ChewyObserve
      extend ::Chewy::Type::Observe::Helpers

      # def self.apply(model)
      #   model.instance_eval do
      #     include ActiveSupport::Callbacks
      #     define_callbacks :commit, :save, :destroy
      #   end
      # end

      # Class level methods for Sequel::Model
      #
      module ClassMethods
        def update_index(type_name, *args, &block)
          callback_options = ChewyObserve.extract_callback_options!(args)
          update_proc = ChewyObserve.update_proc(type_name, *args, &block)
          after_commit(&update_proc)
        end
      end

      # Instance level methods for Sequel::Model
      #
      # module InstanceMethods
      #   def after_commit
      #     run_callbacks(:commit) do
      #       super
      #     end
      #   end

      #   def after_save
      #     run_callbacks(:save) do
      #       super
      #     end
      #   end

      #   def after_destroy
      #     run_callbacks(:destroy) do
      #       super
      #     end
      #   end
      # end
    end
  end
end
