module Ropucha
  class Generator
    TMP_VAR_PREFIX = "_tmp_"
    ARG_VAR_PREFIX = "_arg_"
    RETURN_VAR_PREFIX = "_return_"

    RESERVED_VAR_PREFIX_REGEXP = /^(#{TMP_VAR_PREFIX}|#{ARG_VAR_PREFIX}|#{RETURN_VAR_PREFIX})/

    def self.identifier_to_tsk_var(identifier)
      identifier_to_tsk(identifier).gsub(RESERVED_VAR_PREFIX_REGEXP, "x")
    end

    def self.identifier_to_faddr(identifier)
      identifier_to_tsk(identifier)
    end

    def self.identifier_to_tsk(identifier)
      identifier.gsub(/\s/, "_").gsub(/[^a-zA-Z_]/, "").gsub(/^$/, "x")
    end


    def initialize
      @tsk = ""
      @free_tmp_vars = []
      @tmp_var_counter = 0
    end

    def tmp_var
      unless @free_tmp_vars.empty?
        var = @free_tmp_vars.pop
      else
        @tmp_var_counter += 1
        var = "#{TMP_VAR_PREFIX}#@tmp_var_counter"
      end

      yield var
      @free_tmp_vars.push(var)
    end

    def arg_var(faddr, arg_index)
      "#{ARG_VAR_PREFIX}#{faddr}_#{arg_index+1}"
    end

    def return_var(faddr)
      "#{RETURN_VAR_PREFIX}#{faddr}"
    end

    attr_accessor :version
    attr_accessor :platform

    def file
      magic_bytes
      line "version #{version}"
      line "platform #{platform}"

      yield self

      checksum_bytes
    end

    def tsk
      @tsk
    end

    def main
      o_line "main"
      block_ {|g| yield g}
    end

    def comment(text)
      text.split("\n").each do |line|
        o_line "// param_text:#{line}"
      end
    end

    def load(param_dest, param_src)
      o_line "load param_dest:#{param_dest} param_src:#{param_src}"
    end

    def compute(param_dest, operator, left, right)
      o_line "compute param_dest:#{param_dest} param_src:#{left} aop:#{operator} param_src:#{right}"
    end

    def if_(conditions)
      o_line "if #{conditions} rop:then"
      block_ {|g| yield g}
    end

    def elseif_(conditions)
      o_line "elseif #{conditions} rop:then"
      block_ {|g| yield g}
    end

    def else_
      o_line "else"
      block_ {|g| yield g}
    end

    def while_(conditions)
      o_line "while #{conditions} rop:then"
      block_ {|g| yield g}
    end

    def while_1
      o_line "while(1)"
      block_ {|g| yield g}
    end

    def for(var, from, to)
      o_line "for param_var:#{var} param_src:#{from} param_src:#{to}"
      block_ {|g| yield g}
    end

    def function(faddr)
      o_line "function faddr_src:#{faddr}"
      block_{|g| yield g}
    end

    def call(faddr)
      o_line "call faddr_dest:#{faddr}"
    end

    def break
      o_line "break"
    end

    def return
      o_line "return"
    end

    private

    def block_
      o_line "begin"
      yield self
      o_line "end"
    end

    def line(l)
      @tsk << "#{l}\n"
    end

    def o_line(l)
      line "o #{l}"
    end

    def m_line
      line "- #{l}"
    end

    def magic_bytes
      raw bytes_to_str([239, 187, 191])
    end

    def checksum_bytes
      ch = checksum
      raw bytes_to_str([(ch >> 8) & 255, ch & 255])
    end

    def checksum
      tsk.bytes.inject(-1){|ch,b| (ch-b) }
    end

    def bytes_to_str(bytes)
      bytes.map(&:chr).join("")
    end

    def raw(str)
      @tsk << str
    end
  end
end
