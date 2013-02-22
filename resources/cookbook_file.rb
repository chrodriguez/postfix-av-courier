actions :create
default_action :create if defined?(default_action)

attribute :postmap, :kind_of => [TrueClass, FalseClass], :default => false
