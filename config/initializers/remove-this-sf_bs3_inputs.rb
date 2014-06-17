inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}"
  hack = %|
    module SimpleForm
      module Inputs
        class #{superclass}
          def input_html_classes
            super.push('form-control')
          end
        end
      end
    end
  |
  eval(hack)

end