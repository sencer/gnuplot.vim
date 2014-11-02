function! GnuplotInit()
ruby << EOR
  require 'pty'
  require 'expect'

  class Gnuplot

    attr_accessor :str, :plot, :last, :label, :arrow, :object

    def initialize
      @in, @out, @pid = PTY.spawn 'gnuplot --persist'
      getstr       # dump header etc
      @str = []    #
      @label = []
      @arrow = []
      @obj = []
      @cmd = ""
      @plot = false
    end

    def exec_line cmd #, ln = 0
      #cmd.strip!
      if cmd.end_with? '\\'
        @cmd += cmd.chop
      else
        @last = "#{@cmd} #{cmd}".strip
        @out.puts @last
        @last =~ /^(s?plot|set multiplot)/ ? @plot = true : (@plot && replot)
        # @last = create_id(@last) if @last =~ /set (arrow|label|obj) \D/
        @cmd = ""
        getstr
        "#{@last}#{(': '+@str.join(' ')) if @str.length > 0}"
      end
    end

    def replot
      @out.puts 'replot'
    end

    def exec cmd
      @out.puts cmd
    end

    # def create_id text, ln = 0
    #   case text
    #   when /set label/
    #     @label.push ln
    #     text.gsub!("set label", "set label #{@label.length + 1000}")
    #   when /set arrow ?!\d/
    #     @arrow.push ln
    #     text.gsub!("set arrow", "set arrow #{@arrow.length + 1000}")
    #   when /set ob ?!\d/
    #     @obj.push ln
    #     text.gsub!("set obj", "set obj #{@obj.length + 1000}")
    #   end
    #   text
    # end

    def getstr
      @str = @in.expect(/.*plot>/)
        .map{|v| v.split("\r\n")}
        .flatten
        .map(&:strip)
      @str.pop
      @str.shift
      @str.delete_if{|v| v == '^' || v == ''}
    end
  end
  $gnuplot = Gnuplot.new()
EOR
endfunction

if has('ruby')
  call GnuplotInit()
  ", $curbuf.line_number
  nnoremap <buffer> <Space> :ruby print $gnuplot.exec_line($curbuf.line)<CR>j
  vnoremap <buffer> <Space> :rubydo print $gnuplot.exec_line($_)<CR>
  nnoremap ]g :ruby print $gnuplot.exec('set multiplot next')<CR>
  nnoremap [g :ruby print $gnuplot.exec('set multiplot prev')<CR>
endif
