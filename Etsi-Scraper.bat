@echo off

cd etsi-scraper

echo If you have never run this script, your response is meaningless.
echo If you have run this script before, you can choose to redo everything,
echo or only update to add new listings. 
echo Updating will be faster btw.
echo If you want to redo everything, type yes, y or something similar.
echo If update existing only, just hit enter and it will probably work

set /p response=Update everything?: 



"C:\Program Files\R\R-4.3.0\bin\Rscript.exe" etsi-scraper.R %response%