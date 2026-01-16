# resume-parser

## Roadmap
- [ ] implement 'parse' button (maybe think of a better name).   
      converts from md to latex then either shows the user an error or complete status.
    - [ ] produce some failing md test cases
        - [x] download hoogle cli
        - [x] understand liftM, runMaybeT stackoverflow post 
        - [x] refactor parseLine using unlawful \*> 
        - [ ] refactor Line
    - [ ] QuickCheck?
    - [ ] display basic errors on front end
- [ ] implement 'render' button 
    - [ ] show preview box
- [ ] sanitise input
- [ ] fix intro email link
- [ ] sublists (see julie resume)
- [ ] block title wrap (see scott resume)
- [ ] convert some latex resume templates into my style
- [ ] work on the front end. probs react
- [ ] implement italics, bolds, strikethroughs

## Features I want
- [ ] AI that converts resume pdfs into md
- [ ] database that saves your md files
- [ ] linter
    - [ ] spell check
    - [ ] adds missing full stops, capital letters
    - [ ] auto linter
- [ ] tutorial blog
- [ ] $1/100 years paid subscription
- [ ] frontend error messages
    - [ ] errors underlined 
    - [ ] error lines highlighted red
    - [ ] error sidebar messages show on hover
- [ ] resume show case section
- [ ] ability to write arbitrary latex if you have
    an account? could get latex injected
- [ ] choose from a variety of resume templates
- [ ] be able to convert from orgmode as well as md
- [ ] upload images and embed them in resumes

