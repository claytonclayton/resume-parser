# resume-parser

## TODO

### Done
- fixed Dots spacing
- fix flats
    - removed : 
    - fix spacing 
    - divided flats and dots
- fix subBlock
    - added subBlock tex command
    - collated blocks and subblocks
- write cli
    - claytons
- allowed sections to have dots
- converted scotts resume to md

### Small
- fix intro email link
- remake jakes resume
- implement sublists (see julie's resume)
- block title text wrapping (see scott's resume)
- make gen.sh more robust by addings to checks to arguments
- make nested cases of Main more pretty
- make Resume.Parser data types more clean
    - consider sum of record syntaxes
    - consider refactoring Positioned
- test other latex characters and add to escapees 
    - \_, %, #
- review pandoc markdown to latex skills

### Big
- implement error messages
- implement italics, bolds, strikethroughs
- implement escapes of #, - etc. 

### Roadmap
- [ ] understand liftM, runMaybeT stackoverflow post 
    - https://stackoverflow.com/questions/15441956/how-do-i-make-a-do-block-return-early
- [ ] learn how to use hoogle
    - [ ] download hoogle cli
- [ ] implement basic paste md -> download pdf pipeline on frontend
    - [ ] discern roughly how frontend will display errors
- [ ] sanitise input

### Features I want
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

