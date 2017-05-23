# Scripts for managing a Safari Tech Books collection
This work was built on collection management processes originally developed by Orion Pozo, Librarian Emeritus.

## Usage (merge_list_usage.R)
The usage report that Safari generates does not include all of the books in your collection, so you will need to merge the usage report with the report of all books on your account Bookshelf.
### Run two Safari reports
* Login to the Safari Backoffice using Safari credentials: [https://secure.safaribooksonline.com/bo](https://secure.safaribooksonline.com/bo)
* Run two reports from Reports tab

 1. **All Books Contained in Account Bookshelf**
    * Format: CSV

 2. **Book Report 2 (R4)**
   * Format: XLS (CSV format is missing data)
    * Choose preferred time range (Note: If you do not select the 1st of the month at the beginning of the range, you will not be given data for that month. If the end of your range is in the future or in the middle of a month, you will not be given data for that month.)

* Modify the **Book Report 2** Excel file
  * Open .xls file that you saved
  * Delete the top 7 rows and the orange row, leaving only the row that says Publisher, Platform, etc.
  * Name the first column "title" (must be lowercase)
  * Save as .csv

### Locate (or create) your notes file
This script will add a notes column so that you can indicate when a book was added as a suggested purchase (or other notes). The notes file should be saved as a .csv and at the least contain a column titled "notes" and a column titled "isbn" (do not include non-numbers, such as hyphens, in the ISBNs).


### Run R script
* Open the *merge_list_usage.R* script
* Change the working directory as needed
* Change the filenames to what you used for the two reports
* Run

## Titles Added (books_added.R)
Use this script if you have added many books at once and need to send a list to A&D to add to the catalog.
### Run Safari report
* Login to the Safari Backoffice using Safari credentials: [https://secure.safaribooksonline.com/bo](https://secure.safaribooksonline.com/bo)
* Run **ProQuest Bookshelf Urls by Account** report
  * Format: CSV

### Run R script
* Open the *books_added.R* script
* Change the working directory as needed
* Change the filename to what the name you used for the report
* Run


## Titles Dropped (books_dropped.R)
While Safari offers a report for books added, they do not offer a report for books dropped. Use this script to find out if Safari has removed any of the books from your list and/or to generate a list of dropped books to share with A&D so they can be removed from the catalog.

In order to use this script, you'll need to be running and saving regular **All Books Contained in Account Bookshelf** reports since you cannot run "historical" booklist reports.
### Create a merged list
* Use the *merge_list_usage.R* script (see instructions above)

### Locate (or create) previous merged list
* Find the merged list you created the last time you updated Safari OR create a merged list for a previous time period using the instructions above.

### Run R script
* Open the *books_dropped.R* script
* Change the working directory as needed
* Change the filenames to the current and the previous merged lists
* Run
