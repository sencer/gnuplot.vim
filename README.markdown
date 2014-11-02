gnuplot.vim
===========

This is a fork of [vlaadbrain/gnuplot](https://github.com/vlaadbrain/gnuplot.vim)
for gnuplot syntax highlighting. I added some Ruby code to enable interaction
with a gnuplot session running in the background. Code is highly untested and
probably not working for many corner cases. What it does is:

- Creates a `$gnuplot` Ruby global variable, which has methods:
  * `.exec(cmd)`to execute a gnuplot command
  * `.replot` to replot
  * `.err` to return the output of last gnuplot command
  * `.last` to return the last command issued to gnuplot
- Maps `<Space>` in Visual and Normal mode to send line/range to Gnuplot.
- Maps `[g` and `]g` in Normal mode to move to previous/next plot in Multiplot
  mode.

This fork also sets `commentstring` for the gnuplot.

This is a simple plugin, just sends the lines to Gnuplot as is. This has some
shortcomings, for example: Assume you have a line like `set label "x" at 0, 0`
that is already plotted. If you change this line to `set label "x" at 1, 1` and
re-send to Gnuplot, it will not change the label but add a new label just like
it would do in a Gnuplot session. To avoid this kind of behavior I suggest
always giving and id to labels, arrows and objects (e.g. `set label 1 "x" at 1,
1`).

How to Install
==============

I suggest using [junegunn/vim-plug](https://github.com/junegunn/vim-plug).
