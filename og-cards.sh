#!/bin/bash
postsdir="content/posts/"
ogtemplatedir="opengraph"
for dir in $postsdir*/
do
    dir=${dir%*/}      # remove the trailing "/"
    articledir=${dir##*/}    # everything after the final "/"
    tcardgen -f $ogtemplatedir/font/ \
        -t $ogtemplatedir/template.png \
        -c $ogtemplatedir/template.config.yaml \
        -o $postsdir/$articledir/images/og-card.png \
        $postsdir/$articledir/*.md
done