###Week3_4_02062018_RMarkdownCont_Terry##

#Notes: Cache chunk options are pretty involved. There is a guide online for help:~Dropbox\Biol801Evrn420s720\Wk03to04_ReproducibilityTransparency\BriefGuideToCaching
#Caching is important for long run times. Caching is easy to mess up but hard to kow when you've messed up.
#Key to chaching is to MAKE SURE THAT WHEN IT NEEDS TO RE-RUN AND GET A DIFFERENT ANSWER, R CAN RECOGNIZE THAT AUTOMATICALLY!
#Can give code w/ dependencies so that it will re-run at the correct time...when certain things change in the code. Big for modularity, too.

#TODAY: Plain Text!

# if you type more than 5 ======= produces a HUGE header  
 #use hashtag to set up headers/header sizes.
# 1 hashtag = big header, 2## smaller, on down to 6.:
  #header1
  ##header1
  ###header3
 #etc.
# **word** = bold
# _italics_ or *italics*
# urls:
  # [Link Name Here] (then past the url)
# Latex cheat sheet and pandoc cheat sheet will be your new best friends. look at them.
# ^superscript^ and ~subscript~
# Making lists:
#1. point one  (2 spaces indicate a new paragraph)
#Simple tables, default is left justify (rmd demos spacing on tables)
  #put tabs in between to keep spacings

#Tools_globalOptions_Code_display_and you can change your display. you can show white space characters

#Writing Math## 
#$X-i$ <- this puts it in line with a sentence. $$Number$$ makes it center justified
#single subscript = _ if you want 2 components...Xi,j  <- $X_{i,j}$ You need brackets to apply this to multiple characters
# \frac operator

#$$CIA=\frac{Al_{2}O_{3}}{(Al_{2}O_{3}+CaO+Na_{2}O+K_{2}O)} * 100$$
# you can render anything in LaTex. It can be done. Don't give up!
# \sum operator  \sum_{i=1}^n X_i
# \sqrt
# self sizing parenthesis \left(...\right)
# Greek Letters \alpha 
# Special symbols
# a \pm b
# x \ge 15 ...greater than
# x \le 0~~~\for all i     ...less than. you can use tildes in math ~~~ to create wite space
# Special functions
  #$$\int_0^{2\pi} \sin x~dx$$
  #gives you integral, sin()

#Matrices
#$$\begin{array}
#1 & 2 & 3\\ (use & to make white space. if want an ampersand type \&)
#4 & 5 & 6\\
#\end{array}



##Citations!Giving people credit!!

# you can either type up or attach a file that Rmd is set up to look for
# @Delgado-Baquerizo
#there are a lot of file formats...ENDNOTE can make .enl or .xml from your library. yay!
# or .bib.bibtex, lots of options
#bibliography: is the function to call a reference file. use this in the YAML
#generate files
# use @Name as the tag for how you call it in your text
# cheatsheet has a demo of footnotes for this. You can display citations any way you want!! Woo!!
# you can add comments to Rmd...<!--this is a comment-->

##you can use R package like RefManageR in R to manage your references
 #edit your reference list de nova in a text editor and save it as one of the formats above

##CitationStyle--there are many! 
#csl: Science.csl (.csl = citiation style language. there's a list of repositories on github... https://github.com/citation-style-language/styles



###RmdIntroCont.02082018##

#SimplePlots#
#3 R plot styles:
  #1. graphics--plot()
    #starts simple and build it up
  #2. ggplot2 - ggplot()
    #builds big and your pair down
    #has a ice cheatsheet Help>Cheatsheets>Data Visualization with ggplot2
  #3. lattice - xyplot()
#kniter::include_graphics("PathToTheFile.PNG") <- you can use a url here

#tables
#functions: knitr::kable() you make the table and then kable prints the table.
  #dataframes and matrices are common inputs. can specify output formats (laTex, html, markdown, pandoc)
#aggregate can do summaries of dataframes
  #aggregate(response~expl., data=, function to run)

  #stargazer() tables...
    #built to interact with a lot of outputs
    #for statistical model output objects

#inline code: 
  #typingsomestuff `r round(mean(airquality$temp),digits=1` &deg:C  You have to specify the engine you're using. surround with ``
  
#Checkpoint
  #only checkpoint() fuction
  #Is an R package time machine. if you want your code to be resistant to package updates (maintain reproducibility), package allows you to go back to today's CRAN in the future. 
    # creates a snapshot folder to install packages. library located at ~/.checkpoint
    # scans you project folder for all packages used. Specifically, it searches for all instances of library(), and require() in your code
    #load with library(checkpoint)
    #then checkpoint(2018-02-09)

#YAML options
---Title: ""
author: "" 
output: #key: value
  pdf_document: 
    fig_caption: yes
    fig_width:4.5
    highlight:zenburn
    keep_text: yes -- #"do you want to keep the intermediary RMD file?"
    number_sections: yes
    df_print: #dataframe printing option: kable
fontsize: 11pt
params:
  today: !r Sys.Date()
 #this specifice parameters that take args from R (or engine you specify) and assign that to parameter you give it

#build log:
  # for own interest...you get rmd steps to process the document across various chunks
  # shows what you'd have to do in the commandline to get your document, too. You save lots of work. Woo!
library(checkpoint);
checkpoint(2018-02-09)
