require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_numbers(number)
  number = number.gsub(/[^0-9]/, '')
  if number.nil? || number.length < 10 || number.length > 11 || (number.length == 11 && number[0] != 1)
    number = '-' * 10
  elsif number.length == 11 && number[0] == 1
    number = number[1..10]
  end
  "(#{number[0..2]}) #{number[3..5]}-#{number[6..9]}"
end

def increment_day_count(counts, datetime)
  datetime = datetime.split(' ')
  date = Date.strptime(datetime[0], '%m/%d/%Y')
  counts[date.wday] += 1
end

def increment_hour_count(counts, datetime)
  datetime = datetime.split(' ')
  hr = datetime[1].split(':')[0]
  counts[hr] += 1
end

def largest_hash_key(hash)
  key_value = hash.max_by { |_key, value| value }
  key_value[0]
end

def number_day_to_string(num_day)
  { 0 => 'Sunday', 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday',
    4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday' }[num_day]
end

def show_phone_numbers(hash)
  hash.each { |_key, value| puts value }
end

def most_active_hour(counts_hr)
  puts "The most active registration hour is #{largest_hash_key(counts_hr)}:00 hours."
end

def most_active_day(counts_day)
  puts "The most active registration day is #{number_day_to_string(largest_hash_key(counts_day))}."
end

def print_assignment(phone_book, counts_hr, counts_day)
  puts "\nAssigmment: Clean Phone Numbers"
  show_phone_numbers(phone_book)
  puts "\nAssignment: Time Targeting"
  most_active_hour(counts_hr)
  puts "\nAssignment: Days of the Week Targeting"
  most_active_day(counts_day)
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('./../output') unless Dir.exist?('./../output')

  filename = "./../output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'
template_letter = File.read('./../forms/form_letter.erb')
erb_template = ERB.new(template_letter)
contents = CSV.open(
  './../attendees/event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
phone_book = {}
counts_day = Hash.new(0)
counts_hr = Hash.new(0)
contents.each do |row|
  id = row[0]

  first_name = row[:first_name]

  last_name = row[:last_name]

  zipcode = clean_zipcode(row[:zipcode])

  phone = clean_phone_numbers(row[:homephone])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)

  datetime = row[:regdate]
  phone_book[first_name << last_name] = phone
  increment_hour_count(counts_hr, datetime)
  increment_day_count(counts_day, datetime)
end
print_assignment(phone_book, counts_hr, counts_day)
