#!/bin/sh
##
##  ``LabVIEW Crashes on macOS 11 Big Sur''
##
##    https://knowledge.ni.com/KnowledgeArticleDetails?id=kA03q000000YIJsCAO&l=en-US
##
for i in com.ni.ni4882.gpibExplorer \
         com.ni.ni4882.gpibtsw      \
         com.ni.framework.DriverWizard \
         'com.ni.framework.NI-VISA Configuration' \
         com.ni.framework.NIvisaic  \
         com.ni.framework.NIIOTrace 
do
    echo "Writing defaults to $i"
    defaults write "$i" NSGraphicsContextAllowOverRestore -bool YES
    defaults write "$i" NSViewAllowsRootLayerBacking -bool NO
done
