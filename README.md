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

### Roadmap
- [ ] implement basic paste md -> download pdf pipeline on frontend
    - [ ] discern roughly how frontend will display errors
- [ ] sanitise input
