class DateSearchController < ApplicationController
  def search
    root_directory = params[:root_directory]
    @results = search_dates(root_directory)
  end

  private

  def search_dates(root_directory)
    valid_dates = []
    invalid_dates = []

    # Specify the directory where your .docx files are located
    docx_directory = root_directory # Use the provided root_directory parameter

    # Iterate through .docx files in the directory
    Dir.glob(File.join(docx_directory, '*.docx')).each do |docx_file|
      doc = Docx::Document.open(docx_file)

      # Initialize a variable to check for valid dates in this document
      valid_dates_found = false

      # Iterate through paragraphs in the document
      doc.paragraphs.each do |paragraph|
        text = paragraph.to_s
        # Search for dates in the paragraph
        dates = text.scan(/\d{2}-\d{2}-\d{4}/)

        # If dates are found in the paragraph, check their format
        valid_dates = dates.select { |date| valid_date_format?(date) }
        if valid_dates.any?
          valid_dates_found = true

          # Add the date and content to the valid_dates array
          valid_dates << { path: docx_file, date: valid_dates[0], content: text }
        end
      end

      if valid_dates_found
        files_with_valid_dates << docx_file
      else
        files_with_invalid_dates << docx_file
      end
    end

    results = {
      valid_dates: valid_dates,
      invalid_dates: invalid_dates
    }

    return results
  end

  # Define a method to check if a date is in the correct format (dd-mm-yyyy)
  def valid_date_format?(date)
    date.match?(/^\d{2}-\d{2}-\d{4}$/)
  end
end
