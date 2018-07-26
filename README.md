# cowtip #

Augment installed fortunes with some nerdy unix/bash ProTips(tm), and pipe `fortune` output through `cowsay` or `cowthink` using a fun assortment of custom themed `.cow` files

Author: Dustin Goldman, `dusto@goldmans.net`
[@roosto on github](https://github.com/roosto)
[@roosto on twitter•com](https://twitter.com/roosto)

## Description

This is designed to be run when logging in. And can be invoked by simply running `cowtip/cowtip.bash` (with no args).

## Setup ##

You’ll need to have `fortune` and `cowsay` already installed on your machine. This fine programs can typically be found and installed by your favorite package manager.

Once you have those, you’ll need to run `strfile` to make `.dat ` files from the `fortune` cookie files in `cowtip/fortunes`. Running the below will take you through those steps:

    `cowtip/cowtip.bash --validate`

N.B. if you make changes to the `fortune` cookie files, you’ll have to go through these setup steps again.

Lastly, for maximum fun, I would suggest that you run this script at login by putting something like this in your `.bash_profile`:

    shopt -q login_shell && ~/cowtip/cowtip.bash

## Configuration ##

You need not configure `cowtip` other than the steps described above.

None the less, in the spirit of both `fortune` and `cowsay`, `cowtip` is quite configurable (perhaps to a ridiculous degree).

`cowtip` by default will:

* pull fortunes from both `cowtip/fortunes` and the default fortunes dir on your system with a 50/50 mix between those two sources
* randomly invoke either `cowsay` or `cowthink`
* invoke `cowsay`/`cowthink` with a random file from `cowtip/cows` and the `-n` switch to preserve whitespace when printing out messages
* save the output of `fortune` into `cowtip/last.txt`, in case it you would like to refer back to its wisdom

For more on customization see `fortune(6)`, `cowsay(1)`, `cowtip/.cowtip.conf`, and `cowtip/cowtip.bash` for the nitty gritties on how to further configure `cowtip`

## Contributing ##

Improvements are welcome.

In particular, please, Please, PLEASE, submit expansions and improvements to the unix/bash tips fortune files.

Pull Requests are welcome!

### Formatting for fortune Cookie Files ###

* Individual fortunes in these files are separated by lines containing just a single `%`
* All fortunes should be hard wrapped so that **max line width is 75 characters**
* Please do follow the existing style conventions in the fortune files
