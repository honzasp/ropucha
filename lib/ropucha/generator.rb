module Ropucha
  class Generator
    def initialize
      @tsk = "".force_encoding("ascii")
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

    attr_reader :tsk

    def main
      o_line "main"
      o_line "begin"
      yield self
      o_line "end"
    end

    def comment(text)
      text.split("\n").each do |line|
        o_line "// param_text:#{line}"
      end
    end

    def load(param_dest, param_src)
      o_line "load param_dest:#{param_dest} param_src:#{param_src}"
    end

    def line(l)
      @tsk << l << "\n"
    end

    def o_line(l)
      @tsk << "o " << l << "\n"
    end

    def m_line
      @tsk << "- \n"
    end

    private

    def magic_bytes
      @tsk << bytes_to_str([239, 187, 191])
    end

    def checksum_bytes
      ch = checksum
      @tsk << bytes_to_str([(ch >> 8) & 255, ch & 255])
    end

    def checksum
      @tsk.bytes.inject(-1){|ch,b| (ch-b) }
    end

    def bytes_to_str(bytes)
      bytes.map(&:chr).join("")
    end
  end
end
