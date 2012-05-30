module Ropucha
  class Generator
    def initialize
      @tsk_lines = []
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
      @tsk_lines.join("\n")
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

    def break
      o_line "break"
    end

    private

    def block_
      o_line "begin"
      yield self
      o_line "end"
    end

    def line(l)
      @tsk_lines.push l
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
      @tsk_lines.push "" if @tsk_lines.empty?
      @tsk_lines.last << str
    end
  end
end
