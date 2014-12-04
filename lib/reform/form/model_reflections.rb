# ModelReflections will be the interface between the form object and form builders like simple_form.
#
# This module is meant to collect all dependencies simple_form needs in addition to the ActiveModel ones.
# Goal is to collect all methods and define a reflection API so simple_form works with all ORMs and Reform
# doesn't have to "guess" what simple_form and other form helpers need.
module Reform::Form::ModelReflections
  def self.included(base)
    base.extend ClassMethods
    base.register_feature self # makes it work in nested forms.
  end

  module ClassMethods
    # Delegate reflect_on_association to the model class to support simple_form's
    # association input.
    def reflect_on_association(*args)
      model_name.name.constantize.reflect_on_association(*args)
    end
  end

  # Delegate column for attribute to the model to support simple_form's
  # attribute type interrogation.
  def column_for_attribute(name)
    model_for_property(name).column_for_attribute(name)
  end

  def has_attribute?(name)
    model_for_property(name).has_attribute?(name)
  end

  def defined_enums
    return model.defined_enums unless is_a?(Reform::Form::Composition)

    model.each.with_object({}) { |m,h| h.merge! m.defined_enums }
  end

  # this should also contain to_param and friends as this is used by the form helpers.
end
