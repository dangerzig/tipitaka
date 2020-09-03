## Test environments
* local OS X install, R.4.0.2
* devtools::check_win_release()

## R CMD check results
There were no ERRORs or WARNINGSs.

There were 2 NOTES:

* N  checking installed package size ...
     installed size is  9.2Mb
     sub-directories of 1Mb or more:
       data   9.1Mb
       
  This is primarily a data package containing the complete scriptures of Therevadin Buddhism, known as the Tipitaka or Pali Canon. 
  
* Checking R code for possible problems ... NOTE
  pali_string_fix: no visible binding for '<<-' assignment to
    ‘tipitaka_names’
  pali_string_fix: no visible binding for global variable
    ‘tipitaka_names’
  pali_string_fix: no visible binding for '<<-' assignment to
    ‘sutta_pitaka’
  pali_string_fix: no visible binding for global variable ‘sutta_pitaka’
  pali_string_fix: no visible binding for '<<-' assignment to
    ‘vinaya_pitaka’
  pali_string_fix: no visible binding for global variable ‘vinaya_pitaka’
  pali_string_fix: no visible binding for '<<-' assignment to
    ‘abhidhamma_pitaka’
  pali_string_fix: no visible binding for global variable
    ‘abhidhamma_pitaka’
  Undefined global functions or variables:
    abhidhamma_pitaka sutta_pitaka tipitaka_names vinaya_pitaka
    
    These are all globals defined and distributed with this package. The function pali_string_fix is a shortcut for unescaping the Unicode characters in these strings.

## Downstream dependencies

There are currently no downstream dependencies for this package.


