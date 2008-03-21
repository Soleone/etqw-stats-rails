# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	
	def date_view(time)
		date = time.to_date
		view = Date::DAYNAMES[date.cwday]
		view += ' <b style="font-size: 120%;">' << print_number(date.month) << '-' << print_number(date.mday) << '</b> ' << 
			print_number(date.year) << ' ' << '<span style="font-size: 80%;">(' << print_number(time.hour) << ':' << 
			print_number(time.min) << ')</span>'
		view
	end

	def print_date(time)
		date = time.to_date
		view = Date::DAYNAMES[date.cwday]
		view += print_number(date.month) << '-' << print_number(date.mday) << '</b> ' << 
			print_number(date.year) << ' (' << print_number(time.hour) << ':' << print_number(time.min) << ')'
		view
	end	
	
	private
	def print_number(number)
		number < 10 ? string = '0' + number.to_s : number.to_s
	end
end
