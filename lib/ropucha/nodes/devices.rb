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

      def context(ctx)
        ctx.device_name(device_name.identifier, device_id)
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

      def tsk_device_spec
        if has_number?
          "#{device_type}:#{device_num}"
        else
          device_type
        end
      end

      def tsk_device_type
        device_type
      end

      def to_sexp
        if has_number?
          [:device_id, device_type, device_num]
        else
          [:device_id, device_type]
        end
      end

      def context(ctx)
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

      def context(ctx)
        @context = ctx
      end
      
      def tsk_device_spec
        @device_id = @context.device_id_by_name(identifier)
        if @device_id
          @device_id.tsk_device_spec
        else
          raise CompileError, "Unknown device name '#{identifier}'"
        end
      end

      def tsk_device_type
        @device_id = @context.device_id_by_name(identifier)
        @device_id.tsk_device_type
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

      def context(ctx)
        device.context(ctx)
      end

      def to_param
        tsk_device_spec = device.tsk_device_spec
        tsk_device_type = device.tsk_device_type
        property_id = DEVICE_PROPERTY_ID[tsk_device_type][property_name]
        "#{tsk_device_spec}:#{property_id}"
      end

      def to_param_dest(g)
        yield to_param
      end

      def to_param_src(g)
        yield to_param
      end
    end

  end
end
