module Ropucha
  module Nodes

    class DeviceNameDef < Node
      def initialize(syntax_node, device_name, device_id)
        super(syntax_node)
        @device_name = device_name
        @device_id = device_id
      end

      attr_reader :device_name
      attr_reader :device_id

      def to_sexp
        [:device_name_def, device_name.to_sexp, device_id.to_sexp]
      end
    end

    class DeviceId < Node
      def initialize(syntax_node, device_type, device_num = nil)
        super(syntax_node)
        @device_type = device_type
        @device_num = device_num
      end

      attr_reader :device_type
      attr_reader :device_num

      def has_number?
        !!device_num
      end

      def to_sexp
        if has_number?
          [:device_id, device_type, device_num]
        else
          [:device_id, device_type]
        end
      end
    end

    class DeviceName < Node
      def initialize(syntax_node, identifier)
        super(syntax_node)
        @identifier = identifier
      end

      attr_reader :identifier

      def to_sexp
        [:device_name, identifier]
      end
    end

    class DeviceProperty < Node
      def initialize(syntax_node, device, property_name)
        super(syntax_node)
        @device = device
        @property_name = property_name
      end

      attr_reader :device
      attr_reader :property_name

      def to_sexp
        [:device_property, device.to_sexp, property_name]
      end
    end

  end
end
