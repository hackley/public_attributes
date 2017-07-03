#
# Provides a to_public instance method for filtering out sensative data.
#
# Public attributes are defined with the public_attributes class method, which
# whitelists attributes that are ok to send to the client, JSON endpoints, etc.
#

require 'json'

module PublicAttributes
  @_public_attributes ||= {}

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def self.add(class_name, attr_list)
    @_public_attributes[class_name] = *attr_list
    @_public_attributes[class_name].uniq!
  end

  def self.for(klass)
    self.instance_variable_get(:@_public_attributes)[klass.name]
  end

  def self.reset
    self.instance_variable_set(:@_public_attributes, {})
  end

  module ClassMethods
    def public_attributes(*attr_list)
      PublicAttributes.add(name, attr_list)
    end

    def to_public
      if defined?(ActiveRecord) && (self < ActiveRecord::Base)
        where(nil).map do |instance|
          instance.to_public
        end
      else
        raise Error 'This method is only available for ActiveRecord classes. '\
                    'Please re-implement if you\'d like to call to_public on '\
                    'a custom collection.'
      end
    end
  end

  def to_public
    hash = {}
    all_public_attributes.each do |attr|
      value = self.send(attr)
      if value.respond_to? :to_public
        hash[attr] = value.to_public
      else
        hash[attr] = value
      end
    end
    return hash
  end

  def to_json
    JSON.generate self.to_public
  end

private

  def all_public_attributes
    attributes = PublicAttributes.for(self.class)
    if defined?(ActiveRecord) && self.is_a?(ActiveRecord::Base)
      attributes += [:created_at, :updated_at]
      attributes.push(:errors) unless self.errors.keys.empty?
    end
    return attributes
  end

end
