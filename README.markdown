gnuplot.vim
===========

This is a fork of 
[vlaadbrain/gnuplot](https://github.com/vlaadbrain/gnuplot.vim)
for gnuplot syntax highlighting.

This also sets `commentstring`, `makeprg` and also makes `K` work for gnuplot 
help.

I also added some Ruby code to enable interaction with a gnuplot session 
running in the background. This part is is highly untested and
probably not working for many corner cases. What it does is:

- Creates a `$gnuplot` Ruby global variable, which has methods:
  * `.exec(cmd)`to execute a gnuplot command
  * `.replot` to replot
  * `.err` to return the output of last gnuplot command
  * `.last` to return the last command issued to gnuplot
- Maps `<Space>` in Visual and Normal mode to send line/range to Gnuplot.
- Maps `[g` and `]g` in Normal mode to move to previous/next plot in Multiplot
  mode.

This is a simple plugin, just sends the lines to Gnuplot as is. This has some
shortcomings, for example: Assume you have  `set label "x" at 0, 0` line, that
is already plotted. If you change this line to `set label "x" at 1, 1` and
re-send to Gnuplot, it will not update the label position but add a new label
--just like it would do in a Gnuplot session. To avoid this kind of behavior I
suggest always giving an id to labels, arrows and objects (e.g. `set label 1
"x" at 1, 1`).

How to Install
==============

I suggest using [junegunn/vim-plug](https://github.com/junegunn/vim-plug).
