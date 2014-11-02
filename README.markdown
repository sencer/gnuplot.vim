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
- Maps <Space> in Visual and Normal mode to send line/range to Gnuplot.
- Maps [g and ]g in Normal mode to move to previous/next plot in Multiplot mode.

This fork also sets commentstring for the gnuplot.

How to Install
==============

I suggest using [junegunn/vim-plug](https://github.com/junegunn/vim-plug).
