function! GnuplotInit()
ruby << EOR
  require 'pty'
  require 'expect'

  class Gnuplot

    attr_reader :last # , :plot, :label, :arrow, :object

    def initialize
      @in, @out, @pid = PTY.spawn 'gnuplot --persist'
      geterr       # dump header etc
      @err = []    #
      # @label = []
      # @arrow = []
      # @obj = []
      @cmd = ""
      @plot = false
    end

    def replot
      @out.puts 'replot'
    end

    def exec cmd
      @last = cmd
      @out.puts cmd
    end

    def exec_line cmd #, ln = 0
      if cmd.end_with? '\\'
        @cmd += cmd.strip.chop
      else
        @last = "#{@cmd} #{cmd}".strip
        @out.puts @last
        @last =~ /^(s?plot|set multiplot)/ ? @plot = true : (@plot && replot)
        # @last = create_id(@last) if @last =~ /set (arrow|label|obj) \D/
        @cmd = ""
        geterr
      end
      err
    end

    def err
        @err.join(' ') if @err.length > 0
    end

private

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

    def geterr
      @err = @in.expect(/.*plot>/)
        .map{|v| v.split("\r\n")}
        .flatten
        .map(&:strip)
      @err.pop
      @err.shift
      @err.delete_if{|v| v == '^' || v == ''}
    end
  end

  $gnuplot = Gnuplot.new()
EOR
endfunction

setlocal commentstring=#\ %s

if has('ruby')
  call GnuplotInit()
  ", $curbuf.line_number
  nnoremap <buffer> Q :ruby print $gnuplot.exec_line($curbuf.line)<CR>j
  vnoremap <buffer> Q :rubydo $gnuplot.exec_line($_)<CR>:ruby print $gnuplot.err<CR>
  nnoremap ]g :ruby print $gnuplot.exec('set multiplot next')<CR>
  nnoremap [g :ruby print $gnuplot.exec('set multiplot prev')<CR>
endif
